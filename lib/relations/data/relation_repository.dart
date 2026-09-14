import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class RelationDisplayItem {
  RelationDisplayItem({
    required this.relationId,
    required this.otherEntityId,
    required this.otherEntityTitle,
    required this.label,
    this.note,
  });

  final String relationId;
  final String otherEntityId;
  final String otherEntityTitle;
  final String label; // label directo o inverseLabel, según el lado
  final String? note;
}

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

  /// Resuelve, para cada relación de la entity, cuál es "la otra punta" y
  /// qué label mostrar (directo si esta entity es source, inverso si es
  /// target) — la vista de detalle no necesita saber de relation_types.
  Future<List<RelationDisplayItem>> listForEntityDisplay(
    String entityId,
  ) async {
    final rows = await (_db.select(_db.relations)..where(
          (r) =>
              (r.sourceEntityId.equals(entityId) |
                  r.targetEntityId.equals(entityId)) &
              r.deletedAt.isNull(),
        ))
        .get();

    final result = <RelationDisplayItem>[];
    for (final r in rows) {
      final isSource = r.sourceEntityId == entityId;
      final otherId = isSource ? r.targetEntityId : r.sourceEntityId;
      final other = await (_db.select(
        _db.entities,
      )..where((e) => e.id.equals(otherId))).getSingle();
      final type = await (_db.select(
        _db.relationTypes,
      )..where((t) => t.id.equals(r.relationTypeId))).getSingle();
      result.add(
        RelationDisplayItem(
          relationId: r.id,
          otherEntityId: other.id,
          otherEntityTitle: other.title,
          label: isSource ? type.label : type.inverseLabel,
          note: r.note,
        ),
      );
    }
    return result;
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
