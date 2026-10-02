import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/navigation_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/project_palette.dart';
import '../../core/widgets/copiar.dart';
import '../../entities/domain/entity_type.dart';
import '../../projects/data/project_repository.dart';
import '../../projects/presentation/project_avatar.dart';
import '../../relations/presentation/add_relation_sheet.dart';
import '../data/goal_repository.dart';
import '../data/goal_repository_provider.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/estado_vacio.dart';

/// Pestaña "Metas": cada Meta con los proyectos que la empujan y cuánto
/// avanzan entre todos. Reemplaza al `CategoryScreen` genérico.
class GoalListScreen extends ConsumerStatefulWidget {
  const GoalListScreen({super.key});

  @override
  ConsumerState<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends ConsumerState<GoalListScreen> {
  EntityStatus _filtro = EntityStatus.active;

  @override
  Widget build(BuildContext context) {
    final spacing = context.octoSpacing;
    return StreamBuilder<List<GoalSummary>>(
      stream: ref.watch(goalRepositoryProvider).watchGoals(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final todas = snapshot.data!;
        final visibles = todas
            .where((g) => g.goal.status == _filtro.name)
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
                          '${todas.where((g) => g.goal.status == estado.name).length}',
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
                  ? EstadoVacioGrande(
                      icono: AppIconsDuo.meta,
                      titulo: _filtro == EntityStatus.active
                          ? 'Sin metas activas'
                          : 'Nada en ${_filtro.label.toLowerCase()}',
                      texto: _filtro == EntityStatus.active
                          ? 'Captura una y clasifícala como Meta desde el '
                                'Inbox; después conéctale proyectos.'
                          : 'Aquí aparecen las metas con ese estado.',
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        spacing.md,
                        spacing.xs,
                        spacing.md,
                        96,
                      ),
                      itemCount: visibles.length,
                      separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                      itemBuilder: (context, i) =>
                          _GoalCard(summary: visibles[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.summary});

  final GoalSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final meta = summary.goal;
    final progreso = summary.total == 0 ? 0.0 : summary.done / summary.total;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => pushEntityDetail(context, meta.id),
            onLongPress: () => copiarTexto(context, meta.title),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.meta, color: scheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          meta.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progreso,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${summary.done}/${summary.total}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    switch (summary.projects.length) {
                      0 => 'Ningún proyecto la empuja todavía',
                      1 => '1 proyecto la empuja',
                      final n => '$n proyectos la empujan',
                    },
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final p in summary.projects) _ProyectoDeMeta(summary: p),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: TextButton.icon(
                icon: const Icon(AppIcons.conectar, size: 18),
                label: const Text('Conectar proyecto'),
                onPressed: () =>
                    mostrarAgregarRelacionSheet(context, ref, meta.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProyectoDeMeta extends StatelessWidget {
  const _ProyectoDeMeta({required this.summary});

  final ProjectSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entity = summary.entity;
    final activo = entity.status == EntityStatus.active.name;
    final color = projectColor(context, summary.project?.color);
    return InkWell(
      onTap: () => pushEntityDetail(context, entity.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ProjectAvatar(
              title: entity.title,
              emoji: summary.project?.emoji,
              colorKey: summary.project?.color,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    activo
                        ? summary.nextTask == null
                              ? 'Sin próxima acción'
                              : summary.nextTask!.title
                        : entity.status.toEntityStatus().label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: activo && summary.nextTask == null
                          ? context.octoColors.enCurso
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${summary.done}/${summary.total}',
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
