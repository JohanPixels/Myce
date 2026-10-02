import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../capture/capture_sheet.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../entities/presentation/entity_search_delegate.dart';
import '../../features/sync/sync_button.dart';
import '../../features/sync/sync_repository.dart';
import '../database/database_provider.dart';
import 'app_sections.dart';

/// Sincroniza sola, sin depender de que el usuario toque el botón manual:
/// una vez al entrar (hidrata un dispositivo nuevo con lo que ya existe en
/// remoto) y cada vez que la app vuelve a foreground (trae lo que se editó
/// en el otro dispositivo mientras esta instancia estaba en background). El
/// timer periódico cubre el caso de dejar la app abierta y en foreground un
/// rato largo sin cambiar de app. `syncNow` es push+pull y es barato cuando
/// no hay nada dirty ni nada nuevo remoto, así que no hace falta ser
/// quirúrgico con la cadencia — el botón manual (`SyncButton`) sigue
/// disponible para forzar un ciclo ya mismo.
const _syncOnResumeDebounce = Duration(seconds: 5);
const _periodicSyncInterval = Duration(minutes: 3);

/// Shell persistente del carrusel + FAB, montado por `StatefulShellRoute`
/// (ver app_router.dart). Cada rama tiene su propio `Navigator` interno:
/// empujar un detalle de Entity o Task queda anidado DENTRO de la rama, así
/// que este `Scaffold` (tab strip + FAB) sigue visible siempre, incluso
/// adentro de una nota — y arrastrar el dedo hacia los costados cambia de
/// rama sin perder en qué pantalla estabas parado adentro de cada una.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  Timer? _periodicSync;
  DateTime? _lastSyncAttempt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _triggerSync(); // hidrata al abrir — clave para un dispositivo nuevo
    _periodicSync = Timer.periodic(
      _periodicSyncInterval,
      (_) => _triggerSync(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _periodicSync?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _triggerSync();
  }

  /// Fire-and-forget — patrón "UI optimista": nunca bloquea la UI ni muestra
  /// error si falla (retry en el próximo ciclo, igual que el push).
  void _triggerSync() {
    final now = DateTime.now();
    if (_lastSyncAttempt != null &&
        now.difference(_lastSyncAttempt!) < _syncOnResumeDebounce) {
      return; // evita duplicar el ciclo si resume+initState caen juntos
    }
    _lastSyncAttempt = now;
    syncNow(ref.read(databaseProvider));
  }

  Future<void> _buscar(BuildContext context) async {
    final id = await showSearch<String?>(
      context: context,
      delegate: EntitySearchDelegate(ref.read(entityRepositoryProvider)),
    );
    if (id != null && context.mounted) {
      final rama = appSections[widget.navigationShell.currentIndex].path;
      context.push('/$rama/entity/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;
    final colors = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: appSections.length,
      initialIndex: index,
      child: _TabBranchSync(
        navigationShell: widget.navigationShell,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appSections[index].titulo),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Buscar',
                onPressed: () => _buscar(context),
              ),
              const SyncButton(),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Configuración',
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          body: widget.navigationShell,
          floatingActionButton: FloatingActionButton(
            onPressed: () => mostrarCapturaSheet(context, ref),
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: Material(
            color: colors.surface,
            elevation: 3,
            child: SafeArea(
              top: false,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: colors.primary,
                unselectedLabelColor: colors.onSurfaceVariant,
                indicatorColor: colors.primary,
                // Tocar la sección en la que ya estás la "recarga": vuelve a
                // su pantalla principal (sale de cualquier detalle abierto
                // adentro) y dispara un sync. El cambio a OTRA sección lo
                // maneja `_TabBranchSync`.
                onTap: (i) {
                  if (i == widget.navigationShell.currentIndex) {
                    widget.navigationShell.goBranch(i, initialLocation: true);
                    _triggerSync();
                  }
                },
                tabs: [
                  for (final seccion in appSections)
                    Tab(icon: Icon(seccion.icon), text: seccion.titulo),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mantiene en sync el `TabController` que crea `DefaultTabController` (el
/// mismo que usan el `TabBar` de acá arriba y el `TabBarView` armado en
/// `swipeableBranchContainer`, que vive en otra parte del árbol de widgets)
/// con `navigationShell.currentIndex` — necesario para que un swipe o un
/// tap en la tira de pestañas también actualice la ubicación real de
/// `go_router` (si no, `pushEntityDetail`/`pushTaskDetail` podrían empujar
/// el detalle bajo la rama vieja en vez de la que se ve en pantalla).
class _TabBranchSync extends StatefulWidget {
  const _TabBranchSync({required this.navigationShell, required this.child});

  final StatefulNavigationShell navigationShell;
  final Widget child;

  @override
  State<_TabBranchSync> createState() => _TabBranchSyncState();
}

class _TabBranchSyncState extends State<_TabBranchSync> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (!identical(controller, _controller)) {
      _controller?.removeListener(_onTabChanged);
      _controller = controller..addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    final controller = _controller!;
    if (!controller.indexIsChanging &&
        controller.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(controller.index);
    }
  }

  @override
  void didUpdateWidget(covariant _TabBranchSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = _controller;
    if (controller != null &&
        controller.index != widget.navigationShell.currentIndex) {
      controller.animateTo(widget.navigationShell.currentIndex);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
