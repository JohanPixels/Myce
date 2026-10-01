import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../data/entity_repository.dart';
import '../domain/entity_type.dart';

/// Reusa `EntityRepository.search()` (ya conectado en los sheets de
/// "vincular con otra entity") como buscador general, accesible desde
/// cualquier pantalla vía el ícono en el AppBar del shell. Devuelve el id
/// elegido — quien llama a `showSearch` decide cómo navegar, así este
/// delegate no depende de en qué rama del bottom nav estás parado.
class EntitySearchDelegate extends SearchDelegate<String?> {
  EntitySearchDelegate(this._entityRepo);

  final EntityRepository _entityRepo;

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildLista(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildLista(context);

  Widget _buildLista(BuildContext context) {
    final texto = query.trim();
    if (texto.isEmpty) {
      return const Center(child: Text('Buscá por título'));
    }
    return FutureBuilder<List<EntityRow>>(
      future: _entityRepo.search(texto),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final resultados = snapshot.data!;
        if (resultados.isEmpty) {
          return const Center(child: Text('Sin resultados'));
        }
        return ListView.builder(
          itemCount: resultados.length,
          itemBuilder: (context, i) {
            final e = resultados[i];
            return ListTile(
              title: Text(e.title),
              subtitle: Text(e.type.toEntityType().label),
              onTap: () => close(context, e.id),
            );
          },
        );
      },
    );
  }
}
