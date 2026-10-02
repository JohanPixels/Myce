import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../activities/data/task_repository.dart';
import '../../activities/domain/task_enums.dart';
import '../data/entity_repository.dart';
import '../domain/entity_type.dart';

/// Reusa `EntityRepository.search()` (ya conectado en los sheets de
/// "vincular con otra entity") como buscador general, accesible desde
/// cualquier pantalla vía el ícono en el AppBar del shell. Devuelve el id
/// elegido — quien llama a `showSearch` decide cómo navegar, así este
/// delegate no depende de en qué rama del bottom nav estás parado.
/// Qué eligió la persona en el buscador — quien llama decide cómo navegar.
class SearchHit {
  const SearchHit(this.id, {required this.isTask});

  final String id;
  final bool isTask;
}

/// Buscador general: Entities (por título) y Tasks (título y descripción),
/// accesible desde el ícono del AppBar del shell.
class EntitySearchDelegate extends SearchDelegate<SearchHit?> {
  EntitySearchDelegate(this._entityRepo, this._taskRepo)
    : super(searchFieldLabel: 'Buscar');

  final EntityRepository _entityRepo;
  final TaskRepository _taskRepo;

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
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

  Future<(List<EntityRow>, List<TaskRow>)> _buscar(String texto) async =>
      (await _entityRepo.search(texto), await _taskRepo.search(texto));

  Widget _buildLista(BuildContext context) {
    final texto = query.trim();
    final theme = Theme.of(context);
    if (texto.isEmpty) {
      return const Center(child: Text('Busca proyectos, notas, tareas…'));
    }
    return FutureBuilder<(List<EntityRow>, List<TaskRow>)>(
      future: _buscar(texto),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final (entidades, tareas) = snapshot.data!;
        if (entidades.isEmpty && tareas.isEmpty) {
          return const Center(child: Text('Sin resultados'));
        }
        Widget encabezado(String t) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            t.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        );
        return ListView(
          children: [
            if (entidades.isNotEmpty) encabezado('Proyectos, notas y más'),
            for (final e in entidades)
              ListTile(
                title: Text(e.title),
                subtitle: Text(e.type.toEntityType().label),
                onTap: () => close(context, SearchHit(e.id, isTask: false)),
              ),
            if (tareas.isNotEmpty) encabezado('Tareas'),
            for (final t in tareas)
              ListTile(
                leading: Icon(
                  t.status == TaskStatus.completed.name
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                title: Text(t.title),
                subtitle: Text(t.status.toTaskStatus().label),
                onTap: () => close(context, SearchHit(t.id, isTask: true)),
              ),
          ],
        );
      },
    );
  }
}
