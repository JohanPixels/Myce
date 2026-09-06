import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/node_repository_provider.dart';

const _categorias = {
  'proyecto': 'Proyecto',
  'area': 'Área',
  'recurso': 'Recurso',
  'wishlist': 'Wishlist',
};

const _subtiposWishlist = {
  'juegos': 'Juegos',
  'musica': 'Música',
  'peliculas': 'Películas',
  'libros': 'Libros',
};

Future<void> mostrarClasificarSheet(
  BuildContext context,
  WidgetRef ref,
  String nodeId,
) {
  String? tipoSeleccionado;
  String? subtipoSeleccionado;

  return showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.all(16),
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
                  children: _categorias.entries.map((e) {
                    return ChoiceChip(
                      label: Text(e.value),
                      selected: tipoSeleccionado == e.key,
                      onSelected: (_) => setState(() {
                        tipoSeleccionado = e.key;
                        if (e.key != 'wishlist') subtipoSeleccionado = null;
                      }),
                    );
                  }).toList(),
                ),
                if (tipoSeleccionado == 'wishlist') ...[
                  const SizedBox(height: 16),
                  Text('¿Qué tipo?', style: Theme.of(ctx).textTheme.titleSmall),
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
                            (tipoSeleccionado == 'wishlist' &&
                                subtipoSeleccionado == null))
                        ? null
                        : () {
                            ref
                                .read(nodeRepositoryProvider)
                                .clasificar(
                                  nodeId,
                                  tipo: tipoSeleccionado!,
                                  subtipo: subtipoSeleccionado,
                                );
                            Navigator.of(ctx).pop();
                          },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
