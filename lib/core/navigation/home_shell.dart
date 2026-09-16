import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inbox/inbox_screen.dart';
import '../../entities/presentation/category_screen.dart';
import '../../entities/domain/entity_type.dart';
import '../../activities/presentation/task_list_screen.dart';
import '../../capture/capture_sheet.dart';
import '../../review/review_screen.dart';
import '../../features/sync/sync_test_button.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OctoDash'),
        actions: const [SyncTestButton()],
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
