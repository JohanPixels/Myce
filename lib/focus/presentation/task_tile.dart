import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../activities/domain/task_enums.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/copiar.dart';
import '../../entities/domain/entity_type.dart';
import '../../projects/presentation/project_avatar.dart';
import '../data/focus_repository.dart';
import '../../core/theme/app_icons.dart';

/// Fila de tarea con su contexto (proyecto con emoji, "Área · X" o
/// "Suelta"), tamaño, fecha y prioridad si tiene — la usan "Ahora" y la
/// pestaña Tareas para que una tarea se vea igual en todos lados.
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.item, this.onPlan});

  final FocusItem item;

  /// Abre el sheet de cuándo/cuánto; null = sin botón ⋯ (ej. hechas).
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    final tarea = item.task;
    final status = tarea.status.toTaskStatus();
    final cerrada =
        status == TaskStatus.completed || status == TaskStatus.cancelled;
    final enAhora =
        !cerrada && tarea.horizon.toTaskHorizon() == TaskHorizon.now;
    final priority = tarea.priority.toTaskPriority();
    final hoy = DateTime.now();
    final vencida =
        !cerrada &&
        tarea.dueAt != null &&
        tarea.dueAt!.isBefore(DateTime(hoy.year, hoy.month, hoy.day));
    final enCurso = tarea.status == TaskStatus.inProgress.name;
    final size = tarea.size.toTaskSize();
    final entity = item.entity;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: enAhora
              ? atencion.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushTaskDetail(context, tarea.id),
        onLongPress: () =>
            copiarTexto(context, tituloYCuerpo(tarea.title, tarea.description)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
          child: Row(
            children: [
              Checkbox(
                value: status == TaskStatus.completed,
                onChanged: (_) => ref
                    .read(taskRepositoryProvider)
                    .changeStatus(
                      tarea.id,
                      cerrada ? TaskStatus.pending : TaskStatus.completed,
                    ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarea.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: cerrada ? TextDecoration.lineThrough : null,
                        color: cerrada
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (entity?.type == EntityType.project.name) ...[
                          ProjectAvatar(
                            title: entity!.title,
                            emoji: item.project?.emoji,
                            colorKey: item.project?.color,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            entity == null
                                ? 'Suelta'
                                : entity.type == EntityType.project.name
                                ? entity.title
                                : '${entity.type.toEntityType().label} · '
                                      '${entity.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (tarea.dueAt != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '· ${tarea.dueAt!.day}/${tarea.dueAt!.month}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: vencida
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: vencida ? FontWeight.w700 : null,
                            ),
                          ),
                        ],
                        if (priority == TaskPriority.high ||
                            priority == TaskPriority.medium) ...[
                          const SizedBox(width: 6),
                          Icon(
                            AppIcons.prioridad,
                            size: 14,
                            color: priority == TaskPriority.high
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                        if (enCurso) ...[
                          const SizedBox(width: 6),
                          Text(
                            '· En curso',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: atencion,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (size != null && !cerrada)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    size.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (onPlan != null && !cerrada)
                IconButton(
                  icon: const Icon(AppIcons.mas),
                  tooltip: 'Cuándo y cuánto tiempo',
                  onPressed: onPlan,
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
