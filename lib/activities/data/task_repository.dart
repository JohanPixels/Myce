import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../domain/task_enums.dart';

class TaskRepository {
  TaskRepository(this._db);
  final AppDatabase _db;

  Future<String> create({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.none,
    DateTime? dueAt,
  }) async {
    final id = const Uuid().v4();
    await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            id: Value(id),
            title: title,
            description: Value(description),
            priority: Value(priority.name),
            dueAt: Value(dueAt),
          ),
        );
    return id;
  }

  /// Crea la Task y la vincula a una Entity en la misma transacción — puerta
  /// de creación adicional a la del Inbox, para cuando ya se sabe a qué
  /// Project/Area/Nota pertenece (ej. "agregar tarea" desde su detalle).
  Future<String> createLinkedTo(
    String entityId, {
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.none,
    DateTime? dueAt,
    String linkType = 'part_of',
  }) {
    return _db.transaction(() async {
      final taskId = await create(
        title: title,
        description: description,
        priority: priority,
        dueAt: dueAt,
      );
      await linkToEntity(taskId, entityId, linkType);
      return taskId;
    });
  }

  Future<void> linkToEntity(String taskId, String entityId, String linkType) {
    return _db
        .into(_db.activityLinks)
        .insert(
          ActivityLinksCompanion.insert(
            activityType: 'task',
            activityId: taskId,
            entityId: entityId,
            linkType: linkType,
          ),
        );
  }

  /// La Entity vinculada actualmente a la Task, si tiene una — modelo de "un
  /// link activo a la vez" resuelto a nivel UI/repositorio (mostrar
  /// vincular/desvincular según haya o no resultado), sin unique constraint.
  Stream<EntityRow?> watchLinkedEntity(String taskId) {
    final query =
        _db.select(_db.activityLinks).join([
            innerJoin(
              _db.entities,
              _db.entities.id.equalsExp(_db.activityLinks.entityId),
            ),
          ])
          ..where(
            _db.activityLinks.activityType.equals('task') &
                _db.activityLinks.activityId.equals(taskId) &
                _db.activityLinks.deletedAt.isNull() &
                _db.entities.deletedAt.isNull(),
          );
    return query.watch().map(
      (rows) => rows.isEmpty ? null : rows.first.readTable(_db.entities),
    );
  }

  Future<void> unlinkFromEntity(String taskId) {
    return (_db.update(_db.activityLinks)..where(
          (l) =>
              l.activityType.equals('task') &
              l.activityId.equals(taskId) &
              l.deletedAt.isNull(),
        ))
        .write(
          ActivityLinksCompanion(
            deletedAt: Value(DateTime.now()),
            dirty: const Value(true),
          ),
        );
  }

  Stream<TaskRow?> watchById(String id) =>
      (_db.select(_db.tasks)
            ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .watchSingleOrNull();

  Stream<List<TaskRow>> watchAll() =>
      (_db.select(_db.tasks)..where((t) => t.deletedAt.isNull())).watch();

  /// dueAt <= fin del día de hoy, status activo (no completed/cancelled), no borrada.
  Stream<List<TaskRow>> watchDueTodayOrOverdue() {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return (_db.select(_db.tasks)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.dueAt.isNotNull() &
                t.dueAt.isSmallerOrEqualValue(endOfToday) &
                t.status.isNotIn(['completed', 'cancelled']),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.dueAt)]))
        .watch();
  }

  Future<void> changePriority(String id, TaskPriority priority) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        priority: Value(priority.name),
        updatedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> changeDueAt(String id, DateTime? dueAt) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        dueAt: Value(dueAt),
        updatedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> updateDescription(String id, String? description) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        description: Value(description),
        updatedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  Stream<List<TaskRow>> watchLinkedToEntity(String entityId) {
    final query =
        _db.select(_db.tasks).join([
            innerJoin(
              _db.activityLinks,
              _db.activityLinks.activityId.equalsExp(_db.tasks.id) &
                  _db.activityLinks.activityType.equals('task'),
            ),
          ])
          ..where(
            _db.activityLinks.entityId.equals(entityId) &
                _db.activityLinks.deletedAt.isNull() &
                _db.tasks.deletedAt.isNull(),
          );
    return query.watch().map(
      (rows) => rows.map((r) => r.readTable(_db.tasks)).toList(),
    );
  }

  Future<void> changeStatus(String id, TaskStatus status) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        status: Value(status.name),
        completedAt: status == TaskStatus.completed
            ? Value(DateTime.now())
            : const Value(null),
        updatedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  /// Soft-delete de los activity_links de la Task y de la Task, en la misma
  /// transacción. activity_links.activity_id no tiene FK real (deuda técnica
  /// documentada en docs/fuente_de_verdad.md §7.3) — si esto no se hace acá,
  /// quedan filas huérfanas sin que SQLite avise. Es soft-delete (no hard
  /// delete) para que el sync pueda propagar el borrado a Supabase: un hard
  /// delete local no deja rastro que decirle al remoto.
  Future<void> delete(String id) {
    return _db.transaction(() async {
      await (_db.update(_db.activityLinks)..where(
            (l) => l.activityType.equals('task') & l.activityId.equals(id),
          ))
          .write(
            ActivityLinksCompanion(
              deletedAt: Value(DateTime.now()),
              dirty: const Value(true),
            ),
          );
      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          deletedAt: Value(DateTime.now()),
          dirty: const Value(true),
        ),
      );
    });
  }
}
