import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../relations/data/relation_repository.dart';
import '../../relations/data/relation_repository_provider.dart';
import '../../relations/presentation/add_relation_sheet.dart';
import '../../tags/data/tag_repository.dart';
import '../../tags/data/tag_repository_provider.dart';
import '../data/entity_repository_provider.dart';
import '../domain/entity_type.dart';

const _estados = ['active', 'paused', 'someday', 'archived'];

class EntityDetailScreen extends ConsumerStatefulWidget {
  const EntityDetailScreen({super.key, required this.entityId});

  final String entityId;

  @override
  ConsumerState<EntityDetailScreen> createState() =>
      _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  final _descriptionController = TextEditingController();
  bool _descriptionDirty = false;
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
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entityRepo = ref.watch(entityRepositoryProvider);
    final tagRepo = ref.watch(tagRepositoryProvider);

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
          if (!_descriptionDirty &&
              _descriptionController.text != (entity.description ?? '')) {
            _descriptionController.text = entity.description ?? '';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                entity.title,
                style: Theme.of(context).textTheme.headlineSmall,
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
                    onSelected: (_) => entityRepo.changeStatus(
                      entity.id,
                      s.toEntityStatus(),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              Text('Notas', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                minLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escribí lo que quieras guardar sobre esto...',
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
                      await entityRepo.updateDescription(
                        entity.id,
                        _descriptionController.text.trim().isEmpty
                            ? null
                            : _descriptionController.text.trim(),
                      );
                      setState(() => _descriptionDirty = false);
                    },
                    child: const Text('Guardar notas'),
                  ),
                ),
              ],

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
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  EntityDetailScreen(entityId: r.otherEntityId),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
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
