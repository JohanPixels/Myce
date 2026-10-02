import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../entities/domain/entity_type.dart';
import '../data/task_repository_provider.dart';
import '../domain/task_enums.dart';
import 'link_entity_sheet.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _descriptionController = TextEditingController();
  bool _descriptionDirty = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar esta tarea?'),
        content: const Text('Esta acción no se puede deshacer desde la app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado == true && context.mounted) {
      await ref.read(taskRepositoryProvider).delete(widget.taskId);
      if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskRepo = ref.watch(taskRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: StreamBuilder<TaskRow?>(
        stream: taskRepo.watchById(widget.taskId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final task = snapshot.data;
          if (task == null) {
            return const Center(child: Text('Esto ya no existe'));
          }
          if (!_descriptionDirty &&
              _descriptionController.text != (task.description ?? '')) {
            _descriptionController.text = task.description ?? '';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(task.title, style: Theme.of(context).textTheme.headlineSmall),

              const SizedBox(height: 20),
              Text('Estado', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TaskStatus.values.map((s) {
                  return ChoiceChip(
                    label: Text(s.label),
                    selected: task.status.toTaskStatus() == s,
                    onSelected: (_) => taskRepo.changeStatus(task.id, s),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              Text('¿Cuándo?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TaskHorizon.values.map((h) {
                  return ChoiceChip(
                    label: Text(h.label),
                    selected: task.horizon.toTaskHorizon() == h,
                    onSelected: (_) => taskRepo.changeHorizon(task.id, h),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              Text(
                '¿Cuánto tiempo pide?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TaskSize.values.map((s) {
                  final elegido = task.size.toTaskSize() == s;
                  return ChoiceChip(
                    label: Text(s.label),
                    selected: elegido,
                    // tocar el ya elegido lo deja sin estimar
                    onSelected: (_) =>
                        taskRepo.changeSize(task.id, elegido ? null : s),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              Text('Prioridad', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TaskPriority.values.map((p) {
                  return ChoiceChip(
                    label: Text(p.label),
                    selected: task.priority.toTaskPriority() == p,
                    onSelected: (_) => taskRepo.changePriority(task.id, p),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              Text(
                'Fecha límite',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  task.dueAt == null ? 'Sin definir' : _formatDate(task.dueAt!),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_calendar_outlined),
                      tooltip: 'Elegir fecha límite',
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: task.dueAt ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          taskRepo.changeDueAt(task.id, picked);
                        }
                      },
                    ),
                    if (task.dueAt != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Quitar fecha límite',
                        onPressed: () => taskRepo.changeDueAt(task.id, null),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                minLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Detalles opcionales...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() => _descriptionDirty = true),
              ),
              if (_descriptionDirty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () async {
                      await taskRepo.updateDescription(
                        task.id,
                        _descriptionController.text.trim().isEmpty
                            ? null
                            : _descriptionController.text.trim(),
                      );
                      setState(() => _descriptionDirty = false);
                    },
                    child: const Text('Guardar descripción'),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              Text(
                'Vinculado a',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              StreamBuilder<EntityRow?>(
                stream: taskRepo.watchLinkedEntity(task.id),
                builder: (context, linkSnapshot) {
                  final entity = linkSnapshot.data;
                  if (entity == null) {
                    return ActionChip(
                      avatar: const Icon(Icons.add_link, size: 18),
                      label: const Text('Vincular a...'),
                      onPressed: () =>
                          mostrarVincularEntitySheet(context, ref, task.id),
                    );
                  }
                  return Card(
                    child: ListTile(
                      title: Text(entity.title),
                      subtitle: Text(entity.type.toEntityType().label),
                      trailing: IconButton(
                        icon: const Icon(Icons.link_off),
                        tooltip: 'Desvincular',
                        onPressed: () => taskRepo.unlinkFromEntity(task.id),
                      ),
                      onTap: () => pushEntityDetail(context, entity.id),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () => _confirmarEliminar(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Eliminar tarea',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
