import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../entities/data/entity_repository.dart';
import '../../entities/domain/entity_type.dart';

/// Quién menciona a una Entity con `[[Título]]` en su texto.
class BacklinkHit {
  BacklinkHit({
    required this.id,
    required this.title,
    required this.isTask,
    this.type,
  });

  final String id;
  final String title;
  final bool isTask;

  /// Tipo de la Entity que menciona (null si es una Task).
  final EntityType? type;
}

/// Enlaces estilo wiki (`[[Otra nota]]`, docs/fuente_de_verdad.md §4.3).
/// Se resuelven por título en el momento — no hay tabla de enlaces: el
/// texto es la fuente de verdad. Consecuencia aceptada: renombrar una
/// Entity no actualiza los `[[...]]` que la mencionaban.
class LinkRepository {
  LinkRepository(this._db, this._entities);

  final AppDatabase _db;
  final EntityRepository _entities;

  /// Títulos que contienen [query], para autocompletar al escribir `[[`.
  Future<List<String>> suggestTitles(String query) async {
    final filas =
        await (_db.select(_db.entities)
              ..where((e) => e.deletedAt.isNull() & e.title.like('%$query%'))
              ..orderBy([(e) => OrderingTerm.desc(e.updatedAt)])
              ..limit(8))
            .get();
    return filas.map((e) => e.title).toSet().toList();
  }

  /// La Entity cuyo título es exactamente [titulo] (sin distinguir
  /// mayúsculas). Si hay varias, gana la Nota, y entre iguales la más
  /// reciente.
  Future<EntityRow?> findByTitle(String titulo) async {
    final filas =
        await (_db.select(_db.entities)
              ..where(
                (e) =>
                    e.deletedAt.isNull() &
                    e.title.lower().equals(titulo.trim().toLowerCase()),
              )
              ..orderBy([(e) => OrderingTerm.desc(e.updatedAt)]))
            .get();
    if (filas.isEmpty) return null;
    return filas.firstWhere(
      (e) => e.type == EntityType.note.name,
      orElse: () => filas.first,
    );
  }

  /// Crea una Nota con ese título (para un `[[enlace]]` que todavía no
  /// apunta a nada) y devuelve su id.
  Future<String> createNote(String titulo) =>
      _entities.create(type: EntityType.note, title: titulo.trim());

  /// Entities (por contenido de Nota o descripción) y Tasks (por
  /// descripción) que contienen `[[<título de entity>]]`.
  Stream<List<BacklinkHit>> watchBacklinks(EntityRow entity) => _db
      .customSelect('SELECT 1', readsFrom: {_db.entities, _db.notes, _db.tasks})
      .watch()
      .asyncMap((_) => _loadBacklinks(entity));

  Future<List<BacklinkHit>> _loadBacklinks(EntityRow entity) async {
    // LIKE de SQLite no distingue mayúsculas (ASCII) y `[`/`]` no son
    // comodines, así que el patrón literal alcanza.
    final patron = '%[[${entity.title}]]%';

    final porContenido =
        await (_db.select(_db.entities).join([
              leftOuterJoin(
                _db.notes,
                _db.notes.entityId.equalsExp(_db.entities.id),
              ),
            ])..where(
              _db.entities.deletedAt.isNull() &
                  _db.entities.id.equals(entity.id).not() &
                  (_db.entities.description.like(patron) |
                      _db.notes.content.like(patron)),
            ))
            .get();
    final tareas = await (_db.select(
      _db.tasks,
    )..where((t) => t.deletedAt.isNull() & t.description.like(patron))).get();

    return [
      for (final r in porContenido)
        BacklinkHit(
          id: r.readTable(_db.entities).id,
          title: r.readTable(_db.entities).title,
          isTask: false,
          type: r.readTable(_db.entities).type.toEntityType(),
        ),
      for (final t in tareas)
        BacklinkHit(id: t.id, title: t.title, isTask: true),
    ];
  }
}
