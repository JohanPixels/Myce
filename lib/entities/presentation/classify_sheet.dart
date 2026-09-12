import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inbox/data/inbox_repository_provider.dart';
import '../domain/entity_type.dart';

const _subtiposWishlist = {
  'juego': 'Juegos',
  'musica': 'Música',
  'pelicula': 'Películas',
  'libro': 'Libros',
};

Future<void> mostrarClasificarSheet(
  BuildContext context,
  WidgetRef ref,
  String inboxItemId,
) {
  EntityType? tipoSeleccionado;
  bool esWishlist = false;
  String? subtipoSeleccionado;

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
                    'Clasificar como',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: EntityType.values.map((tipo) {
                      return ChoiceChip(
                        label: Text(tipo.label),
                        selected: tipoSeleccionado == tipo,
                        onSelected: (_) => setState(() {
                          tipoSeleccionado = tipo;
                          if (tipo != EntityType.resource) {
                            esWishlist = false;
                            subtipoSeleccionado = null;
                          }
                        }),
                      );
                    }).toList(),
                  ),
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
                            subtipoSeleccionado = null;
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
                      '¿Qué tipo?',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _subtiposWishlist.entries.map((e) {
                        return ChoiceChip(
                          label: Text(e.value),
                          selected: subtipoSeleccionado == e.key,
                          onSelected: (_) =>
                              setState(() => subtipoSeleccionado = e.key),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          (tipoSeleccionado == null ||
                              (esWishlist && subtipoSeleccionado == null))
                          ? null
                          : () {
                              ref
                                  .read(inboxRepositoryProvider)
                                  .classify(
                                    inboxItemId,
                                    type: tipoSeleccionado!,
                                    status: esWishlist
                                        ? EntityStatus.someday
                                        : EntityStatus.active,
                                    tags: subtipoSeleccionado != null
                                        ? [subtipoSeleccionado!]
                                        : const [],
                                  );
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
