import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/inbox_repository_provider.dart';
import '../core/navigation/navigation_helpers.dart';
import '../entities/presentation/classify_sheet.dart';
import '../core/widgets/copiar.dart';
import '../core/widgets/renombrar_dialog.dart';
import '../core/theme/app_icons.dart';
import '../core/widgets/estado_vacio.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  /// Eliminados en esta pantalla que el stream todavía no confirmó — se
  /// ocultan ya, porque un `Dismissible` deslizado no puede seguir en el
  /// árbol ni un frame más.
  final _ocultos = <String>{};

  void _eliminar(String inboxItemId) {
    final repo = ref.read(inboxRepositoryProvider);
    setState(() => _ocultos.add(inboxItemId));
    repo.markProcessed(inboxItemId);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Eliminado del Inbox'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              repo.restore(inboxItemId);
              if (mounted) setState(() => _ocultos.remove(inboxItemId));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(inboxRepositoryProvider);

    return StreamBuilder(
      stream: repo.watchInbox(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!
            .where((i) => !_ocultos.contains(i.id))
            .toList();
        final theme = Theme.of(context);
        if (items.isEmpty) {
          return const EstadoVacioGrande(
            icono: AppIconsDuo.inbox,
            titulo: 'Inbox vacío',
            texto:
                'Captura lo que se te ocurra con el + y decide después qué es.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
          itemCount: items.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                child: Text(
                  '${items.length} por clasificar · toca para decidir qué es, '
                  'desliza para borrar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            final item = items[i - 1];
            // Deslizar hacia cualquier lado elimina (con "Deshacer").
            return Dismissible(
              key: ValueKey(item.id),
              background: const _FondoEliminar(alignment: Alignment.centerLeft),
              secondaryBackground: const _FondoEliminar(
                alignment: Alignment.centerRight,
              ),
              onDismissed: (_) => _eliminar(item.id),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                  title: Text(item.content),
                  subtitle: Text(
                    _hace(item.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () => _clasificar(context, ref, item.id),
                  onLongPress: () => copiarTexto(context, item.content),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Opciones',
                    onSelected: (accion) async {
                      switch (accion) {
                        case 'editar':
                          final nuevo = await pedirNuevoTexto(
                            context,
                            titulo: 'Editar captura',
                            actual: item.content,
                            multilinea: true,
                          );
                          if (nuevo != null) repo.updateContent(item.id, nuevo);
                        case 'copiar':
                          if (context.mounted) {
                            copiarTexto(context, item.content);
                          }
                        case 'eliminar':
                          if (context.mounted) _eliminar(item.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'copiar', child: Text('Copiar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FondoEliminar extends StatelessWidget {
  const _FondoEliminar({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(AppIcons.eliminar, color: scheme.onErrorContainer),
    );
  }
}

Future<void> _clasificar(
  BuildContext context,
  WidgetRef ref,
  String inboxItemId,
) async {
  final resultado = await mostrarClasificarSheet(context, ref, inboxItemId);
  if (resultado == null || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Movido a ${resultado.label}'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Ver',
        onPressed: () => resultado.isTask
            ? pushTaskDetail(context, resultado.id)
            : pushEntityDetail(context, resultado.id),
      ),
    ),
  );
}

String _hace(DateTime fecha) {
  final diff = DateTime.now().difference(fecha);
  if (diff.inMinutes < 1) return 'ahora mismo';
  if (diff.inHours < 1) return 'hace ${diff.inMinutes} min';
  if (diff.inDays < 1) return 'hace ${diff.inHours} h';
  return 'hace ${diff.inDays} d';
}
