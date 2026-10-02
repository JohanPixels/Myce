import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/navigation/navigation_helpers.dart';
import '../entities/data/entity_repository_provider.dart';
import '../entities/domain/entity_type.dart';
import '../core/widgets/copiar.dart';

const _diasEstancado = 7;

final entitiesActivasProvider = FutureProvider.autoDispose<List<EntityRow>>((
  ref,
) {
  return ref.watch(entityRepositoryProvider).listActive();
});

final entitiesEstancadasProvider = FutureProvider.autoDispose<List<EntityRow>>((
  ref,
) {
  return ref.watch(entityRepositoryProvider).listStagnant(_diasEstancado);
});

final wishlistSugerenciasProvider = FutureProvider.autoDispose<List<EntityRow>>(
  (ref) {
    return ref.watch(entityRepositoryProvider).wishlistSuggestions(3);
  },
);

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Seccion(
          titulo: '🟢 Activos',
          provider: entitiesActivasProvider,
          vacio: 'No tienes entities activas',
        ),
        const SizedBox(height: 24),
        _Seccion(
          titulo: '🟡 Estancados (+$_diasEstancado días sin tocar)',
          provider: entitiesEstancadasProvider,
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
  final AutoDisposeFutureProvider<List<EntityRow>> provider;
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
              children: items.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(e.title),
                    subtitle: Text(e.type.toEntityType().label),
                    onTap: () => pushEntityDetail(context, e.id),
                    onLongPress: () => copiarTexto(context, e.title),
                    trailing: mostrarAcciones
                        ? PopupMenuButton<String>(
                            onSelected: (accion) {
                              final repo = ref.read(entityRepositoryProvider);
                              if (accion == 'pausar') {
                                repo.changeStatus(e.id, EntityStatus.paused);
                              } else if (accion == 'retomar') {
                                repo.touch(e.id);
                              }
                              ref.invalidate(entitiesEstancadasProvider);
                              ref.invalidate(entitiesActivasProvider);
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
