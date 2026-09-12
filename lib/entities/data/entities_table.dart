import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName('EntityRow')
class Entities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get type => text()(); // EntityType.name — project/area/resource/note/person/hobby/goal
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
