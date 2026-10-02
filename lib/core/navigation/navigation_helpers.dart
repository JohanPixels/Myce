import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Push relativo a la rama del carrusel donde estás parado. Las 10 ramas
/// registran las mismas rutas hijas `entity/:id` y `task/:id` (ver
/// app_router.dart) — así un detalle puede empujar otro (relations, tasks
/// vinculadas, el "Ver" tras clasificar) sin perder el nav ni el FAB, que
/// viven en el shell y no en cada pantalla.
String _currentBranchPath(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  final firstSegment = location
      .split('/')
      .firstWhere((s) => s.isNotEmpty, orElse: () => 'inbox');
  return '/$firstSegment';
}

/// [generic] abre la pantalla genérica aunque la Entity sea un Project
/// (ver `EntityDetailDispatcher`).
void pushEntityDetail(
  BuildContext context,
  String entityId, {
  bool generic = false,
}) {
  final query = generic ? '?generic=1' : '';
  context.push('${_currentBranchPath(context)}/entity/$entityId$query');
}

void pushTaskDetail(BuildContext context, String taskId) {
  context.push('${_currentBranchPath(context)}/task/$taskId');
}
