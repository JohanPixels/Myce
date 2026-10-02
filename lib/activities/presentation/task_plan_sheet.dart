import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../data/task_repository_provider.dart';
import '../domain/task_enums.dart';

/// Elegir cuándo toca una tarea (Ahora/Siguiente/Después) y cuánto tiempo
/// pide. Cada toque se guarda al instante (UI optimista) — no hay botón de
/// guardar que olvidar. [tareasEnAhora] = cuántas OTRAS tareas del mismo
/// proyecto ya están en Ahora, para avisar si se pasa de `maxTareasAhora`.
Future<void> mostrarPlanTareaSheet(
  BuildContext context,
  WidgetRef ref,
  TaskRow tarea, {
  int tareasEnAhora = 0,
}) {
  var horizon = tarea.horizon.toTaskHorizon();
  var size = tarea.size.toTaskSize();
  final repo = ref.read(taskRepositoryProvider);

  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final theme = Theme.of(ctx);
        final pasaDelMax =
            horizon == TaskHorizon.now && tareasEnAhora >= maxTareasAhora;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tarea.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Text('¿Cuándo?', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<TaskHorizon>(
                  showSelectedIcon: false,
                  segments: [
                    for (final h in TaskHorizon.values)
                      ButtonSegment(value: h, label: Text(h.label)),
                  ],
                  selected: {horizon},
                  onSelectionChanged: (s) {
                    setState(() => horizon = s.first);
                    repo.changeHorizon(tarea.id, s.first);
                  },
                ),
              ),
              if (pasaDelMax) ...[
                const SizedBox(height: 8),
                Text(
                  'Ahora ya tiene $tareasEnAhora tareas. Con más de '
                  '$maxTareasAhora cuesta decidir por cuál empezar.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text('¿Cuánto tiempo pide?', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<TaskSize>(
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  segments: [
                    for (final s in TaskSize.values)
                      ButtonSegment(value: s, label: Text(s.label)),
                  ],
                  selected: {?size},
                  onSelectionChanged: (s) {
                    final nuevo = s.firstOrNull;
                    setState(() => size = nuevo);
                    repo.changeSize(tarea.id, nuevo);
                  },
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Toca de nuevo el seleccionado para dejarlo sin estimar.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
