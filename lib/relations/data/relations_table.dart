import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../entities/data/entities_table.dart';

@DataClassName('RelationTypeRow')
class RelationTypes extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get key => text().unique()(); // ej. inspired_by
  TextColumn get label => text()(); // ej. "Inspired by"
  TextColumn get inverseLabel => text()(); // ej. "Inspires"
  BoolColumn get directed => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RelationRow')
class Relations extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @ReferenceName('relationsAsSource')
  TextColumn get sourceEntityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('relationsAsTarget')
  TextColumn get targetEntityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get relationTypeId =>
      text().references(RelationTypes, #id)();
  TextColumn get note => text().nullable()();
  TextColumn get metadata => text().nullable()(); // JSON — solo para datos sin query/índice propio
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Vocabulario inicial — docs/fuente_de_verdad.md §6.1.
/// Es tabla de datos, no enum: se puede ampliar sin migración insertando filas.
const initialRelationTypes = <(String key, String label, String inverseLabel, bool directed)>[
  ('belongs_to', 'Belongs to', 'Contains', true),
  ('uses', 'Uses', 'Used by', true),
  ('related_to', 'Related to', 'Related to', false),
  ('derived_from', 'Derived from', 'Source of', true),
  ('inspired_by', 'Inspired by', 'Inspires', true),
  ('relevant_to', 'Relevant to', 'Has relevant', true),
  ('supports', 'Supports', 'Supported by', true),
  ('recommends', 'Recommends', 'Recommended by', true),
  ('contributes_to', 'Contributes to', 'Receives contribution from', true),
];
