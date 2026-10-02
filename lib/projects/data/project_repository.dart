import 'package:drift/drift.dart';

import '../../activities/data/task_repository.dart';
import '../../activities/domain/task_enums.dart';
import '../../core/database/app_database.dart';
import '../../entities/data/entity_repository.dart';
import '../../entities/domain/entity_type.dart';
import '../../inbox/data/inbox_repository.dart';
import '../../relations/data/relation_repository.dart';
import '../../tags/data/tag_repository.dart';

/// Tag que distingue una Idea de una Observación — ambas son Notes que
/// pertenecen (`belongs_to`) al Project; el subtipo va como Tag, igual que
/// Wishlist (CLAUDE.md, regla 5).
const ideaTagName = 'idea';

/// Largo máximo del título de una Note creada desde la captura rápida de un
/// proyecto — si el texto es más largo, el título se recorta y el texto
/// completo va a `notes.content`.
const _maxTituloObservacion = 120;

/// `tasks.title` admite hasta 200 — una captura más larga se recorta y el
/// texto completo va a la descripción de la Task.
const _maxTituloTarea = 200;

/// Qué resultó ser una captura "sin clasificar" del proyecto.
enum ProjectCaptureKind { task, observation, requirement, idea }

class ProjectSummary {
  ProjectSummary({
    required this.entity,
    required this.project,
    required this.done,
    required this.total,
    required this.nextTask,
    required this.unclassified,
  });

  final EntityRow entity;
  final ProjectRow? project;
  final int done;
  final int total;

  /// La primera tarea abierta por orden de horizonte (Ahora → Siguiente →
  /// Después), y dentro de cada uno primero la que está En curso.
  /// `null` = el proyecto no tiene próxima acción.
  final TaskRow? nextTask;

  /// Capturas "sin clasificar" hechas dentro del proyecto.
  final int unclassified;
}

class ProjectNoteItem {
  ProjectNoteItem({required this.note, required this.isIdea});

  final EntityRow note;
  final bool isIdea;
}

/// Vista de "proyecto" armada sobre el modelo existente, sin tablas nuevas:
/// - Tareas = Tasks vinculadas por `activity_links` con link_type ≠ requisito.
/// - Requisitos = Tasks con link_type `requirement`.
/// - Observaciones/Ideas = Notes con relation `belongs_to` → Project.
class ProjectRepository {
  ProjectRepository(
    this._db,
    this._entities,
    this._tasks,
    this._relations,
    this._tags,
    this._inbox,
  );

  final AppDatabase _db;
  final EntityRepository _entities;
  final TaskRepository _tasks;
  final RelationRepository _relations;
  final TagRepository _tags;
  final InboxRepository _inbox;

  /// Re-emite cuando cambia cualquiera de [tablas] — las vistas de abajo
  /// combinan varias consultas, así que se recalculan enteras en vez de
  /// combinar streams a mano.
  Stream<T> _watchRecalculando<T>(
    Set<TableInfo> tablas,
    Future<T> Function() calcular,
  ) {
    return _db
        .customSelect('SELECT 1', readsFrom: tablas)
        .watch()
        .asyncMap((_) => calcular());
  }

  Stream<List<ProjectSummary>> watchSummaries() => _watchRecalculando({
    _db.entities,
    _db.projects,
    _db.tasks,
    _db.activityLinks,
    _db.inboxItems,
  }, _loadSummaries);

  Stream<ProjectSummary?> watchSummary(String projectId) => watchSummaries()
      .map((all) => all.where((s) => s.entity.id == projectId).firstOrNull);

  Future<List<ProjectSummary>> _loadSummaries() async {
    final rows =
        await (_db.select(_db.entities).join([
                leftOuterJoin(
                  _db.projects,
                  _db.projects.entityId.equalsExp(_db.entities.id),
                ),
              ])
              ..where(
                _db.entities.type.equals(EntityType.project.name) &
                    _db.entities.deletedAt.isNull(),
              )
              ..orderBy([OrderingTerm.desc(_db.entities.updatedAt)]))
            .get();

    final ids = rows.map((r) => r.readTable(_db.entities).id).toList();
    final tareasPorProyecto = <String, List<TaskRow>>{};
    if (ids.isNotEmpty) {
      final links =
          await (_db.select(_db.tasks).join([
                  innerJoin(
                    _db.activityLinks,
                    _db.activityLinks.activityId.equalsExp(_db.tasks.id) &
                        _db.activityLinks.activityType.equals('task'),
                  ),
                ])
                ..where(
                  _db.activityLinks.entityId.isIn(ids) &
                      _db.activityLinks.linkType
                          .equals(requirementLinkType)
                          .not() &
                      _db.activityLinks.deletedAt.isNull() &
                      _db.tasks.deletedAt.isNull(),
                )
                ..orderBy([OrderingTerm(expression: _db.tasks.createdAt)]))
              .get();
      for (final l in links) {
        tareasPorProyecto
            .putIfAbsent(l.readTable(_db.activityLinks).entityId, () => [])
            .add(l.readTable(_db.tasks));
      }
    }

    final sinClasificar = <String, int>{};
    if (ids.isNotEmpty) {
      final capturas =
          await (_db.select(_db.inboxItems)..where(
                (i) => i.entityId.isIn(ids) & i.deletedAt.isNull(),
              ))
              .get();
      for (final c in capturas) {
        sinClasificar.update(c.entityId!, (n) => n + 1, ifAbsent: () => 1);
      }
    }

    return rows.map((r) {
      final entity = r.readTable(_db.entities);
      final tareas = (tareasPorProyecto[entity.id] ?? const <TaskRow>[])
          .where((t) => t.status != TaskStatus.cancelled.name)
          .toList();
      final abiertas =
          tareas
              .where(
                (t) =>
                    t.status == TaskStatus.pending.name ||
                    t.status == TaskStatus.inProgress.name,
              )
              .toList()
            ..sort(compararPorPlan);
      return ProjectSummary(
        entity: entity,
        project: r.readTableOrNull(_db.projects),
        done: tareas.where((t) => t.status == TaskStatus.completed.name).length,
        total: tareas.length,
        nextTask: abiertas.firstOrNull,
        unclassified: sinClasificar[entity.id] ?? 0,
      );
    }).toList();
  }

  Stream<List<TaskRow>> watchTasks(String projectId) => _tasks
      .watchLinkedToEntity(projectId, excludeLinkType: requirementLinkType);

  Stream<List<TaskRow>> watchRequirements(String projectId) =>
      _tasks.watchLinkedToEntity(projectId, onlyLinkType: requirementLinkType);

  Stream<List<ProjectNoteItem>> watchObservations(String projectId) =>
      _watchRecalculando({
        _db.entities,
        _db.relations,
        _db.entityTags,
        _db.tags,
      }, () => _loadObservations(projectId));

  Future<List<ProjectNoteItem>> _loadObservations(String projectId) async {
    final belongsTo = await (_db.select(
      _db.relationTypes,
    )..where((t) => t.key.equals('belongs_to'))).getSingle();
    final rels =
        await (_db.select(_db.relations)..where(
              (r) =>
                  r.targetEntityId.equals(projectId) &
                  r.relationTypeId.equals(belongsTo.id) &
                  r.deletedAt.isNull(),
            ))
            .get();
    final noteIds = rels.map((r) => r.sourceEntityId).toSet();
    if (noteIds.isEmpty) return [];

    final notes =
        await (_db.select(_db.entities)
              ..where(
                (e) =>
                    e.id.isIn(noteIds) &
                    e.type.equals(EntityType.note.name) &
                    e.status.equals(EntityStatus.archived.name).not() &
                    e.deletedAt.isNull(),
              )
              ..orderBy([(e) => OrderingTerm.desc(e.createdAt)]))
            .get();

    final ideaRows =
        await (_db.select(_db.entityTags).join([
              innerJoin(_db.tags, _db.tags.id.equalsExp(_db.entityTags.tagId)),
            ])..where(
              _db.tags.name.equals(ideaTagName) &
                  _db.entityTags.entityId.isIn(noteIds) &
                  _db.entityTags.deletedAt.isNull(),
            ))
            .get();
    final ideas = ideaRows
        .map((r) => r.readTable(_db.entityTags).entityId)
        .toSet();

    return [
      for (final n in notes)
        ProjectNoteItem(note: n, isIdea: ideas.contains(n.id)),
    ];
  }

  Future<String> addTask(
    String projectId,
    String text, {
    TaskHorizon horizon = TaskHorizon.next,
  }) {
    final (titulo, resto) = _recortar(text, _maxTituloTarea);
    return _tasks.createLinkedTo(
      projectId,
      title: titulo,
      description: resto,
      horizon: horizon,
    );
  }

  Future<String> addRequirement(String projectId, String text) {
    final (titulo, resto) = _recortar(text, _maxTituloTarea);
    return _tasks.createLinkedTo(
      projectId,
      title: titulo,
      description: resto,
      linkType: requirementLinkType,
    );
  }

  /// (título, texto completo si hubo que recortar).
  (String, String?) _recortar(String text, int max) => text.length > max
      ? ('${text.substring(0, max - 1)}…', text)
      : (text, null);

  /// Anotar algo en el proyecto sin decidir todavía qué es.
  Future<void> capture(String projectId, String text) =>
      _inbox.capture(text, entityId: projectId);

  Stream<List<InboxItemRow>> watchUnclassified(String projectId) =>
      _inbox.watchInboxFor(projectId);

  /// Convierte la captura en lo que resultó ser y la saca del Inbox del
  /// proyecto, en una sola transacción.
  Future<void> classifyCapture(
    String projectId,
    String inboxItemId,
    ProjectCaptureKind kind,
  ) {
    return _db.transaction(() async {
      final item = await _inbox.getById(inboxItemId);
      switch (kind) {
        case ProjectCaptureKind.task:
          await addTask(projectId, item.content);
        case ProjectCaptureKind.requirement:
          await addRequirement(projectId, item.content);
        case ProjectCaptureKind.observation:
          await addObservation(projectId, item.content);
        case ProjectCaptureKind.idea:
          await addObservation(projectId, item.content, idea: true);
      }
      await _inbox.markProcessed(inboxItemId);
    });
  }

  Future<void> discardCapture(String inboxItemId) =>
      _inbox.markProcessed(inboxItemId);

  /// Crea la Note y su relación `belongs_to` → Project (y el tag `idea` si
  /// corresponde) en una sola transacción.
  Future<String> addObservation(
    String projectId,
    String text, {
    bool idea = false,
  }) {
    final recortado = text.length > _maxTituloObservacion;
    final titulo = recortado
        ? '${text.substring(0, _maxTituloObservacion - 1)}…'
        : text;
    return _db.transaction(() async {
      final noteId = await _entities.create(
        type: EntityType.note,
        title: titulo,
      );
      if (recortado) await _entities.updateNoteContent(noteId, text);
      await _relations.create(
        sourceEntityId: noteId,
        targetEntityId: projectId,
        relationTypeKey: 'belongs_to',
      );
      if (idea) await _tags.tagEntity(noteId, ideaTagName);
      return noteId;
    });
  }

  /// La observación pasa a ser una tarea del proyecto. La Note no se borra:
  /// se archiva (sale de la pestaña Observaciones pero sigue existiendo, con
  /// su relación, por si tenía contenido que vale la pena conservar).
  Future<String> convertToTask(String projectId, EntityRow note) {
    return _db.transaction(() async {
      final taskId = await _tasks.createLinkedTo(projectId, title: note.title);
      await _entities.changeStatus(note.id, EntityStatus.archived);
      return taskId;
    });
  }

  /// Hecha ↔ pendiente (o cumplido ↔ no cumplido, para un requisito).
  Future<void> toggleDone(TaskRow task) => _tasks.changeStatus(
    task.id,
    task.status == TaskStatus.completed.name
        ? TaskStatus.pending
        : TaskStatus.completed,
  );

  Future<void> moveTo(TaskRow task, TaskHorizon horizon) =>
      _tasks.changeHorizon(task.id, horizon);

  Future<void> resize(TaskRow task, TaskSize? size) =>
      _tasks.changeSize(task.id, size);

  Future<void> updateAppearance(
    String projectId, {
    required String? emoji,
    required String? color,
  }) {
    // upsert y no update: un Project que llegó por pull sin su fila de tipo
    // igual tiene que poder guardar su apariencia. Solo pisa estos campos.
    return _db
        .into(_db.projects)
        .insertOnConflictUpdate(
          ProjectsCompanion(
            entityId: Value(projectId),
            emoji: Value(emoji),
            color: Value(color),
            dirty: const Value(true),
          ),
        );
  }
}

/// Orden de "qué hago primero": horizonte (Ahora → Siguiente → Después),
/// luego En curso antes que pendiente, luego la más vieja.
int compararPorPlan(TaskRow a, TaskRow b) {
  final h = a.horizon.toTaskHorizon().index.compareTo(
    b.horizon.toTaskHorizon().index,
  );
  if (h != 0) return h;
  final enCursoA = a.status == TaskStatus.inProgress.name ? 0 : 1;
  final enCursoB = b.status == TaskStatus.inProgress.name ? 0 : 1;
  if (enCursoA != enCursoB) return enCursoA.compareTo(enCursoB);
  return a.createdAt.compareTo(b.createdAt);
}
