import 'package:flutter/material.dart';

import '../../core/theme/project_palette.dart';

/// Cuadrito con el emoji del proyecto sobre su color. Sin emoji, muestra la
/// inicial del título — así un proyecto recién clasificado desde el Inbox
/// ya se ve con identidad propia antes de que le elijas nada.
class ProjectAvatar extends StatelessWidget {
  const ProjectAvatar({
    super.key,
    required this.title,
    this.emoji,
    this.colorKey,
    this.size = 48,
  });

  final String title;
  final String? emoji;
  final String? colorKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = projectColor(context, colorKey);
    final tieneEmoji = emoji != null && emoji!.isNotEmpty;
    final inicial = title.trim().isEmpty
        ? '?'
        : title.trim().characters.first.toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        tieneEmoji ? emoji! : inicial,
        style: TextStyle(
          fontSize: size * (tieneEmoji ? 0.5 : 0.42),
          fontWeight: FontWeight.w700,
          color: color,
          height: 1,
        ),
      ),
    );
  }
}
