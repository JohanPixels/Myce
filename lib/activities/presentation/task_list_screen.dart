import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../data/task_repository.dart';
import '../data/task_repository_provider.dart';
import '../domain/task_enums.dart';
import '../../core/widgets/copiar.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  bool _soloHoy = false;

  int _compararActivas(TaskRow a, TaskRow b) {
    final aTieneFecha = a.dueAt != null;
    final bTieneFecha = b.dueAt != null;
    if (aTieneFecha != bTieneFecha) return aTieneFecha ? -1 : 1;
    if (aTieneFecha && bTieneFecha) {
      final porFecha = a.dueAt!.compareTo(b.dueAt!);
      if (porFecha != 0) return porFecha;
    }
    final porPrioridad = b.priority.toTaskPriority().index.compareTo(
      a.priority.toTaskPriority().index,
    );
    if (porPrioridad != 0) return porPrioridad;
    return a.createdAt.compareTo(b.createdAt);
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _buildTile(TaskRow task, TaskRepository repo) {
    final priority = task.priority.toTaskPriority();
    return ListTile(
      title: Text(task.title),
      subtitle: Row(
        children: [
          if (priority != TaskPriority.none) ...[
            const Icon(Icons.flag, size: 16),
            const SizedBox(width: 4),
            Text(priority.label),
          ],
          if (task.dueAt != null) ...[
            if (priority != TaskPriority.none) const SizedBox(width: 12),
            Text(_formatDate(task.dueAt!)),
          ],
        ],
      ),
      trailing: PopupMenuButton<TaskStatus>(
        onSelected: (status) => repo.changeStatus(task.id, status),
        itemBuilder: (ctx) => TaskStatus.values
            .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
            .toList(),
      ),
      onTap: () => pushTaskDetail(context, task.id),
      onLongPress: () =>
          copiarTexto(context, tituloYCuerpo(task.title, task.description)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(taskRepositoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Todas')),
              ButtonSegment(value: true, label: Text('Hoy y vencidas')),
            ],
            selected: {_soloHoy},
            onSelectionChanged: (s) => setState(() => _soloHoy = s.first),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TaskRow>>(
            stream: _soloHoy ? repo.watchDueTodayOrOverdue() : repo.watchAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tasks = snapshot.data!;
              if (tasks.isEmpty) {
                return Center(
                  child: Text(
                    _soloHoy ? 'Nada para hoy 🎉' : 'No hay tareas todavía',
                  ),
                );
              }
              if (_soloHoy) {
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, i) => _buildTile(tasks[i], repo),
                );
              }
              final activas =
                  tasks
                      .where(
                        (t) =>
                            t.status == 'pending' || t.status == 'inProgress',
                      )
                      .toList()
                    ..sort(_compararActivas);
              final terminadas = tasks
                  .where(
                    (t) => t.status == 'completed' || t.status == 'cancelled',
                  )
                  .toList();
              return ListView(
                children: [
                  if (activas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Nada pendiente 🎉'),
                    )
                  else
                    ...activas.map((t) => _buildTile(t, repo)),
                  if (terminadas.isNotEmpty)
                    ExpansionTile(
                      title: Text(
                        'Completadas y canceladas (${terminadas.length})',
                      ),
                      children: terminadas
                          .map((t) => _buildTile(t, repo))
                          .toList(),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
