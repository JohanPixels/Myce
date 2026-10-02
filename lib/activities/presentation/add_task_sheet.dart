import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/task_repository_provider.dart';
import '../domain/task_enums.dart';

Future<void> mostrarAgregarTareaSheet(
  BuildContext context,
  WidgetRef ref,
  String entityId,
) {
  final titleController = TextEditingController();
  TaskPriority prioridadSeleccionada = TaskPriority.none;
  DateTime? fechaLimite;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nueva tarea',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Título'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Text('Prioridad', style: Theme.of(ctx).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TaskPriority.values.map((p) {
                      return ChoiceChip(
                        label: Text(p.label),
                        selected: prioridadSeleccionada == p,
                        onSelected: (_) =>
                            setState(() => prioridadSeleccionada = p),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        fechaLimite == null
                            ? 'Sin fecha límite'
                            : 'Vence: ${fechaLimite!.year}-${fechaLimite!.month.toString().padLeft(2, '0')}-${fechaLimite!.day.toString().padLeft(2, '0')}',
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar_outlined),
                        tooltip: 'Elegir fecha límite',
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: fechaLimite ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => fechaLimite = picked);
                          }
                        },
                      ),
                      if (fechaLimite != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Quitar fecha límite',
                          onPressed: () => setState(() => fechaLimite = null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: titleController.text.trim().isEmpty
                          ? null
                          : () {
                              ref
                                  .read(taskRepositoryProvider)
                                  .createLinkedTo(
                                    entityId,
                                    title: titleController.text.trim(),
                                    priority: prioridadSeleccionada,
                                    dueAt: fechaLimite,
                                  ); // sin await — UI optimista
                              Navigator.of(ctx).pop();
                            },
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
