import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class TagRepository {
  TagRepository(this._db);
  final AppDatabase _db;

  Future<String> _findOrCreate(String name) async {
    final normalized = name.trim().toLowerCase();
    final existing = await (_db.select(
      _db.tags,
    )..where((t) => t.name.equals(normalized))).getSingleOrNull();
    if (existing != null) return existing.id;
    final id = const Uuid().v4();
    await _db
        .into(_db.tags)
        .insert(TagsCompanion.insert(id: Value(id), name: normalized));
    return id;
  }

  Future<void> tagEntity(String entityId, String tagName) async {
    final tagId = await _findOrCreate(tagName);
    await _db
        .into(_db.entityTags)
        .insertOnConflictUpdate(
          EntityTagsCompanion.insert(entityId: entityId, tagId: tagId),
        );
  }

  Future<void> untagEntity(String entityId, String tagName) async {
    final normalized = tagName.trim().toLowerCase();
    final tag = await (_db.select(
      _db.tags,
    )..where((t) => t.name.equals(normalized))).getSingleOrNull();
    if (tag == null) return;
    await (_db.delete(_db.entityTags)..where(
          (et) => et.entityId.equals(entityId) & et.tagId.equals(tag.id),
        ))
        .go();
  }

  Stream<List<TagRow>> watchTagsForEntity(String entityId) {
    final query =
        _db.select(_db.tags).join([
            innerJoin(
              _db.entityTags,
              _db.entityTags.tagId.equalsExp(_db.tags.id),
            ),
          ])
          ..where(_db.entityTags.entityId.equals(entityId));
    return query.watch().map(
      (rows) => rows.map((r) => r.readTable(_db.tags)).toList(),
    );
  }
}
