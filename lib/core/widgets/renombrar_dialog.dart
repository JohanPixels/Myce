import 'package:flutter/material.dart';

/// Diálogo de "renombrar/editar texto" compartido por tareas, proyectos y
/// capturas. Devuelve el texto nuevo (ya recortado), o null si se canceló,
/// quedó vacío o no cambió — quien llama solo guarda si hay valor.
Future<String?> pedirNuevoTexto(
  BuildContext context, {
  required String titulo,
  required String actual,
  int? maxLength,
  bool multilinea = false,
}) async {
  final controller = TextEditingController(text: actual);
  final resultado = await showDialog<String>(
    context: context,
    builder: (ctx) {
      void guardar() => Navigator.of(ctx).pop(controller.text.trim());
      return AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: maxLength,
          minLines: 1,
          maxLines: multilinea ? 6 : 1,
          textInputAction: multilinea
              ? TextInputAction.newline
              : TextInputAction.done,
          onSubmitted: multilinea ? null : (_) => guardar(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(onPressed: guardar, child: const Text('Guardar')),
        ],
      );
    },
  );
  controller.dispose();
  if (resultado == null || resultado.isEmpty || resultado == actual.trim()) {
    return null;
  }
  return resultado;
}
