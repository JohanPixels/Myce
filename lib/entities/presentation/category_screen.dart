import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../data/entity_repository_provider.dart';
import '../domain/entity_type.dart';
import 'entity_detail_screen.dart';

const _estados = ['active', 'paused', 'someday', 'archived'];

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({
    super.key,
    required this.type,
    required this.titulo,
    this.showWishlistFilter = false,
  });

  final EntityType type;
  final String titulo;
  final bool showWishlistFilter;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  bool _soloWishlist = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(entityRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Column(
        children: [
          if (widget.showWishlistFilter)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Todos')),
                  ButtonSegment(value: true, label: Text('Wishlist')),
                ],
                selected: {_soloWishlist},
                onSelectionChanged: (s) =>
                    setState(() => _soloWishlist = s.first),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<EntityRow>>(
              stream: repo.watchByType(widget.type),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var items = snapshot.data!;
                if (_soloWishlist) {
                  items = items.where((e) => e.status == 'someday').toList();
                }
                if (items.isEmpty) {
                  return Center(
                    child: Text('Nada en ${widget.titulo} todavía'),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final e = items[i];
                    return ListTile(
                      title: Text(e.title),
                      subtitle: Text(e.status),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EntityDetailScreen(entityId: e.id),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (nuevoEstado) => repo.changeStatus(
                          e.id,
                          nuevoEstado.toEntityStatus(),
                        ),
                        itemBuilder: (ctx) => _estados
                            .map(
                              (s) => PopupMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
