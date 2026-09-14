import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../entities/data/entities_table.dart';
import '../../entities/data/entity_type_tables.dart';
import '../../relations/data/relations_table.dart';
import '../../activities/data/tasks_table.dart';
import '../../inbox/data/inbox_items_table.dart';
import '../../tags/data/tags_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Entities,
    Projects,
    Notes,
    Areas,
    Resources,
    People,
    Hobbies,
    Goals,
    RelationTypes,
    Relations,
    Tasks,
    ActivityLinks,
    InboxItems,
    Tags,
    EntityTags,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await batch((b) {
        b.insertAll(
          relationTypes,
          [
            for (final (key, label, inverseLabel, directed)
                in initialRelationTypes)
              RelationTypesCompanion.insert(
                key: key,
                label: label,
                inverseLabel: inverseLabel,
                directed: Value(directed),
              ),
          ],
        );
      });
    },
  );

  Stream<List<InboxItemRow>> watchInboxItems() =>
      (select(inboxItems)..where((i) => i.deletedAt.isNull())).watch();

  Stream<List<EntityRow>> watchEntitiesByType(String type) =>
      (select(entities)
            ..where((e) => e.type.equals(type) & e.deletedAt.isNull()))
          .watch();

  Stream<EntityRow?> watchEntityById(String id) =>
      (select(entities)..where((e) => e.id.equals(id))).watchSingleOrNull();

  Future<List<EntityRow>> searchEntities(String query) {
    final pattern = '%$query%';
    return (select(
      entities,
    )..where((e) => e.title.like(pattern) & e.deletedAt.isNull())).get();
  }

  Future<List<EntityRow>> entitiesActivos() => (select(
    entities,
  )..where((e) => e.status.equals('active') & e.deletedAt.isNull())).get();

  Future<List<EntityRow>> entitiesEstancados(int diasSinTocar) {
    final limite = DateTime.now().subtract(Duration(days: diasSinTocar));
    return (select(entities)..where(
          (e) =>
              e.status.equals('active') &
              e.updatedAt.isSmallerThanValue(limite) &
              e.deletedAt.isNull(),
        ))
        .get();
  }

  Future<List<EntityRow>> wishlistSugerencias(int cantidad) {
    final query = select(entities)
      ..where(
        (e) =>
            e.type.equals('resource') &
            e.status.equals('someday') &
            e.deletedAt.isNull(),
      )
      ..orderBy([
        (_) => OrderingTerm(expression: const CustomExpression('RANDOM()')),
      ])
      ..limit(cantidad);
    return query.get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'myce.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
