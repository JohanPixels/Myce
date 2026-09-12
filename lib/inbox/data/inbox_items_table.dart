import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Captura cruda, previa a clasificar. Un InboxItem NO es una Entity —
/// docs/fuente_de_verdad.md §4.1 define `type` como campo común obligatorio
/// de Entity, así que lo que todavía no tiene tipo no es Entity todavía.
/// Procesar un InboxItem crea la(s) Entity/Activity correspondiente(s) y
/// borra esta fila (§9: CAPTURE → PROCESS → ORGANIZE).
@DataClassName('InboxItemRow')
class InboxItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get content => text().withLength(min: 1)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
