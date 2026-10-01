import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// `navigatorContainerBuilder` para el `StatefulShellRoute` base (no el
/// `.indexedStack` de antes, que no permite personalizar cómo se muestran
/// las ramas). Envuelve las ramas en un `TabBarView` en vez de un
/// `IndexedStack` — sin controller explícito: lo toma de un
/// `DefaultTabController` ancestro (ver `AppShell` en home_shell.dart), que
/// es el mismo que maneja el `TabBar` de abajo. Es el mecanismo estándar de
/// Flutter para compartir un `TabController` entre un `TabBar` y un
/// `TabBarView` que no son directamente padre-hijo en el árbol de widgets.
Widget swipeableBranchContainer(
  BuildContext context,
  StatefulNavigationShell navigationShell,
  List<Widget> children,
) {
  return TabBarView(
    children: [for (final child in children) _KeepAliveBranch(child: child)],
  );
}

/// Sin esto, `TabBarView` puede llegar a descartar y reconstruir la rama de
/// la que te alejaste varios swipes (no queda "cerca" en su viewport) —
/// perdería en qué pantalla estabas parado adentro de esa rama. Con
/// `IndexedStack` (el shell anterior) esto no pasaba porque mantenía las 10
/// ramas montadas siempre; esto reproduce esa garantía acá.
class _KeepAliveBranch extends StatefulWidget {
  const _KeepAliveBranch({required this.child});

  final Widget child;

  @override
  State<_KeepAliveBranch> createState() => _KeepAliveBranchState();
}

class _KeepAliveBranchState extends State<_KeepAliveBranch>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
