import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class RelationRepository {
  RelationRepository(this._db);
  final AppDatabase _db;

  Future<List<RelationTypeRow>> listRelationTypes() =>
      _db.select(_db.relationTypes).get();

  Future<String> create({
    required String sourceEntityId,
    required String targetEntityId,
    required String relationTypeKey,
    String? note,
  }) async {
    final type = await (_db.select(
      _db.relationTypes,
    )..where((t) => t.key.equals(relationTypeKey))).getSingle();
    final id = const Uuid().v4();
    await _db
        .into(_db.relations)
        .insert(
          RelationsCompanion.insert(
            id: Value(id),
            sourceEntityId: sourceEntityId,
            targetEntityId: targetEntityId,
            relationTypeId: type.id,
            note: Value(note),
          ),
        );
    return id;
  }

  /// Relaciones donde la entity participa como source o target.
  /// Calcular cuál label mostrar (directa o inversa) es responsabilidad de
  /// la UI — acá solo se entregan las filas (docs/fuente_de_verdad.md §6.1).
  Stream<List<RelationRow>> watchForEntity(String entityId) {
    return (_db.select(_db.relations)..where(
          (r) =>
              (r.sourceEntityId.equals(entityId) |
                  r.targetEntityId.equals(entityId)) &
              r.deletedAt.isNull(),
        ))
        .watch();
  }

  Future<void> delete(String id) {
    return (_db.update(_db.relations)..where((r) => r.id.equals(id))).write(
      RelationsCompanion(
        deletedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }
}
