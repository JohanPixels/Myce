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
import '../../core/widgets/copiar.dart';

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
        // La primera tarea en Ahora de un proyecto activo (watchSummaries
        // viene ordenado por actividad reciente).
        final proximoRato = todos
            .where(
              (s) =>
                  s.entity.status == EntityStatus.active.name &&
                  s.nextTask?.horizon.toTaskHorizon() == TaskHorizon.now,
            )
            .firstOrNull;

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
                      itemCount: visibles.length + 1,
                      separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return proximoRato != null &&
                                  _filtro == EntityStatus.active
                              ? _ProximoRatoCard(summary: proximoRato)
                              : const SizedBox.shrink();
                        }
                        return _ProjectCard(summary: visibles[i - 1]);
                      },
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
        onLongPress: () => copiarTexto(context, entity.title),
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
                  if (summary.unclassified > 0)
                    Tooltip(
                      message: '${summary.unclassified} sin clasificar',
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 26),
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.octoColors.enCurso,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${summary.unclassified}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: context.octoColors.onEnCurso,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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

    final horizon = tarea.horizon.toTaskHorizon();
    final enAhora = horizon == TaskHorizon.now;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enAhora ? atencion : theme.colorScheme.outline,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          horizon.label,
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

/// "Para tu próximo rato": una sola tarea concreta para no tener que pensar
/// al abrir la app. Toca → abre la tarea.
class _ProximoRatoCard extends StatelessWidget {
  const _ProximoRatoCard({required this.summary});

  final ProjectSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    final tarea = summary.nextTask!;
    final size = tarea.size.toTaskSize();

    return Card(
      margin: EdgeInsets.zero,
      color: atencion.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: atencion.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushTaskDetail(context, tarea.id),
        onLongPress: () => copiarTexto(context, tarea.title),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PARA TU PRÓXIMO RATO',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: atencion,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tarea.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ProjectAvatar(
                    title: summary.entity.title,
                    emoji: summary.project?.emoji,
                    colorKey: summary.project?.color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      [
                        summary.entity.title,
                        if (size != null) size.label,
                      ].join(' · '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
