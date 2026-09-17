import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inbox/inbox_screen.dart';
import '../../entities/presentation/category_screen.dart';
import '../../entities/domain/entity_type.dart';
import '../../activities/presentation/task_list_screen.dart';
import '../../capture/capture_sheet.dart';
import '../../review/review_screen.dart';
import '../../features/sync/sync_button.dart';
import '../../features/sync/sync_repository.dart';
import '../database/database_provider.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

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

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  int _index = 0;
  Timer? _periodicSync;
  DateTime? _lastSyncAttempt;
  static const _screens = [
    InboxScreen(),
    TaskListScreen(),
    CategoryScreen(type: EntityType.project, titulo: 'Proyectos'),
    CategoryScreen(type: EntityType.area, titulo: 'Áreas'),
    CategoryScreen(
      type: EntityType.resource,
      titulo: 'Recursos',
      showWishlistFilter: true,
    ),
    CategoryScreen(type: EntityType.note, titulo: 'Notas'),
    ReviewScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OctoDash'),
        actions: const [SyncButton()],
      ),
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarCapturaSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch),
            label: 'Proyectos',
          ),
          NavigationDestination(icon: Icon(Icons.landscape), label: 'Áreas'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Recursos'),
          NavigationDestination(icon: Icon(Icons.notes), label: 'Notas'),
          NavigationDestination(
            icon: Icon(Icons.fact_check),
            label: 'Revisión',
          ),
        ],
      ),
    );
  }
}
