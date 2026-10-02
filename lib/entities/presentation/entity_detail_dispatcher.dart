import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../projects/presentation/project_detail_screen.dart';
import '../data/entity_repository_provider.dart';
import '../domain/entity_type.dart';
import 'entity_detail_screen.dart';

/// Destino de la ruta `entity/:id`: un Project abre su pantalla propia, el
/// resto de los tipos la genérica. Así cualquier puerta (búsqueda,
/// relaciones, "Ver" tras clasificar) lleva a la vista correcta sin que
/// quien navega tenga que saber el tipo.
class EntityDetailDispatcher extends ConsumerWidget {
  const EntityDetailDispatcher({super.key, required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<EntityRow?>(
      stream: ref.watch(entityRepositoryProvider).watchById(entityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data?.type == EntityType.project.name) {
          return ProjectDetailScreen(projectId: entityId);
        }
        return EntityDetailScreen(entityId: entityId);
      },
    );
  }
}
