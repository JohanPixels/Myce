import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

/// Hueco vacío dentro de una lista ("Nada en Ahora", "Sin documentos"):
/// caja con borde, ícono duotono y el texto que explica qué va ahí.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.texto, this.icono});

  final String texto;
  final IconoDuoData? icono;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          if (icono != null) ...[
            IconoDuo(icono!, size: 26, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              texto,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla entera vacía (Inbox vacío, sin proyectos…): ícono duotono
/// grande, título y una línea que dice cómo llenarla.
class EstadoVacioGrande extends StatelessWidget {
  const EstadoVacioGrande({
    super.key,
    required this.icono,
    required this.titulo,
    required this.texto,
  });

  final IconoDuoData icono;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: IconoDuo(
                icono,
                size: 52,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
