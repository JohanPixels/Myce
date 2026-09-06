import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/node_repository_provider.dart';

const _estados = ['activo', 'pausado', 'someday', 'archivado'];

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.tipo, required this.titulo});

  final String tipo;
  final String titulo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(nodeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: StreamBuilder<List<NodeEntry>>(
        stream: repo.watchPorTipo(tipo),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(child: Text('Nada en $titulo todavía'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final n = items[i];
              return ListTile(
                title: Text(n.titulo),
                subtitle: Text(
                  n.subtipo != null ? '${n.estado} · ${n.subtipo}' : n.estado,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (nuevoEstado) =>
                      repo.cambiarEstado(n.id, nuevoEstado),
                  itemBuilder: (ctx) => _estados
                      .map((e) => PopupMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
