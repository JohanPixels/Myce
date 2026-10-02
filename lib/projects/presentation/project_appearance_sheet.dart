import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/project_palette.dart';
import '../data/project_repository_provider.dart';
import 'project_avatar.dart';
import '../../core/theme/app_icons.dart';

const _emojisSugeridos = [
  '🚀', '💻', '📱', '🍄', '🎬', '🎨', '✍️', '📚', '🎵', //
  '📸', '🎮', '🌱', '🏡', '🧪', '💡', '🛠️', '💰', '🎯',
];

Future<void> mostrarAparienciaProyectoSheet(
  BuildContext context,
  WidgetRef ref, {
  required String projectId,
  required String title,
  String? emoji,
  String? colorKey,
}) {
  String? emojiElegido = emoji;
  String? colorElegido = colorKey;
  final otroController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final theme = Theme.of(ctx);
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProjectAvatar(
                        title: title,
                        emoji: emojiElegido,
                        colorKey: colorElegido,
                        size: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Emoji', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final e in _emojisSugeridos)
                        _OpcionEmoji(
                          emoji: e,
                          seleccionado: emojiElegido == e,
                          onTap: () => setState(() => emojiElegido = e),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: otroController,
                    decoration: const InputDecoration(
                      labelText: 'Otro emoji',
                      hintText: 'Escríbelo con el teclado de emojis',
                    ),
                    onChanged: (v) {
                      final limpio = v.trim();
                      setState(
                        () => emojiElegido = limpio.isEmpty
                            ? emoji
                            : limpio.characters.first,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Color', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final key in projectPaletteKeys)
                        _OpcionColor(
                          color: projectColor(ctx, key),
                          seleccionado:
                              (colorElegido ?? projectPaletteKeys.first) == key,
                          onTap: () => setState(() => colorElegido = key),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (emojiElegido != null)
                        TextButton(
                          onPressed: () => setState(() {
                            emojiElegido = null;
                            otroController.clear();
                          }),
                          child: const Text('Quitar emoji'),
                        ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          // UI optimista: cerrar primero, guardar en segundo plano.
                          Navigator.of(ctx).pop();
                          ref
                              .read(projectRepositoryProvider)
                              .updateAppearance(
                                projectId,
                                emoji: emojiElegido,
                                color: colorElegido,
                              );
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
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

class _OpcionEmoji extends StatelessWidget {
  const _OpcionEmoji({
    required this.emoji,
    required this.seleccionado,
    required this.onTap,
  });

  final String emoji;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: seleccionado
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}

class _OpcionColor extends StatelessWidget {
  const _OpcionColor({
    required this.color,
    required this.seleccionado,
    required this.onTap,
  });

  final Color color;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: seleccionado,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: seleccionado
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: seleccionado
              ? Icon(
                  AppIcons.check,
                  color:
                      ThemeData.estimateBrightnessForColor(color) ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black,
                )
              : null,
        ),
      ),
    );
  }
}
