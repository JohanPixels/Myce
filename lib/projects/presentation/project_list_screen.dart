import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/domain/task_enums.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/project_palette.dart';
import '../../entities/domain/entity_type.dart';
import '../data/project_repository.dart';
import '../data/project_repository_provider.dart';
import 'project_avatar.dart';

/// Pestaña "Proyectos": tarjetas con progreso y próxima acción, filtradas
/// por estado. Reemplaza al `CategoryScreen` genérico solo para Project.
class ProjectListScreen extends ConsumerStatefulWidget {
  const ProjectListScreen({super.key});

  @override
  ConsumerState<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  EntityStatus _filtro = EntityStatus.active;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(projectRepositoryProvider);
    final spacing = context.octoSpacing;

    return StreamBuilder<List<ProjectSummary>>(
      stream: repo.watchSummaries(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final todos = snapshot.data!;
        final visibles = todos
            .where((s) => s.entity.status == _filtro.name)
            .toList();

        return Column(
          children: [
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                children: [
                  for (final estado in EntityStatus.values)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.sm),
                      child: ChoiceChip(
                        label: Text(
                          '${estado.label} '
                          '${todos.where((s) => s.entity.status == estado.name).length}',
                        ),
                        selected: _filtro == estado,
                        onSelected: (_) => setState(() => _filtro = estado),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: visibles.isEmpty
                  ? _Vacio(filtro: _filtro)
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        spacing.md,
                        spacing.xs,
                        spacing.md,
                        96, // aire para el FAB del shell
                      ),
                      itemCount: visibles.length,
                      separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                      itemBuilder: (context, i) =>
                          _ProjectCard(summary: visibles[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.filtro});

  final EntityStatus filtro;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.octoSpacing.xl),
        child: Text(
          filtro == EntityStatus.active
              ? 'No hay proyectos activos.\nCaptura una idea y clasifícala como '
                    'Proyecto desde el Inbox.'
              : 'Nada en ${filtro.label.toLowerCase()}.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.summary});

  final ProjectSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.octoSpacing;
    final entity = summary.entity;
    final color = projectColor(context, summary.project?.color);
    final progreso = summary.total == 0 ? 0.0 : summary.done / summary.total;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushEntityDetail(context, entity.id),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ProjectAvatar(
                    title: entity.title,
                    emoji: summary.project?.emoji,
                    colorKey: summary.project?.color,
                  ),
                  SizedBox(width: spacing.md - 4),
                  Expanded(
                    child: Text(
                      entity.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.md - 4),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 6,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.sm + 2),
                  Text(
                    '${summary.done}/${summary.total}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.md - 4),
              _ProximaAccion(summary: summary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProximaAccion extends StatelessWidget {
  const _ProximaAccion({required this.summary});

  final ProjectSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    final tarea = summary.nextTask;

    if (tarea == null) {
      final todoHecho = summary.total > 0 && summary.done == summary.total;
      if (todoHecho) {
        return Text(
          'Todo hecho por ahora',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: atencion.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: atencion),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Sin próxima acción — agrega una',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: atencion,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final enCurso = tarea.status == TaskStatus.inProgress.name;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enCurso ? atencion : theme.colorScheme.outline,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          enCurso ? 'En curso' : 'Siguiente',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tarea.title,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
