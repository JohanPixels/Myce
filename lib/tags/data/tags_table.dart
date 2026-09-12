import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../entities/data/entities_table.dart';

/// Tags = clasificación, no conocimiento (docs/fuente_de_verdad.md §8).
/// Ej: #flutter, #comprar, #libro. El subtipo de Wishlist (juego/música/
/// libro/película) vive acá, no como columna en Resources.
@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EntityTagRow')
class EntityTags extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {entityId, tagId};
}
