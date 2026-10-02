import 'package:drift/drift.dart';

import '../../activities/data/task_repository.dart';
import '../../activities/domain/task_enums.dart';
import '../../core/database/app_database.dart';
import '../../entities/data/entity_repository.dart';
import '../../entities/domain/entity_type.dart';
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

class ProjectSummary {
  ProjectSummary({
    required this.entity,
    required this.project,
    required this.done,
    required this.total,
    required this.nextTask,
  });

  final EntityRow entity;
  final ProjectRow? project;
  final int done;
  final int total;

  /// La tarea "En curso" más vieja; si no hay, la pendiente más vieja.
  /// `null` = el proyecto no tiene próxima acción.
  final TaskRow? nextTask;
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
  );

  final AppDatabase _db;
  final EntityRepository _entities;
  final TaskRepository _tasks;
  final RelationRepository _relations;
  final TagRepository _tags;

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

    return rows.map((r) {
      final entity = r.readTable(_db.entities);
      final tareas = (tareasPorProyecto[entity.id] ?? const <TaskRow>[])
          .where((t) => t.status != TaskStatus.cancelled.name)
          .toList();
      final enCurso = tareas.where(
        (t) => t.status == TaskStatus.inProgress.name,
      );
      final pendientes = tareas.where(
        (t) => t.status == TaskStatus.pending.name,
      );
      return ProjectSummary(
        entity: entity,
        project: r.readTableOrNull(_db.projects),
        done: tareas.where((t) => t.status == TaskStatus.completed.name).length,
        total: tareas.length,
        nextTask: enCurso.firstOrNull ?? pendientes.firstOrNull,
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

  Future<String> addTask(String projectId, String title) =>
      _tasks.createLinkedTo(projectId, title: title);

  Future<String> addRequirement(String projectId, String title) => _tasks
      .createLinkedTo(projectId, title: title, linkType: requirementLinkType);

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

  /// En curso ↔ pendiente.
  Future<void> toggleInProgress(TaskRow task) => _tasks.changeStatus(
    task.id,
    task.status == TaskStatus.inProgress.name
        ? TaskStatus.pending
        : TaskStatus.inProgress,
  );

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
