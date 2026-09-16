import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/features/sync/sync_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';
import 'package:octo_dash/activities/data/task_repository.dart';

/// Fake sin librería de mocking (el proyecto no usa mockito/mocktail).
class FakeSyncClient implements SyncClient {
  FakeSyncClient({this.tables = const {}, this.failTables = const {}});
  final Map<String, List<Map<String, dynamic>>> tables;
  final Set<String> failTables;
  final List<MapEntry<String, Map<String, dynamic>>> upserts = [];

  @override
  Future<void> upsert(String table, Map<String, dynamic> row) async {
    if (failTables.contains(table)) throw Exception('fake failure: $table');
    upserts.add(MapEntry(table, row));
  }

  @override
  Future<List<Map<String, dynamic>>> selectAll(String table) async =>
      tables[table] ?? [];
}

void main() {
  late AppDatabase db;
  late EntityRepository entities;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
  });

  tearDown(() => db.close());

  test('resuelve relation_type_id local -> key -> id remoto al pushear relations', () async {
    final localTypes = await db.select(db.relationTypes).get();
    // Ids remotos deliberadamente distintos a los locales, mismas keys.
    final remoteRelationTypes = [
      for (final t in localTypes)
        {'id': 'remote-${t.key}', 'key': t.key},
    ];

    final source = await entities.create(
      type: EntityType.note,
      title: 'Nota',
    );
    final target = await entities.create(
      type: EntityType.resource,
      title: 'Curso',
    );
    final relations = RelationRepository(db);
    await relations.create(
      sourceEntityId: source,
      targetEntityId: target,
      relationTypeKey: 'related_to',
    );

    final fake = FakeSyncClient(
      tables: {'relation_types': remoteRelationTypes},
    );
    await pushDirtyData(db, userId: 'u1', client: fake);

    final relationUpsert = fake.upserts.firstWhere((e) => e.key == 'relations').value;
    expect(relationUpsert['relation_type_id'], 'remote-related_to');
  });

  test('limpia dirty tras un push exitoso', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    final tags = TagRepository(db);
    await tags.tagEntity(entityId, 'programacion');

    final fake = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fake);

    final entityRow = await (db.select(
      db.entities,
    )..where((e) => e.id.equals(entityId))).getSingle();
    expect(entityRow.dirty, isFalse);

    final tagRows = await db.select(db.tags).get();
    expect(tagRows.every((t) => !t.dirty), isTrue);

    final entityTagRows = await db.select(db.entityTags).get();
    expect(entityTagRows.every((et) => !et.dirty), isTrue);

    final projectRows = await db.select(db.projects).get();
    expect(projectRows.every((p) => !p.dirty), isTrue);
  });

  test('pushea la fila de tipo (projects) junto con su Entity', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );

    final fake = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fake);

    final projectUpsert = fake.upserts.firstWhere((e) => e.key == 'projects').value;
    expect(projectUpsert['entity_id'], entityId);
    expect(projectUpsert['user_id'], 'u1');
  });

  test('un fallo en una tabla no bloquea el push de las demás, y esa fila sigue dirty para reintento', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    final taskRepo = TaskRepository(db);
    await taskRepo.create(title: 'Hacer algo');

    final fake = FakeSyncClient(failTables: {'entities'});
    await pushDirtyData(db, userId: 'u1', client: fake);

    final entityRow = await (db.select(
      db.entities,
    )..where((e) => e.id.equals(entityId))).getSingle();
    expect(entityRow.dirty, isTrue);

    final taskRows = await db.select(db.tasks).get();
    expect(taskRows.every((t) => !t.dirty), isTrue);
  });

  test('el soft-delete de activity_links y entity_tags se propaga como upsert con deleted_at', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    final taskRepo = TaskRepository(db);
    final taskId = await taskRepo.create(title: 'Hacer algo');
    await taskRepo.linkToEntity(taskId, entityId, 'part_of');

    final tagRepo = TagRepository(db);
    await tagRepo.tagEntity(entityId, 'urgente');

    final fake = FakeSyncClient();
    // Primer ciclo: sube todo "vivo" (dirty=true por defecto al crear).
    await pushDirtyData(db, userId: 'u1', client: fake);

    await taskRepo.delete(taskId);
    await tagRepo.untagEntity(entityId, 'urgente');

    final fakeDelete = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fakeDelete);

    final linkUpsert = fakeDelete.upserts.firstWhere((e) => e.key == 'activity_links').value;
    expect(linkUpsert['deleted_at'], isNotNull);

    final entityTagUpsert = fakeDelete.upserts.firstWhere((e) => e.key == 'entity_tags').value;
    expect(entityTagUpsert['deleted_at'], isNotNull);
  });
}
