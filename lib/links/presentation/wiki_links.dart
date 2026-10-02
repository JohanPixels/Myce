import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../core/widgets/markdown_field.dart';
import '../../entities/domain/entity_type.dart';
import '../data/link_repository.dart';
import '../data/link_repository_provider.dart';

/// Conecta un [MarkdownField] con la base para los `[[enlaces]]`:
/// sugerencias por título al escribir, y al tocar un enlace abre esa
/// Entity — o, si todavía no existe, ofrece crear una Nota con ese nombre.
MarkdownEnlaces enlacesWiki(BuildContext context, WidgetRef ref) {
  final repo = ref.read(linkRepositoryProvider);
  return MarkdownEnlaces(
    sugerir: repo.suggestTitles,
    abrir: (titulo) async {
      final existente = await repo.findByTitle(titulo);
      if (!context.mounted) return;
      if (existente != null) {
        pushEntityDetail(context, existente.id);
        return;
      }
      final crear = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Esa nota no existe todavía'),
          content: Text('¿Crear una nota llamada "$titulo"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Crear'),
            ),
          ],
        ),
      );
      if (crear != true) return;
      final id = await repo.createNote(titulo);
      if (context.mounted) pushEntityDetail(context, id);
    },
  );
}

/// "Mencionado en": quién enlaza a [entity] con `[[título]]`. No se dibuja
/// nada si nadie la menciona.
class MencionesSection extends ConsumerWidget {
  const MencionesSection({super.key, required this.entity});

  final EntityRow entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return StreamBuilder<List<BacklinkHit>>(
      stream: ref.watch(linkRepositoryProvider).watchBacklinks(entity),
      builder: (context, snapshot) {
        final hits = snapshot.data ?? const <BacklinkHit>[];
        if (hits.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Mencionado en', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final h in hits)
              Card(
                child: ListTile(
                  leading: Icon(
                    h.isTask ? Icons.check_circle_outline : Icons.link,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(h.title),
                  subtitle: Text(h.isTask ? 'Tarea' : h.type?.label ?? ''),
                  onTap: () => h.isTask
                      ? pushTaskDetail(context, h.id)
                      : pushEntityDetail(context, h.id),
                ),
              ),
          ],
        );
      },
    );
  }
}
