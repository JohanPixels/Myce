import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/database/app_database.dart';

// NOTA: sigue siendo push-only (ni este proyecto ni OctoDash tuvieron nunca
// pull/download) — patrón outbox: dirty flag, UUIDs de cliente,
// last-write-wins, retry en el próximo ciclo si falla el push.

/// Puente al backend remoto — abstraído para poder testear el armado de
/// payloads y la lógica de retry sin `Supabase.instance` real (no hay
/// librería de mocking en el proyecto).
abstract class SyncClient {
  Future<void> upsert(String table, Map<String, dynamic> row);
  Future<List<Map<String, dynamic>>> selectAll(String table);
}

class SupabaseSyncClient implements SyncClient {
  @override
  Future<void> upsert(String table, Map<String, dynamic> row) async {
    await Supabase.instance.client.from(table).upsert(row);
  }

  @override
  Future<List<Map<String, dynamic>>> selectAll(String table) async {
    return Supabase.instance.client.from(table).select();
  }
}

/// Punto de entrada del sync. Empuja, en orden, todo lo que esté `dirty`:
/// entities y tags primero (referenciadas por FK real del lado Supabase por
/// relations/activity_links/entity_tags), después relations/tasks, y por
/// último activity_links/entity_tags. Si una fila con dependencia falla
/// (ej. una relation cuya entity todavía no llegó), queda dirty y se
/// reintenta sola en el próximo ciclo — no hace falta atomicidad entre tablas.
Future<void> pushDirtyData(
  AppDatabase db, {
  String? userId,
  SyncClient? client,
}) async {
  final effectiveUserId =
      userId ?? Supabase.instance.client.auth.currentUser?.id;
  if (effectiveUserId == null) return; // sin sesión, no hay a dónde subir
  final syncClient = client ?? SupabaseSyncClient();

  await _pushDirtyEntities(db, syncClient, effectiveUserId);
  await _pushDirtyProjects(db, syncClient, effectiveUserId);
  await _pushDirtyNotes(db, syncClient, effectiveUserId);
  await _pushDirtyAreas(db, syncClient, effectiveUserId);
  await _pushDirtyResources(db, syncClient, effectiveUserId);
  await _pushDirtyPeople(db, syncClient, effectiveUserId);
  await _pushDirtyHobbies(db, syncClient, effectiveUserId);
  await _pushDirtyGoals(db, syncClient, effectiveUserId);
  await _pushDirtyTags(db, syncClient, effectiveUserId);
  await _pushDirtyRelations(db, syncClient, effectiveUserId);
  await _pushDirtyTasks(db, syncClient, effectiveUserId);
  await _pushDirtyActivityLinks(db, syncClient, effectiveUserId);
  await _pushDirtyEntityTags(db, syncClient, effectiveUserId);
}

/// Loop compartido: query y mapeo son responsabilidad de cada `_pushDirtyX`,
/// esto solo evita repetir 6 veces el mismo try/catch + marcar-limpio.
Future<void> _pushDirty<D>({
  required List<D> rows,
  required SyncClient client,
  required String remoteTable,
  required Map<String, dynamic>? Function(D row) toRemoteRow,
  required Future<void> Function(D row) markClean,
}) async {
  for (final row in rows) {
    final payload = toRemoteRow(row);
    if (payload == null) continue; // no se pudo armar el payload — se reintenta después
    try {
      await client.upsert(remoteTable, payload);
      await markClean(row);
    } catch (_) {
      // no tocamos dirty: se reintenta solo en el próximo ciclo de sync
    }
  }
}

Future<void> _pushDirtyEntities(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.entities,
  )..where((e) => e.dirty.equals(true))).get();
  await _pushDirty<EntityRow>(
    rows: rows,
    client: client,
    remoteTable: 'entities',
    toRemoteRow: (e) => {
      'id': e.id,
      'user_id': userId,
      'type': e.type,
      'title': e.title,
      'description': e.description,
      'status': e.status,
      'created_at': e.createdAt.toIso8601String(),
      'updated_at': e.updatedAt.toIso8601String(),
      'deleted_at': e.deletedAt?.toIso8601String(),
    },
    markClean: (e) => (db.update(db.entities)..where((r) => r.id.equals(e.id)))
        .write(const EntitiesCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyProjects(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.projects,
  )..where((p) => p.dirty.equals(true))).get();
  await _pushDirty<ProjectRow>(
    rows: rows,
    client: client,
    remoteTable: 'projects',
    toRemoteRow: (p) => {
      'entity_id': p.entityId,
      'user_id': userId,
      'started_at': p.startedAt?.toIso8601String(),
      'completed_at': p.completedAt?.toIso8601String(),
    },
    markClean: (p) =>
        (db.update(db.projects)..where((r) => r.entityId.equals(p.entityId)))
            .write(const ProjectsCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyNotes(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.notes,
  )..where((n) => n.dirty.equals(true))).get();
  await _pushDirty<NoteRow>(
    rows: rows,
    client: client,
    remoteTable: 'notes',
    toRemoteRow: (n) => {
      'entity_id': n.entityId,
      'user_id': userId,
      'content': n.content,
    },
    markClean: (n) =>
        (db.update(db.notes)..where((r) => r.entityId.equals(n.entityId)))
            .write(const NotesCompanion(dirty: Value(false))),
  );
}

// Areas/Resources/People/Hobbies/Goals no tienen campos propios hoy (ver
// entity_type_tables.dart) — su fila solo importa por su existencia (calzar
// 1:1 con la Entity), así que el payload remoto es solo entity_id/user_id.

Future<void> _pushDirtyAreas(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.areas,
  )..where((a) => a.dirty.equals(true))).get();
  await _pushDirty<AreaRow>(
    rows: rows,
    client: client,
    remoteTable: 'areas',
    toRemoteRow: (a) => {'entity_id': a.entityId, 'user_id': userId},
    markClean: (a) =>
        (db.update(db.areas)..where((r) => r.entityId.equals(a.entityId)))
            .write(const AreasCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyResources(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.resources,
  )..where((r) => r.dirty.equals(true))).get();
  await _pushDirty<ResourceRow>(
    rows: rows,
    client: client,
    remoteTable: 'resources',
    toRemoteRow: (r) => {'entity_id': r.entityId, 'user_id': userId},
    markClean: (r) => (db.update(
      db.resources,
    )..where((row) => row.entityId.equals(r.entityId))).write(
      const ResourcesCompanion(dirty: Value(false)),
    ),
  );
}

Future<void> _pushDirtyPeople(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.people,
  )..where((p) => p.dirty.equals(true))).get();
  await _pushDirty<PersonRow>(
    rows: rows,
    client: client,
    remoteTable: 'people',
    toRemoteRow: (p) => {'entity_id': p.entityId, 'user_id': userId},
    markClean: (p) =>
        (db.update(db.people)..where((r) => r.entityId.equals(p.entityId)))
            .write(const PeopleCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyHobbies(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.hobbies,
  )..where((h) => h.dirty.equals(true))).get();
  await _pushDirty<HobbyRow>(
    rows: rows,
    client: client,
    remoteTable: 'hobbies',
    toRemoteRow: (h) => {'entity_id': h.entityId, 'user_id': userId},
    markClean: (h) =>
        (db.update(db.hobbies)..where((r) => r.entityId.equals(h.entityId)))
            .write(const HobbiesCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyGoals(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.goals,
  )..where((g) => g.dirty.equals(true))).get();
  await _pushDirty<GoalRow>(
    rows: rows,
    client: client,
    remoteTable: 'goals',
    toRemoteRow: (g) => {'entity_id': g.entityId, 'user_id': userId},
    markClean: (g) =>
        (db.update(db.goals)..where((r) => r.entityId.equals(g.entityId)))
            .write(const GoalsCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyTags(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.tags,
  )..where((t) => t.dirty.equals(true))).get();
  await _pushDirty<TagRow>(
    rows: rows,
    client: client,
    remoteTable: 'tags',
    toRemoteRow: (t) => {'id': t.id, 'user_id': userId, 'name': t.name},
    markClean: (t) => (db.update(db.tags)..where((r) => r.id.equals(t.id)))
        .write(const TagsCompanion(dirty: Value(false))),
  );
}

/// relation_types se siembra por separado en local (onCreate) y en Supabase
/// (gen_random_uuid() propio) — mismos `key`, ids distintos. Antes de
/// pushear relations hay que resolver relationTypeId local -> key -> id
/// remoto. Son 9 filas fijas y compartidas: se resuelve en memoria en cada
/// corrida, sin cache persistente (costo irrelevante, evita bugs de
/// invalidación de un vocabulario que casi nunca cambia).
Future<void> _pushDirtyRelations(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.relations,
  )..where((r) => r.dirty.equals(true))).get();
  if (rows.isEmpty) return;

  final localTypes = await db.select(db.relationTypes).get();
  final keyByLocalId = {for (final t in localTypes) t.id: t.key};
  final remoteTypes = await client.selectAll('relation_types');
  final remoteIdByKey = {
    for (final t in remoteTypes) t['key'] as String: t['id'] as String,
  };

  await _pushDirty<RelationRow>(
    rows: rows,
    client: client,
    remoteTable: 'relations',
    toRemoteRow: (r) {
      final key = keyByLocalId[r.relationTypeId];
      final remoteTypeId = key == null ? null : remoteIdByKey[key];
      if (remoteTypeId == null) return null; // vocabulario no resuelto — reintentar después
      return {
        'id': r.id,
        'user_id': userId,
        'source_entity_id': r.sourceEntityId,
        'target_entity_id': r.targetEntityId,
        'relation_type_id': remoteTypeId,
        'note': r.note,
        'metadata': r.metadata == null ? null : jsonDecode(r.metadata!),
        'created_at': r.createdAt.toIso8601String(),
        'deleted_at': r.deletedAt?.toIso8601String(),
      };
    },
    markClean: (r) =>
        (db.update(db.relations)..where((row) => row.id.equals(r.id))).write(
          const RelationsCompanion(dirty: Value(false)),
        ),
  );
}

Future<void> _pushDirtyTasks(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.tasks,
  )..where((t) => t.dirty.equals(true))).get();
  await _pushDirty<TaskRow>(
    rows: rows,
    client: client,
    remoteTable: 'tasks',
    toRemoteRow: (t) => {
      'id': t.id,
      'user_id': userId,
      'title': t.title,
      'description': t.description,
      'status': t.status,
      'priority': t.priority,
      'due_at': t.dueAt?.toIso8601String(),
      'completed_at': t.completedAt?.toIso8601String(),
      'created_at': t.createdAt.toIso8601String(),
      'updated_at': t.updatedAt.toIso8601String(),
      'deleted_at': t.deletedAt?.toIso8601String(),
    },
    markClean: (t) => (db.update(db.tasks)..where((r) => r.id.equals(t.id)))
        .write(const TasksCompanion(dirty: Value(false))),
  );
}

Future<void> _pushDirtyActivityLinks(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.activityLinks,
  )..where((l) => l.dirty.equals(true))).get();
  await _pushDirty<ActivityLinkRow>(
    rows: rows,
    client: client,
    remoteTable: 'activity_links',
    toRemoteRow: (l) => {
      'id': l.id,
      'user_id': userId,
      'activity_type': l.activityType,
      'activity_id': l.activityId,
      'entity_id': l.entityId,
      'link_type': l.linkType,
      'created_at': l.createdAt.toIso8601String(),
      'deleted_at': l.deletedAt?.toIso8601String(),
    },
    markClean: (l) =>
        (db.update(db.activityLinks)..where((r) => r.id.equals(l.id))).write(
          const ActivityLinksCompanion(dirty: Value(false)),
        ),
  );
}

Future<void> _pushDirtyEntityTags(
  AppDatabase db,
  SyncClient client,
  String userId,
) async {
  final rows = await (db.select(
    db.entityTags,
  )..where((et) => et.dirty.equals(true))).get();
  await _pushDirty<EntityTagRow>(
    rows: rows,
    client: client,
    remoteTable: 'entity_tags',
    toRemoteRow: (et) => {
      'entity_id': et.entityId,
      'tag_id': et.tagId,
      'user_id': userId,
      'created_at': et.createdAt.toIso8601String(),
      'deleted_at': et.deletedAt?.toIso8601String(),
    },
    markClean: (et) =>
        (db.update(db.entityTags)..where(
              (r) => r.entityId.equals(et.entityId) & r.tagId.equals(et.tagId),
            ))
            .write(const EntityTagsCompanion(dirty: Value(false))),
  );
}
