import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/features/sync/sync_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';

/// Fake sin librería de mocking (el proyecto no usa mockito/mocktail).
class FakeSyncClient implements SyncClient {
  FakeSyncClient({
    this.tables = const {},
    this.failTables = const {},
    this.failSelectTables = const {},
  });
  final Map<String, List<Map<String, dynamic>>> tables;
  final Set<String> failTables;
  final Set<String> failSelectTables;
  final List<MapEntry<String, Map<String, dynamic>>> upserts = [];

  @override
  Future<void> upsert(String table, Map<String, dynamic> row) async {
    if (failTables.contains(table)) throw Exception('fake failure: $table');
    upserts.add(MapEntry(table, row));
  }

  @override
  Future<List<Map<String, dynamic>>> selectAll(String table) async {
    if (failSelectTables.contains(table)) {
      throw Exception('fake select failure: $table');
    }
    return tables[table] ?? [];
  }
}

/// Fixture de relation_types remoto: mismas keys que el vocabulario local
/// (initialRelationTypes), ids deliberadamente distintos.
List<Map<String, dynamic>> _remoteRelationTypes(List<RelationTypeRow> local) =>
    [for (final t in local) {'id': 'remote-${t.key}', 'key': t.key}];

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

  test('pushea horizonte y tamaño de una Task', () async {
    final taskRepo = TaskRepository(db);
    final id = await taskRepo.create(title: 'Algo', horizon: TaskHorizon.now);
    await taskRepo.changeSize(id, TaskSize.hour);

    final fake = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fake);

    final upsert = fake.upserts.firstWhere((e) => e.key == 'tasks').value;
    expect(upsert['horizon'], 'now');
    expect(upsert['size'], 'hour');
  });

  test('pushea el entity_id de una captura hecha dentro de un proyecto', () async {
    final projectId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    await db.into(db.inboxItems).insert(
      InboxItemsCompanion.insert(content: 'algo', entityId: Value(projectId)),
    );

    final fake = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fake);

    final upsert = fake.upserts.firstWhere((e) => e.key == 'inbox_items').value;
    expect(upsert['entity_id'], projectId);
  });

  test('pushea emoji y color de un Project', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    await (db.update(db.projects)..where((p) => p.entityId.equals(entityId)))
        .write(const ProjectsCompanion(emoji: Value('🍄'), color: Value('cyan')));

    final fake = FakeSyncClient();
    await pushDirtyData(db, userId: 'u1', client: fake);

    final projectUpsert = fake.upserts.firstWhere((e) => e.key == 'projects').value;
    expect(projectUpsert['emoji'], '🍄');
    expect(projectUpsert['color'], 'cyan');
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

  test('pull hidrata un local vacío con entities/relations/tasks/tags/activity_links/inbox remotos', () async {
    final localTypes = await db.select(db.relationTypes).get();
    final remoteRelationTypeId = 'remote-related_to';

    final fake = FakeSyncClient(
      tables: {
        'relation_types': _remoteRelationTypes(localTypes),
        'entities': [
          {
            'id': 'e1',
            'type': 'project',
            'title': 'Proyecto remoto',
            'description': null,
            'status': 'active',
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
          {
            'id': 'e2',
            'type': 'note',
            'title': 'Nota remota',
            'description': null,
            'status': 'active',
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
        'projects': [
          {'entity_id': 'e1', 'started_at': null, 'completed_at': null},
        ],
        'notes': [
          {'entity_id': 'e2', 'content': 'contenido remoto'},
        ],
        'tags': [
          {'id': 't1', 'name': 'trabajo'},
        ],
        'entity_tags': [
          {
            'entity_id': 'e1',
            'tag_id': 't1',
            'created_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
        'relations': [
          {
            'id': 'r1',
            'source_entity_id': 'e1',
            'target_entity_id': 'e2',
            'relation_type_id': remoteRelationTypeId,
            'note': null,
            'metadata': null,
            'created_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
        'tasks': [
          {
            'id': 'task1',
            'title': 'Tarea remota',
            'description': null,
            'status': 'pending',
            'priority': 'none',
            'due_at': null,
            'completed_at': null,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
        'activity_links': [
          {
            'id': 'link1',
            'activity_type': 'task',
            'activity_id': 'task1',
            'entity_id': 'e1',
            'link_type': 'part_of',
            'created_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
        'inbox_items': [
          {
            'id': 'inbox1',
            'content': 'algo capturado',
            'created_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
      },
    );

    await pullRemoteData(db, userId: 'u1', client: fake);

    final e1 = await (db.select(db.entities)..where((e) => e.id.equals('e1'))).getSingle();
    expect(e1.title, 'Proyecto remoto');
    expect(e1.dirty, isFalse);

    final project = await (db.select(db.projects)..where((p) => p.entityId.equals('e1'))).getSingle();
    expect(project.dirty, isFalse);

    final note = await (db.select(db.notes)..where((n) => n.entityId.equals('e2'))).getSingle();
    expect(note.content, 'contenido remoto');

    final tag = await (db.select(db.tags)..where((t) => t.id.equals('t1'))).getSingle();
    expect(tag.name, 'trabajo');

    final entityTag = await (db.select(db.entityTags)
          ..where((et) => et.entityId.equals('e1') & et.tagId.equals('t1')))
        .getSingle();
    expect(entityTag.dirty, isFalse);

    final relation = await (db.select(db.relations)..where((r) => r.id.equals('r1'))).getSingle();
    final localRelatedTo = localTypes.firstWhere((t) => t.key == 'related_to');
    expect(relation.relationTypeId, localRelatedTo.id);

    final task = await (db.select(db.tasks)..where((t) => t.id.equals('task1'))).getSingle();
    expect(task.title, 'Tarea remota');

    final link = await (db.select(db.activityLinks)..where((l) => l.id.equals('link1'))).getSingle();
    expect(link.activityId, 'task1');

    final inboxItem = await (db.select(db.inboxItems)..where((i) => i.id.equals('inbox1'))).getSingle();
    expect(inboxItem.content, 'algo capturado');
  });

  test('pull no pisa una fila local dirty con una versión remota vieja', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Título local sin pushear',
    );

    final fake = FakeSyncClient(
      tables: {
        'entities': [
          {
            'id': entityId,
            'type': 'project',
            'title': 'Título remoto viejo',
            'description': null,
            'status': 'active',
            'created_at': '2020-01-01T00:00:00.000Z',
            'updated_at': '2020-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
      },
    );

    await pullRemoteData(db, userId: 'u1', client: fake);

    final entityRow = await (db.select(db.entities)..where((e) => e.id.equals(entityId))).getSingle();
    expect(entityRow.title, 'Título local sin pushear');
    expect(entityRow.dirty, isTrue);
  });

  test('el soft-delete remoto de una Task se propaga a local vía pull', () async {
    final taskRepo = TaskRepository(db);
    final taskId = await taskRepo.create(title: 'Se borra en el otro dispositivo');
    await pushDirtyData(db, userId: 'u1', client: FakeSyncClient());

    final fake = FakeSyncClient(
      tables: {
        'tasks': [
          {
            'id': taskId,
            'title': 'Se borra en el otro dispositivo',
            'description': null,
            'status': 'cancelled',
            'priority': 'none',
            'due_at': null,
            'completed_at': null,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-02T00:00:00.000Z',
            'deleted_at': '2026-01-02T00:00:00.000Z',
          },
        ],
      },
    );
    await pullRemoteData(db, userId: 'u1', client: fake);

    final taskRow = await (db.select(db.tasks)..where((t) => t.id.equals(taskId))).getSingle();
    expect(taskRow.deletedAt, isNotNull);
    expect(taskRow.dirty, isFalse);
  });

  test('un fallo de red en una tabla no bloquea el pull de las demás', () async {
    final fake = FakeSyncClient(
      failSelectTables: {'entities'},
      tables: {
        'tags': [
          {'id': 't1', 'name': 'trabajo'},
        ],
      },
    );

    await pullRemoteData(db, userId: 'u1', client: fake);

    final tagRows = await db.select(db.tags).get();
    expect(tagRows.any((t) => t.id == 't1'), isTrue);
  });

  test('syncNow pushea lo local dirty y pulea lo remoto en el mismo ciclo', () async {
    final taskRepo = TaskRepository(db);
    final localTaskId = await taskRepo.create(title: 'Tarea local sin pushear');

    final fake = FakeSyncClient(
      tables: {
        'tasks': [
          {
            'id': 'task-remoto',
            'title': 'Tarea del otro dispositivo',
            'description': null,
            'status': 'pending',
            'priority': 'none',
            'due_at': null,
            'completed_at': null,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'deleted_at': null,
          },
        ],
      },
    );

    await syncNow(db, userId: 'u1', client: fake);

    final pushedTask = fake.upserts.firstWhere(
      (e) => e.key == 'tasks' && e.value['id'] == localTaskId,
    );
    expect(pushedTask.value['title'], 'Tarea local sin pushear');

    final pulledTask = await (db.select(db.tasks)..where((t) => t.id.equals('task-remoto'))).getSingle();
    expect(pulledTask.title, 'Tarea del otro dispositivo');
  });
}
