import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../entities/domain/entity_type.dart';
import '../data/task_repository_provider.dart';
import '../domain/task_enums.dart';
import 'link_entity_sheet.dart';
import '../../core/widgets/copiar.dart';
import '../../core/widgets/renombrar_dialog.dart';
import '../../core/widgets/markdown_field.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  @override
  void dispose() {
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
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        actions: [
          StreamBuilder<TaskRow?>(
            stream: taskRepo.watchById(widget.taskId),
            builder: (context, snapshot) {
              final task = snapshot.data;
              return IconButton(
                icon: const Icon(Icons.copy_outlined),
                tooltip: 'Copiar tarea',
                onPressed: task == null
                    ? null
                    : () => copiarTexto(
                        context,
                        tituloYCuerpo(task.title, task.description),
                      ),
              );
            },
          ),
        ],
      ),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SelectableText(
                      task.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Renombrar',
                    onPressed: () async {
                      final nuevo = await pedirNuevoTexto(
                        context,
                        titulo: 'Renombrar tarea',
                        actual: task.title,
                        maxLength: 200,
                        multilinea: true,
                      );
                      if (nuevo != null) taskRepo.updateTitle(task.id, nuevo);
                    },
                  ),
                ],
              ),

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
              MarkdownField(
                label: 'Descripción',
                value: task.description,
                tituloLectura: task.title,
                hint: 'Detalles opcionales… (soporta Markdown)',
                onSave: (v) => taskRepo.updateDescription(task.id, v),
              ),

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
