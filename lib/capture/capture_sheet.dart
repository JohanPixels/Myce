import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/data/entity_repository_provider.dart';
import '../entities/domain/entity_type.dart';
import '../inbox/data/inbox_repository_provider.dart';
import '../core/theme/app_icons.dart';

Future<void> mostrarCapturaSheet(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  EntityType? tipoSeleccionado;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: '¿Qué se te ocurrió?',
                        ),
                        onSubmitted: (_) =>
                            _guardar(ctx, ref, controller, tipoSeleccionado),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(AppIcons.enviar),
                      onPressed: () =>
                          _guardar(ctx, ref, controller, tipoSeleccionado),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: EntityType.values.map((tipo) {
                    return ChoiceChip(
                      label: Text(tipo.label),
                      selected: tipoSeleccionado == tipo,
                      onSelected: (selected) => setState(() {
                        tipoSeleccionado = selected ? tipo : null;
                      }),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _guardar(
  BuildContext ctx,
  WidgetRef ref,
  TextEditingController controller,
  EntityType? tipo,
) {
  final texto = controller.text.trim();
  if (texto.isEmpty) return;
  if (tipo != null) {
    // Tipo elegido de una: se salta el Inbox y se crea directo — no await,
    // UI optimista, igual que la captura sin tipo.
    ref.read(entityRepositoryProvider).create(type: tipo, title: texto);
  } else {
    ref.read(inboxRepositoryProvider).capture(texto);
  }
  Navigator.of(ctx).pop();
}
