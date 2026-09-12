import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../domain/entity_type.dart';

class EntityRepository {
  EntityRepository(this._db);
  final AppDatabase _db;

  /// Crea la Entity y su fila específica de tipo en la misma transacción.
  Future<String> create({
    required EntityType type,
    required String title,
    String? description,
    EntityStatus status = EntityStatus.active,
  }) {
    final id = const Uuid().v4();
    return _db.transaction(() async {
      await _db
          .into(_db.entities)
          .insert(
            EntitiesCompanion.insert(
              id: Value(id),
              type: type.name,
              title: title,
              description: Value(description),
              status: Value(status.name),
            ),
          );
      await _insertTypeRow(type, id);
      return id;
    });
  }

  Future<void> _insertTypeRow(EntityType type, String entityId) async {
    switch (type) {
      case EntityType.project:
        await _db
            .into(_db.projects)
            .insert(ProjectsCompanion.insert(entityId: entityId));
        break;
      case EntityType.note:
        await _db
            .into(_db.notes)
            .insert(NotesCompanion.insert(entityId: entityId));
        break;
      case EntityType.area:
        await _db
            .into(_db.areas)
            .insert(AreasCompanion.insert(entityId: entityId));
        break;
      case EntityType.resource:
        await _db
            .into(_db.resources)
            .insert(ResourcesCompanion.insert(entityId: entityId));
        break;
      case EntityType.person:
        await _db
            .into(_db.people)
            .insert(PeopleCompanion.insert(entityId: entityId));
        break;
      case EntityType.hobby:
        await _db
            .into(_db.hobbies)
            .insert(HobbiesCompanion.insert(entityId: entityId));
        break;
      case EntityType.goal:
        await _db
            .into(_db.goals)
            .insert(GoalsCompanion.insert(entityId: entityId));
        break;
    }
  }

  Stream<List<EntityRow>> watchByType(EntityType type) =>
      _db.watchEntitiesByType(type.name);

  Future<void> touch(String id) {
    return (_db.update(_db.entities)..where((e) => e.id.equals(id))).write(
      EntitiesCompanion(updatedAt: Value(DateTime.now()), dirty: const Value(true)),
    );
  }

  Future<void> changeStatus(String id, EntityStatus status) {
    return (_db.update(_db.entities)..where((e) => e.id.equals(id))).write(
      EntitiesCompanion(
        status: Value(status.name),
        updatedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<List<EntityRow>> listActive() => _db.entitiesActivos();
  Future<List<EntityRow>> listStagnant(int diasSinTocar) =>
      _db.entitiesEstancados(diasSinTocar);
  Future<List<EntityRow>> wishlistSuggestions(int cantidad) =>
      _db.wishlistSugerencias(cantidad);
}
