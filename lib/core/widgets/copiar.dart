import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copia [texto] al portapapeles y avisa con un SnackBar corto. Se usa en
/// el long-press de los ítems de lista (tareas, notas, capturas…) para no
/// tener que reescribir lo mismo en otro lado.
Future<void> copiarTexto(BuildContext context, String texto) async {
  await Clipboard.setData(ClipboardData(text: texto));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Copiado'),
        duration: Duration(milliseconds: 1500),
      ),
    );
}

/// Título y, si tiene, la descripción debajo — lo que se espera al copiar
/// una tarea o una nota completa.
String tituloYCuerpo(String titulo, String? cuerpo) {
  final resto = cuerpo?.trim() ?? '';
  return resto.isEmpty ? titulo : '$titulo\n\n$resto';
}
