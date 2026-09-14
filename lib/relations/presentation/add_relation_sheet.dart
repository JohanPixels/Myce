import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../entities/domain/entity_type.dart';
import '../data/relation_repository_provider.dart';

Future<void> mostrarAgregarRelacionSheet(
  BuildContext context,
  WidgetRef ref,
  String entityId,
) {
  final searchController = TextEditingController();
  final noteController = TextEditingController();
  EntityRow? seleccionada;
  RelationTypeRow? tipoSeleccionado;

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
                    'Conectar con...',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por título',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  if (searchController.text.trim().isNotEmpty)
                    FutureBuilder<List<EntityRow>>(
                      future: ref
                          .read(entityRepositoryProvider)
                          .search(
                            searchController.text.trim(),
                            excludeId: entityId,
                          ),
                      builder: (context, snapshot) {
                        final results = snapshot.data ?? const [];
                        if (results.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Sin resultados'),
                          );
                        }
                        return SizedBox(
                          height: 160,
                          child: ListView(
                            children: results.map((e) {
                              return ListTile(
                                title: Text(e.title),
                                subtitle: Text(e.type.toEntityType().label),
                                selected: seleccionada?.id == e.id,
                                onTap: () =>
                                    setState(() => seleccionada = e),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  if (seleccionada != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Conectado con: ${seleccionada!.title}',
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¿Qué tipo de relación?',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<RelationTypeRow>>(
                      future: ref
                          .read(relationRepositoryProvider)
                          .listRelationTypes(),
                      builder: (context, snapshot) {
                        final tipos = snapshot.data ?? const [];
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tipos.map((t) {
                            return ChoiceChip(
                              label: Text(t.label),
                              selected: tipoSeleccionado?.id == t.id,
                              onSelected: (_) =>
                                  setState(() => tipoSeleccionado = t),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        hintText: 'Nota opcional',
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          (seleccionada == null || tipoSeleccionado == null)
                          ? null
                          : () async {
                              await ref
                                  .read(relationRepositoryProvider)
                                  .create(
                                    sourceEntityId: entityId,
                                    targetEntityId: seleccionada!.id,
                                    relationTypeKey: tipoSeleccionado!.key,
                                    note: noteController.text.trim().isEmpty
                                        ? null
                                        : noteController.text.trim(),
                                  );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                            },
                      child: const Text('Conectar'),
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
