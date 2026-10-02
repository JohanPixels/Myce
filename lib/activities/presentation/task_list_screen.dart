import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../focus/data/focus_repository.dart';
import '../../focus/data/focus_repository_provider.dart';
import '../../focus/presentation/task_tile.dart';
import '../domain/task_enums.dart';
import 'task_plan_sheet.dart';

/// Pestaña "Tareas": el inventario completo (abiertas de cualquier proyecto,
/// sueltas, y las cerradas plegadas). "Ahora" responde "¿qué hago?"; esta
/// responde "¿qué tengo pendiente en total?".
class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

enum _Filtro { abiertas, conFecha }

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  _Filtro _filtro = _Filtro.abiertas;

  /// Con fecha primero (la más próxima arriba), luego por prioridad, luego
  /// la más vieja.
  int _comparar(FocusItem a, FocusItem b) {
    final fa = a.task.dueAt, fb = b.task.dueAt;
    if ((fa != null) != (fb != null)) return fa != null ? -1 : 1;
    if (fa != null && fb != null) {
      final porFecha = fa.compareTo(fb);
      if (porFecha != 0) return porFecha;
    }
    final porPrioridad = b.task.priority.toTaskPriority().index.compareTo(
      a.task.priority.toTaskPriority().index,
    );
    if (porPrioridad != 0) return porPrioridad;
    return a.task.createdAt.compareTo(b.task.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.octoSpacing;

    return StreamBuilder<List<FocusItem>>(
      stream: ref.watch(focusRepositoryProvider).watchAllTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final todas = snapshot.data!;
        bool abierta(FocusItem i) =>
            i.task.status == TaskStatus.pending.name ||
            i.task.status == TaskStatus.inProgress.name;
        final finDeHoy = DateTime.now().copyWith(
          hour: 23,
          minute: 59,
          second: 59,
        );
        final abiertas = todas.where(abierta).toList()..sort(_comparar);
        final conFecha = abiertas
            .where(
              (i) => i.task.dueAt != null && !i.task.dueAt!.isAfter(finDeHoy),
            )
            .toList();
        final cerradas = todas.where((i) => !abierta(i)).toList()
          ..sort((a, b) => b.task.updatedAt.compareTo(a.task.updatedAt));
        final visibles = _filtro == _Filtro.abiertas ? abiertas : conFecha;

        return ListView(
          padding: EdgeInsets.fromLTRB(spacing.md, spacing.sm, spacing.md, 96),
          children: [
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text('Abiertas ${abiertas.length}'),
                  selected: _filtro == _Filtro.abiertas,
                  onSelected: (_) => setState(() => _filtro = _Filtro.abiertas),
                ),
                ChoiceChip(
                  label: Text('Hoy y vencidas ${conFecha.length}'),
                  selected: _filtro == _Filtro.conFecha,
                  onSelected: (_) => setState(() => _filtro = _Filtro.conFecha),
                ),
              ],
            ),
            SizedBox(height: spacing.md - 4),
            if (visibles.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xl),
                child: Text(
                  _filtro == _Filtro.abiertas
                      ? 'Nada pendiente 🎉'
                      : 'Nada con fecha para hoy.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final i in visibles)
                TaskTile(
                  item: i,
                  onPlan: () => mostrarPlanTareaSheet(context, ref, i.task),
                ),
            if (cerradas.isNotEmpty)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Hechas y canceladas · ${cerradas.length}'),
                  children: [for (final i in cerradas) TaskTile(item: i)],
                ),
              ),
          ],
        );
      },
    );
  }
}
