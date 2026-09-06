import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../nodes/data/database.dart';
import '../nodes/data/node_repository_provider.dart';

const _diasEstancado = 7;

final nodosActivosProvider = FutureProvider.autoDispose<List<NodeEntry>>((ref) {
  return ref.watch(nodeRepositoryProvider).nodosActivos();
});

final nodosEstancadosProvider = FutureProvider.autoDispose<List<NodeEntry>>((
  ref,
) {
  return ref.watch(nodeRepositoryProvider).nodosEstancados(_diasEstancado);
});

final wishlistSugerenciasProvider = FutureProvider.autoDispose<List<NodeEntry>>(
  (ref) {
    return ref.watch(nodeRepositoryProvider).wishlistSugerencias(3);
  },
);

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revisión semanal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Seccion(
            titulo: '🟢 Activos',
            provider: nodosActivosProvider,
            vacio: 'No tienes nodos activos',
          ),
          const SizedBox(height: 24),
          _Seccion(
            titulo: '🟡 Estancados (+$_diasEstancado días sin tocar)',
            provider: nodosEstancadosProvider,
            vacio: 'Nada estancado — vas al día',
            mostrarAcciones: true,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎲 Para tu tiempo libre',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(wishlistSugerenciasProvider),
              ),
            ],
          ),
          _Seccion(
            titulo: '',
            provider: wishlistSugerenciasProvider,
            vacio: 'Nada en tu wishlist todavía',
          ),
        ],
      ),
    );
  }
}

class _Seccion extends ConsumerWidget {
  const _Seccion({
    required this.titulo,
    required this.provider,
    required this.vacio,
    this.mostrarAcciones = false,
  });

  final String titulo;
  final AutoDisposeFutureProvider<List<NodeEntry>> provider;
  final String vacio;
  final bool mostrarAcciones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo.isNotEmpty) ...[
          Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
        asyncItems.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error: $e'),
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  vacio,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
            return Column(
              children: items.map((n) {
                return Card(
                  child: ListTile(
                    title: Text(n.titulo),
                    subtitle: Text(n.subtipo ?? n.tipo ?? ''),
                    trailing: mostrarAcciones
                        ? PopupMenuButton<String>(
                            onSelected: (accion) {
                              final repo = ref.read(nodeRepositoryProvider);
                              if (accion == 'pausar') {
                                repo.cambiarEstado(n.id, 'pausado');
                              } else if (accion == 'retomar') {
                                repo.tocar(n.id);
                              }
                              ref.invalidate(nodosEstancadosProvider);
                              ref.invalidate(nodosActivosProvider);
                            },
                            itemBuilder: (ctx) => const [
                              PopupMenuItem(
                                value: 'retomar',
                                child: Text('Retomar (marcar tocado)'),
                              ),
                              PopupMenuItem(
                                value: 'pausar',
                                child: Text('Pausar'),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
