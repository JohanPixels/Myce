import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../activities/presentation/task_detail_screen.dart';
import '../../activities/presentation/task_list_screen.dart';
import '../../entities/domain/entity_type.dart';
import '../../entities/presentation/category_screen.dart';
import '../../entities/presentation/entity_detail_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../inbox/inbox_screen.dart';
import '../../review/review_screen.dart';
import 'app_sections.dart';
import 'home_shell.dart';
import 'swipeable_branch_view.dart';

/// Notifica a `GoRouter` cuando cambia el estado de auth de Supabase, para
/// que reevalúe `redirect` sin depender de que algo más dispare un rebuild
/// (reemplaza al `StreamBuilder<AuthState>` que hacía esto antes en
/// `AuthGate`).
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen(
      (_) => notifyListeners(),
    );
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Cada rama del carrusel puede terminar mostrando un detalle de Entity o
/// de Task (relations, tasks vinculadas, el "Ver" tras clasificar en el
/// Inbox) — por eso las mismas dos rutas hijas se repiten en las 10 ramas en
/// vez de intentar anidarlas bajo una sola. `pushEntityDetail`/
/// `pushTaskDetail` en `navigation_helpers.dart` arman el path relativo a
/// la rama donde estás parado.
List<RouteBase> _detailRoutes() => [
  GoRoute(
    path: 'entity/:id',
    builder: (context, state) =>
        EntityDetailScreen(entityId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: 'task/:id',
    builder: (context, state) =>
        TaskDetailScreen(taskId: state.pathParameters['id']!),
  ),
];

/// Una `StatefulShellBranch` por sección de `appSections` (mismo orden —
/// ver la nota en app_sections.dart). El path viene de ahí; el widget de
/// cada una sigue siendo explícito acá porque no todas se construyen igual
/// (Inbox/Tareas/Revisión no son `CategoryScreen`).
final _brancheWidgets = <String, WidgetBuilder>{
  'inbox': (context) => const InboxScreen(),
  'tasks': (context) => const TaskListScreen(),
  'projects': (context) =>
      const CategoryScreen(type: EntityType.project, titulo: 'Proyectos'),
  'areas': (context) =>
      const CategoryScreen(type: EntityType.area, titulo: 'Áreas'),
  'resources': (context) => const CategoryScreen(
    type: EntityType.resource,
    titulo: 'Recursos',
    showWishlistFilter: true,
  ),
  'notes': (context) =>
      const CategoryScreen(type: EntityType.note, titulo: 'Notas'),
  'review': (context) => const ReviewScreen(),
  'people': (context) =>
      const CategoryScreen(type: EntityType.person, titulo: 'Personas'),
  'hobbies': (context) =>
      const CategoryScreen(type: EntityType.hobby, titulo: 'Hobbies'),
  'goals': (context) =>
      const CategoryScreen(type: EntityType.goal, titulo: 'Metas'),
};

final appRouter = GoRouter(
  initialLocation: '/inbox',
  refreshListenable: _AuthChangeNotifier(),
  redirect: (context, state) {
    final loggedIn = Supabase.instance.client.auth.currentSession != null;
    final vaAlLogin = state.matchedLocation == '/login';
    if (!loggedIn) return vaAlLogin ? null : '/login';
    if (loggedIn && vaAlLogin) return '/inbox';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    StatefulShellRoute(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      navigatorContainerBuilder: swipeableBranchContainer,
      branches: [
        for (final seccion in appSections)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${seccion.path}',
                builder: (context, state) =>
                    _brancheWidgets[seccion.path]!(context),
                routes: _detailRoutes(),
              ),
            ],
          ),
      ],
    ),
  ],
);
