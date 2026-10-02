import 'package:flutter/material.dart';

/// Colores elegibles para un Project. En la base se guarda la clave
/// (`projects.color`), no el valor — así el mismo proyecto se ve bien en
/// tema claro y oscuro, y la paleta se puede retocar sin migrar datos.
const projectPaletteKeys = [
  'cyan',
  'orange',
  'violet',
  'green',
  'pink',
  'yellow',
  'blue',
  'gray',
];

const _dark = {
  'cyan': Color(0xFF2BD9F5),
  'orange': Color(0xFFFF7A1A),
  'violet': Color(0xFFB9A4FF),
  'green': Color(0xFF5BE0A0),
  'pink': Color(0xFFFF8FC7),
  'yellow': Color(0xFFFFD25E),
  'blue': Color(0xFF6FA8FF),
  'gray': Color(0xFF93A3B5),
};

const _light = {
  'cyan': Color(0xFF0091A8),
  'orange': Color(0xFFD95E00),
  'violet': Color(0xFF6B4FD8),
  'green': Color(0xFF1E8F5A),
  'pink': Color(0xFFC2367E),
  'yellow': Color(0xFFA67C00),
  'blue': Color(0xFF2F6BD6),
  'gray': Color(0xFF5B6878),
};

/// Color del proyecto para el tema actual; sin clave (o clave desconocida,
/// ej. una que vino de otro dispositivo con una versión más nueva) cae en
/// cyan, el color de la marca.
Color projectColor(BuildContext context, String? key) {
  final palette = Theme.of(context).brightness == Brightness.dark
      ? _dark
      : _light;
  return palette[key] ?? palette['cyan']!;
}
