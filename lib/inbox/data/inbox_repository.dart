import 'package:drift/drift.dart';

import '../../activities/data/task_repository.dart';
import '../../activities/domain/task_enums.dart';
import '../../core/database/app_database.dart';
import '../../entities/data/entity_repository.dart';
import '../../entities/domain/entity_type.dart';
import '../../tags/data/tag_repository.dart';

class InboxRepository {
  InboxRepository(this._db, this._entities, this._tags, this._tasks);
  final AppDatabase _db;
  final EntityRepository _entities;
  final TagRepository _tags;
  final TaskRepository _tasks;

  /// [entityId] = capturado dentro de esa Entity (ej. un Project): no va al
  /// Inbox general, se clasifica desde ahí.
  Future<void> capture(String content, {String? entityId}) {
    return _db
        .into(_db.inboxItems)
        .insert(
          InboxItemsCompanion.insert(
            content: content,
            entityId: Value(entityId),
          ),
        );
  }

  Stream<List<InboxItemRow>> watchInbox() => _db.watchInboxItems();

  Stream<List<InboxItemRow>> watchInboxFor(String entityId) =>
      (_db.select(_db.inboxItems)
            ..where((i) => i.deletedAt.isNull() & i.entityId.equals(entityId))
            ..orderBy([(i) => OrderingTerm(expression: i.createdAt)]))
          .watch();

  Future<InboxItemRow> getById(String id) => (_db.select(
    _db.inboxItems,
  )..where((i) => i.id.equals(id))).getSingle();

  /// Saca el item del Inbox (soft-delete, para que el sync lo propague):
  /// ya se procesó, o se descartó.
  Future<void> markProcessed(String inboxItemId) {
    return (_db.update(
      _db.inboxItems,
    )..where((i) => i.id.equals(inboxItemId))).write(
      InboxItemsCompanion(
        deletedAt: Value(DateTime.now()),
        dirty: const Value(true),
      ),
    );
  }

  /// Procesa un InboxItem: crea la Entity correspondiente (+ tags opcionales,
  /// ej. subtipo de wishlist) y borra el item del Inbox. Todo en una
  /// transacción — docs/fuente_de_verdad.md §9 (CAPTURE → PROCESS → ORGANIZE).
  Future<String> classify(
    String inboxItemId, {
    required EntityType type,
    EntityStatus status = EntityStatus.active,
    List<String> tags = const [],
  }) async {
    final item = await (_db.select(
      _db.inboxItems,
    )..where((i) => i.id.equals(inboxItemId))).getSingle();

    return _db.transaction(() async {
      final entityId = await _entities.create(
        type: type,
        title: item.content,
        status: status,
      );
      for (final tag in tags) {
        await _tags.tagEntity(entityId, tag);
      }
      await markProcessed(inboxItemId);
      return entityId;
    });
  }

  /// Igual que `classify()` pero produce una Task en vez de una Entity —
  /// no reusa `classify()` porque `type` ahí es estrictamente `EntityType`
  /// y una Task no es Entity (no crea fila en `entities`).
  Future<String> classifyAsTask(
    String inboxItemId, {
    TaskPriority priority = TaskPriority.none,
    DateTime? dueAt,
  }) async {
    final item = await (_db.select(
      _db.inboxItems,
    )..where((i) => i.id.equals(inboxItemId))).getSingle();

    return _db.transaction(() async {
      final taskId = await _tasks.create(
        title: item.content,
        priority: priority,
        dueAt: dueAt,
      );
      await markProcessed(inboxItemId);
      return taskId;
    });
  }
}
