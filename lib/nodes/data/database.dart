import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DataClassName('NodeEntry')
class Nodes extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get tipo => text().nullable()(); // null = todavía en Inbox
  TextColumn get subtipo => text().nullable()(); // solo si tipo == 'wishlist'
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  TextColumn get cuerpo => text().nullable()();
  TextColumn get estado => text().withDefault(const Constant('activo'))();
  TextColumn get areaRelacionadaId => text().nullable()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaUltimoToque =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Nodes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Stream<List<NodeEntry>> watchInbox() =>
      (select(nodes)..where((n) => n.tipo.isNull())).watch();

  Stream<List<NodeEntry>> watchPorTipo(String tipo) =>
      (select(nodes)..where((n) => n.tipo.equals(tipo))).watch();

  Future<List<NodeEntry>> nodosActivos() =>
      (select(nodes)..where((n) => n.estado.equals('activo'))).get();

  Future<List<NodeEntry>> nodosEstancados(int diasSinTocar) {
    final limite = DateTime.now().subtract(Duration(days: diasSinTocar));
    return (select(nodes)..where(
          (n) =>
              n.estado.equals('activo') &
              n.fechaUltimoToque.isSmallerThanValue(limite),
        ))
        .get();
  }

  Future<List<NodeEntry>> wishlistSugerencias(int cantidad) {
    final query = select(nodes)
      ..where((n) => n.tipo.equals('wishlist') & n.estado.equals('someday'))
      ..orderBy([
        (_) => OrderingTerm(expression: const CustomExpression('RANDOM()')),
      ])
      ..limit(cantidad);
    return query.get();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(nodes, nodes.dirty);
        await m.addColumn(nodes, nodes.deletedAt);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'octodash.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
