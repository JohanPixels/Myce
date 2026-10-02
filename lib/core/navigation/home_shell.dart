import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../capture/capture_sheet.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../entities/presentation/entity_search_delegate.dart';
import '../../features/sync/sync_button.dart';
import '../../features/sync/sync_repository.dart';
import '../../settings/capture_button_preference.dart';
import '../database/database_provider.dart';
import 'app_sections.dart';
import 'carousel_nav_bar.dart';

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

  /// El "+" se esconde al bajar en una lista y vuelve al subir.
  bool _fabVisiblePorScroll = true;
  int? _ultimaSeccion;
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
    final hit = await showSearch<SearchHit?>(
      context: context,
      delegate: EntitySearchDelegate(
        ref.read(entityRepositoryProvider),
        ref.read(taskRepositoryProvider),
      ),
    );
    if (hit != null && context.mounted) {
      final rama = appSections[widget.navigationShell.currentIndex].path;
      context.push('/$rama/${hit.isTask ? 'task' : 'entity'}/${hit.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;
    final colors = Theme.of(context).colorScheme;
    final posicionFab = ref.watch(captureButtonProvider);
    // Dentro de un detalle (tarea, nota, proyecto) el "+" estorba y esas
    // pantallas ya tienen sus propias formas de agregar: solo se muestra en
    // la pantalla principal de cada sección.
    final enDetalle =
        widget
            .navigationShell
            .shellRouteContext
            .routerState
            .uri
            .pathSegments
            .length >
        1;
    if (index != _ultimaSeccion) {
      _ultimaSeccion = index;
      _fabVisiblePorScroll = true; // sección nueva: el botón vuelve a verse
    }
    final mostrarFab =
        posicionFab != CaptureButtonPosition.oculto &&
        !enDetalle &&
        _fabVisiblePorScroll;
    return DefaultTabController(
      length: appSections.length,
      initialIndex: index,
      child: _TabBranchSync(
        navigationShell: widget.navigationShell,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appSections[index].titulo),
            actions: [
              if (posicionFab == CaptureButtonPosition.oculto)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Capturar',
                  onPressed: () => mostrarCapturaSheet(context, ref),
                ),
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
          // Bajar en una lista esconde el "+", subir lo devuelve (solo
          // scroll vertical: deslizar entre secciones no cuenta).
          body: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              if (n.metrics.axis != Axis.vertical) return false;
              final ocultar = n.direction == ScrollDirection.reverse;
              final mostrar = n.direction == ScrollDirection.forward;
              if ((ocultar && _fabVisiblePorScroll) ||
                  (mostrar && !_fabVisiblePorScroll)) {
                setState(() => _fabVisiblePorScroll = mostrar);
              }
              return false;
            },
            child: widget.navigationShell,
          ),
          floatingActionButtonLocation: posicionFab.location,
          floatingActionButton: IgnorePointer(
            ignoring: !mostrarFab,
            child: AnimatedSlide(
              offset: mostrarFab ? Offset.zero : const Offset(0, 2),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: mostrarFab ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  tooltip: 'Capturar',
                  onPressed: () => mostrarCapturaSheet(context, ref),
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Material(
            color: colors.surface,
            elevation: 3,
            child: SafeArea(
              top: false,
              child: CarouselNavBar(
                // Tocar la sección en la que ya estás la "recarga": vuelve a
                // su pantalla principal (sale de cualquier detalle abierto
                // adentro) y dispara un sync. El cambio a OTRA sección pasa
                // por el TabController y lo traduce `_TabBranchSync`.
                onTapActual: () {
                  final i = widget.navigationShell.currentIndex;
                  widget.navigationShell.goBranch(i, initialLocation: true);
                  _triggerSync();
                },
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
