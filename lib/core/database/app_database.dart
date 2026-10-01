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
  int get schemaVersion => 4;

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
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // dirty/deletedAt en activity_links/tags/entity_tags — necesarios
        // para extender el sync (hoy solo empujaba entities) más allá de
        // entities/relations/tasks, que ya nacieron con estas columnas.
        await m.addColumn(activityLinks, activityLinks.dirty);
        await m.addColumn(activityLinks, activityLinks.deletedAt);
        await m.addColumn(tags, tags.dirty);
        await m.addColumn(entityTags, entityTags.dirty);
        await m.addColumn(entityTags, entityTags.deletedAt);
      }
      if (from < 3) {
        // dirty en las 7 tablas de tipo — se suman al sync (antes solo
        // existían localmente, sin llegar nunca a Supabase).
        await m.addColumn(projects, projects.dirty);
        await m.addColumn(notes, notes.dirty);
        await m.addColumn(areas, areas.dirty);
        await m.addColumn(resources, resources.dirty);
        await m.addColumn(people, people.dirty);
        await m.addColumn(hobbies, hobbies.dirty);
        await m.addColumn(goals, goals.dirty);
      }
      if (from < 4) {
        // La UI escribía el cuerpo de una Nota en entities.description (el
        // campo genérico) en vez de notes.content (su campo propio, ver
        // docs/fuente_de_verdad.md §4.3) — se corrige la UI en el mismo
        // cambio, y acá se rescata lo ya escrito antes de la corrección
        // para las Notes existentes (no se pisa nada, solo se copia).
        await m.database.customStatement('''
          UPDATE notes
          SET content = (SELECT description FROM entities WHERE entities.id = notes.entity_id),
              dirty = 1
          WHERE content IS NULL
            AND entity_id IN (
              SELECT id FROM entities WHERE type = 'note' AND description IS NOT NULL
            );
        ''');
      }
    },
  );

  Stream<List<InboxItemRow>> watchInboxItems() =>
      (select(inboxItems)..where((i) => i.deletedAt.isNull())).watch();

  Stream<List<EntityRow>> watchEntitiesByType(String type) =>
      (select(entities)
            ..where((e) => e.type.equals(type) & e.deletedAt.isNull()))
          .watch();

  Stream<EntityRow?> watchEntityById(String id) => (select(
    entities,
  )..where((e) => e.id.equals(id) & e.deletedAt.isNull())).watchSingleOrNull();

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
