import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/domain/task_enums.dart';
import '../../inbox/data/inbox_repository_provider.dart';
import '../domain/entity_type.dart';

/// Resultado de clasificar un InboxItem — lo que se creó (Entity o Task) y
/// su id, para que quien llamó al sheet pueda ofrecer un acceso directo
/// ("Ver") sin que el item se sienta perdido tras cambiar de pantalla.
class ClassifyResult {
  const ClassifyResult({
    required this.id,
    required this.isTask,
    required this.label,
  });

  final String id;
  final bool isTask;
  final String label;
}

Future<ClassifyResult?> mostrarClasificarSheet(
  BuildContext context,
  WidgetRef ref,
  String inboxItemId,
) {
  EntityType? tipoSeleccionado;
  bool esWishlist = false;
  final tagsWishlist = <String>[];
  final tagController = TextEditingController();
  bool esTarea = false;
  TaskPriority prioridadSeleccionada = TaskPriority.none;
  DateTime? fechaLimite;

  return showModalBottomSheet<ClassifyResult>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          void agregarTag() {
            final value = tagController.text.trim();
            if (value.isEmpty || tagsWishlist.contains(value)) return;
            setState(() {
              tagsWishlist.add(value);
              tagController.clear();
            });
          }

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
                    'Clasificar como',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...EntityType.values.map((tipo) {
                        return ChoiceChip(
                          label: Text(tipo.label),
                          selected: tipoSeleccionado == tipo,
                          onSelected: (_) => setState(() {
                            esTarea = false;
                            tipoSeleccionado = tipo;
                            if (tipo != EntityType.resource) {
                              esWishlist = false;
                              tagsWishlist.clear();
                            }
                          }),
                        );
                      }),
                      ChoiceChip(
                        label: const Text('Tarea'),
                        selected: esTarea,
                        onSelected: (_) => setState(() {
                          esTarea = true;
                          tipoSeleccionado = null;
                          esWishlist = false;
                          tagsWishlist.clear();
                        }),
                      ),
                    ],
                  ),
                  if (esTarea) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Prioridad',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
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
                            onPressed: () =>
                                setState(() => fechaLimite = null),
                          ),
                      ],
                    ),
                  ],
                  if (tipoSeleccionado == EntityType.resource) ...[
                    const SizedBox(height: 16),
                    Text(
                      '¿Ya lo estás usando o es para después?',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Activo ahora'),
                          selected: !esWishlist,
                          onSelected: (_) => setState(() {
                            esWishlist = false;
                          }),
                        ),
                        ChoiceChip(
                          label: const Text('Para después (wishlist)'),
                          selected: esWishlist,
                          onSelected: (_) => setState(() => esWishlist = true),
                        ),
                      ],
                    ),
                  ],
                  if (esWishlist) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Tags (opcional) — ej. web, curso, video, investigación',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...tagsWishlist.map((t) {
                          return Chip(
                            label: Text(t),
                            onDeleted: () =>
                                setState(() => tagsWishlist.remove(t)),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tagController,
                            decoration: const InputDecoration(
                              hintText: 'Agregar tag...',
                              isDense: true,
                            ),
                            onSubmitted: (_) => agregarTag(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Agregar tag',
                          onPressed: agregarTag,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: esTarea || tipoSeleccionado != null
                          ? () async {
                              if (esTarea) {
                                final taskId = await ref
                                    .read(inboxRepositoryProvider)
                                    .classifyAsTask(
                                      inboxItemId,
                                      priority: prioridadSeleccionada,
                                      dueAt: fechaLimite,
                                    );
                                if (ctx.mounted) {
                                  Navigator.of(ctx).pop(
                                    ClassifyResult(
                                      id: taskId,
                                      isTask: true,
                                      label: 'Tarea',
                                    ),
                                  );
                                }
                              } else {
                                final entityId = await ref
                                    .read(inboxRepositoryProvider)
                                    .classify(
                                      inboxItemId,
                                      type: tipoSeleccionado!,
                                      status: esWishlist
                                          ? EntityStatus.someday
                                          : EntityStatus.active,
                                      tags: tagsWishlist,
                                    );
                                if (ctx.mounted) {
                                  Navigator.of(ctx).pop(
                                    ClassifyResult(
                                      id: entityId,
                                      isTask: false,
                                      label: tipoSeleccionado!.label,
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
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
