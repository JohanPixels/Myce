import 'package:drift/drift.dart';

import 'entities_table.dart';

@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  // Apariencia en la lista/detalle de proyectos: un emoji y una clave de
  // color de `projectPalette` (core/theme/project_palette.dart), no un hex —
  // así el color se adapta al tema claro/oscuro. Ambos opcionales.
  TextColumn get emoji => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('NoteRow')
class Notes extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text().nullable()(); // Markdown
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

// Sin campos propios hoy — existen para calzar 1:1 con la fuente de verdad
// (docs/fuente_de_verdad.md §4.3) y para que sumar un campo mañana no
// requiera crear la tabla desde cero.
@DataClassName('AreaRow')
class Areas extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('ResourceRow')
class Resources extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('PersonRow')
class People extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('HobbyRow')
class Hobbies extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('GoalRow')
class Goals extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {entityId};
}
