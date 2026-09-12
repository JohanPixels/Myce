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

  /// Borra los activity_links de la Task y despues hace soft-delete de la
  /// Task, en la misma transacción. activity_links.activity_id no tiene FK
  /// real (deuda técnica documentada en docs/fuente_de_verdad.md §7.3) — si
  /// esto no se hace acá, quedan filas huérfanas sin que SQLite avise.
  Future<void> delete(String id) {
    return _db.transaction(() async {
      await (_db.delete(_db.activityLinks)..where(
            (l) => l.activityType.equals('task') & l.activityId.equals(id),
          ))
          .go();
      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          deletedAt: Value(DateTime.now()),
          dirty: const Value(true),
        ),
      );
    });
  }
}
