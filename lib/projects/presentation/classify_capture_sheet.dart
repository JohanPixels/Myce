import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../data/project_repository.dart';
import '../data/project_repository_provider.dart';

/// Recorre las capturas "sin clasificar" del proyecto una por una: muestra
/// la primera y cuatro botones (Tarea / Observación / Requisito / Idea).
/// Al clasificar pasa sola a la siguiente; se cierra cuando no queda nada.
Future<void> mostrarClasificarCapturasSheet(
  BuildContext context, {
  required String projectId,
  required String projectTitle,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        _ClasificarSheet(projectId: projectId, projectTitle: projectTitle),
  );
}

class _ClasificarSheet extends ConsumerStatefulWidget {
  const _ClasificarSheet({required this.projectId, required this.projectTitle});

  final String projectId;
  final String projectTitle;

  @override
  ConsumerState<_ClasificarSheet> createState() => _ClasificarSheetState();
}

class _ClasificarSheetState extends ConsumerState<_ClasificarSheet> {
  bool _cerrando = false;

  /// Ids ya enviados a clasificar: se ocultan al instante (UI optimista) sin
  /// esperar a que el stream confirme el cambio.
  final _procesados = <String>{};

  void _cerrar() {
    if (_cerrando) return;
    _cerrando = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(projectRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<InboxItemRow>>(
      stream: repo.watchUnclassified(widget.projectId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final pendientes = snapshot.data!
            .where((i) => !_procesados.contains(i.id))
            .toList();
        if (pendientes.isEmpty) {
          _cerrar();
          return const SizedBox(height: 160);
        }
        final item = pendientes.first;

        void elegir(ProjectCaptureKind kind) {
          setState(() => _procesados.add(item.id));
          repo.classifyCapture(widget.projectId, item.id, kind);
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            24 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sin clasificar · quedan ${pendientes.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Luego'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '“${item.content}”',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Qué es esto?',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
                children: [
                  _Opcion(
                    titulo: 'Tarea',
                    detalle: 'Una acción que puedo hacer',
                    destacada: true,
                    onTap: () => elegir(ProjectCaptureKind.task),
                  ),
                  _Opcion(
                    titulo: 'Observación',
                    detalle: 'Algo que noté, aún sin solución',
                    onTap: () => elegir(ProjectCaptureKind.observation),
                  ),
                  _Opcion(
                    titulo: 'Requisito',
                    detalle: 'Algo que ${widget.projectTitle} debe cumplir',
                    onTap: () => elegir(ProjectCaptureKind.requirement),
                  ),
                  _Opcion(
                    titulo: 'Idea',
                    detalle: 'Quizás algún día',
                    onTap: () => elegir(ProjectCaptureKind.idea),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Descartar'),
                  onPressed: () {
                    setState(() => _procesados.add(item.id));
                    repo.discardCapture(item.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.titulo,
    required this.detalle,
    required this.onTap,
    this.destacada = false,
  });

  final String titulo;
  final String detalle;
  final VoidCallback onTap;
  final bool destacada;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: destacada ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.octoSpacing.md - 2,
            vertical: context.octoSpacing.sm,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: destacada ? scheme.primary : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detalle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
