import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../activities/domain/task_enums.dart';
import '../../activities/presentation/add_task_sheet.dart';
import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../relations/data/relation_repository.dart';
import '../../relations/data/relation_repository_provider.dart';
import '../../relations/presentation/add_relation_sheet.dart';
import '../../tags/data/tag_repository.dart';
import '../../tags/data/tag_repository_provider.dart';
import '../data/entity_repository.dart';
import '../data/entity_repository_provider.dart';
import '../domain/entity_type.dart';
import '../../core/widgets/copiar.dart';
import '../../core/widgets/markdown_field.dart';
import '../../links/presentation/wiki_links.dart';

const _estados = ['active', 'paused', 'someday', 'archived'];

class EntityDetailScreen extends ConsumerStatefulWidget {
  const EntityDetailScreen({super.key, required this.entityId});

  final String entityId;

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  final _titleController = TextEditingController();
  bool _titleDirty = false;
  late Future<List<RelationDisplayItem>> _relationsFuture;

  @override
  void initState() {
    super.initState();
    _relationsFuture = ref
        .read(relationRepositoryProvider)
        .listForEntityDisplay(widget.entityId);
  }

  void _refreshRelations() {
    setState(() {
      _relationsFuture = ref
          .read(relationRepositoryProvider)
          .listForEntityDisplay(widget.entityId);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTitle(EntityRepository entityRepo, String id) async {
    final value = _titleController.text.trim();
    if (value.isEmpty) {
      // se resincroniza con el título actual (no vacío) en el próximo build
      setState(() => _titleDirty = false);
      return;
    }
    await entityRepo.updateTitle(id, value);
    setState(() => _titleDirty = false);
  }

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar esto?'),
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
      await ref.read(entityRepositoryProvider).delete(widget.entityId);
      if (context.mounted) context.pop();
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(
    BuildContext context,
    DateTime? current,
    void Function(DateTime?) onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final entityRepo = ref.watch(entityRepositoryProvider);
    final tagRepo = ref.watch(tagRepositoryProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: StreamBuilder<EntityRow?>(
        stream: entityRepo.watchById(widget.entityId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entity = snapshot.data;
          if (entity == null) {
            return const Center(child: Text('Esto ya no existe'));
          }
          final type = entity.type.toEntityType();
          if (!_titleDirty && _titleController.text != entity.title) {
            _titleController.text = entity.title;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() => _titleDirty = true),
                      onSubmitted: (_) => _saveTitle(entityRepo, entity.id),
                    ),
                  ),
                  if (_titleDirty)
                    IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Guardar nombre',
                      onPressed: () => _saveTitle(entityRepo, entity.id),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                entity.type.toEntityType().label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _estados.map((s) {
                  return ChoiceChip(
                    label: Text(s),
                    selected: entity.status == s,
                    onSelected: (_) =>
                        entityRepo.changeStatus(entity.id, s.toEntityStatus()),
                  );
                }).toList(),
              ),

              if (type == EntityType.project) ...[
                const SizedBox(height: 24),
                Text(
                  'Fechas del proyecto',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                StreamBuilder<ProjectRow?>(
                  stream: entityRepo.watchProject(entity.id),
                  builder: (context, projectSnapshot) {
                    final project = projectSnapshot.data;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Inicio'),
                          subtitle: Text(
                            project?.startedAt == null
                                ? 'Sin definir'
                                : _formatDate(project!.startedAt!),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_calendar_outlined),
                                tooltip: 'Elegir fecha de inicio',
                                onPressed: () => _pickDate(
                                  context,
                                  project?.startedAt,
                                  (d) => entityRepo.updateProjectStartedAt(
                                    entity.id,
                                    d,
                                  ),
                                ),
                              ),
                              if (project?.startedAt != null)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Quitar fecha de inicio',
                                  onPressed: () => entityRepo
                                      .updateProjectStartedAt(entity.id, null),
                                ),
                            ],
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Completado'),
                          subtitle: Text(
                            project?.completedAt == null
                                ? 'Sin definir'
                                : _formatDate(project!.completedAt!),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_calendar_outlined),
                                tooltip: 'Elegir fecha de completado',
                                onPressed: () => _pickDate(
                                  context,
                                  project?.completedAt,
                                  (d) => entityRepo.updateProjectCompletedAt(
                                    entity.id,
                                    d,
                                  ),
                                ),
                              ),
                              if (project?.completedAt != null)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Quitar fecha de completado',
                                  onPressed: () =>
                                      entityRepo.updateProjectCompletedAt(
                                        entity.id,
                                        null,
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],

              const SizedBox(height: 24),
              // Note tiene contenido propio (Markdown) en notes.content —
              // docs/fuente_de_verdad.md §4.3. El resto de los tipos no
              // tienen campo de texto propio y usan entities.description.
              if (type == EntityType.note)
                StreamBuilder<NoteRow?>(
                  stream: entityRepo.watchNote(entity.id),
                  builder: (context, noteSnapshot) => MarkdownField(
                    label: 'Contenido',
                    value: noteSnapshot.data?.content,
                    tituloLectura: entity.title,
                    hint: 'Escribe tu nota… (soporta Markdown)',
                    onSave: (v) => entityRepo.updateNoteContent(entity.id, v),
                    enlaces: enlacesWiki(context, ref),
                  ),
                )
              else
                MarkdownField(
                  label: 'Notas',
                  value: entity.description,
                  tituloLectura: entity.title,
                  onSave: (v) => entityRepo.updateDescription(entity.id, v),
                  enlaces: enlacesWiki(context, ref),
                ),

              const SizedBox(height: 24),
              Text('Tags', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              StreamBuilder<List<TagRow>>(
                stream: tagRepo.watchTagsForEntity(entity.id),
                builder: (context, tagSnapshot) {
                  final tagRows = tagSnapshot.data ?? const [];
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...tagRows.map((t) {
                        return Chip(
                          label: Text(t.name),
                          onDeleted: () =>
                              tagRepo.untagEntity(entity.id, t.name),
                        );
                      }),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: const Text('Agregar tag'),
                        onPressed: () =>
                            _mostrarAgregarTag(context, tagRepo, entity.id),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tareas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_task),
                    tooltip: 'Agregar tarea',
                    onPressed: () =>
                        mostrarAgregarTareaSheet(context, ref, entity.id),
                  ),
                ],
              ),
              StreamBuilder<List<TaskRow>>(
                stream: taskRepo.watchLinkedToEntity(entity.id),
                builder: (context, taskSnapshot) {
                  final linkedTasks = taskSnapshot.data ?? const [];
                  if (linkedTasks.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Sin tareas vinculadas todavía'),
                    );
                  }
                  return Column(
                    children: linkedTasks.map((t) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.title),
                        subtitle: Text(t.status.toTaskStatus().label),
                        onTap: () => pushTaskDetail(context, t.id),
                        onLongPress: () => copiarTexto(
                          context,
                          tituloYCuerpo(t.title, t.description),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Relacionado con',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_link),
                    tooltip: 'Conectar con otra entity',
                    onPressed: () async {
                      await mostrarAgregarRelacionSheet(
                        context,
                        ref,
                        entity.id,
                      );
                      _refreshRelations();
                    },
                  ),
                ],
              ),
              FutureBuilder<List<RelationDisplayItem>>(
                future: _relationsFuture,
                builder: (context, relSnapshot) {
                  if (!relSnapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final relations = relSnapshot.data!;
                  if (relations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Sin conexiones todavía'),
                    );
                  }
                  return Column(
                    children: relations.map((r) {
                      return Card(
                        child: ListTile(
                          title: Text(r.otherEntityTitle),
                          subtitle: Text(
                            r.note == null ? r.label : '${r.label} · ${r.note}',
                          ),
                          onTap: () =>
                              pushEntityDetail(context, r.otherEntityId),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              MencionesSection(entity: entity),

              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () => _confirmarEliminar(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarAgregarTag(
    BuildContext context,
    TagRepository tagRepo,
    String entityId,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Agregar tag'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'ej. libro'),
            onSubmitted: (_) => Navigator.of(ctx).pop('save'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop('save'),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    ).then((accion) {
      final value = controller.text.trim();
      if (accion == 'save' && value.isNotEmpty) {
        tagRepo.tagEntity(entityId, value);
      }
    });
  }
}
