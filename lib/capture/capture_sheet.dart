import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../inbox/data/inbox_repository_provider.dart';

Future<void> mostrarCapturaSheet(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '¿Qué se te ocurrió?',
                ),
                onSubmitted: (_) => _guardar(ctx, ref, controller),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _guardar(ctx, ref, controller),
            ),
          ],
        ),
      );
    },
  );
}

void _guardar(
  BuildContext ctx,
  WidgetRef ref,
  TextEditingController controller,
) {
  final texto = controller.text.trim();
  if (texto.isEmpty) return;
  ref
      .read(inboxRepositoryProvider)
      .capture(texto); // no await: se cierra al instante
  Navigator.of(ctx).pop();
}
