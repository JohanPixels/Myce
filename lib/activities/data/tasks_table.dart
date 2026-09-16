import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../entities/data/entities_table.dart';

@DataClassName('TaskRow')
class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get priority => text().withDefault(const Constant('none'))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cómo las Activities (Task/Habit) tocan el grafo sin ser Entities.
/// `activityId` NO tiene foreign key real: SQL no soporta una FK condicional
/// ("apunta a tasks o habits según activityType"). Deuda técnica aceptada
/// (docs/fuente_de_verdad.md §7.3) — cualquier repositorio que borre una Task
/// (o Habit en v2) DEBE borrar explícitamente sus filas de activity_links en
/// la misma transacción; no hay cascada automática posible acá.
@DataClassName('ActivityLinkRow')
class ActivityLinks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get activityType => text()(); // 'task' | 'habit'
  TextColumn get activityId => text()(); // sin FK real — ver nota arriba
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get linkType => text()(); // vocabulario separado de relation_types
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
