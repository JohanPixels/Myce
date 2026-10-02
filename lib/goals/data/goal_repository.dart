import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../entities/domain/entity_type.dart';
import '../../projects/data/project_repository.dart';

class GoalSummary {
  GoalSummary({required this.goal, required this.projects});

  final EntityRow goal;

  /// Proyectos conectados a la Meta por cualquier relación (en cualquier
  /// dirección) — típicamente "Project supports Goal".
  final List<ProjectSummary> projects;

  int get done => projects.fold(0, (n, p) => n + p.done);
  int get total => projects.fold(0, (n, p) => n + p.total);
}

/// Metas con los proyectos que las empujan y su avance agregado. Sin tablas
/// nuevas: sale de `relations` + los resúmenes de `ProjectRepository`.
class GoalRepository {
  GoalRepository(this._db, this._projects);

  final AppDatabase _db;
  final ProjectRepository _projects;

  Stream<List<GoalSummary>> watchGoals() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _db.entities,
          _db.relations,
          _db.projects,
          _db.tasks,
          _db.activityLinks,
        },
      )
      .watch()
      .asyncMap((_) => _load());

  Future<List<GoalSummary>> _load() async {
    final metas =
        await (_db.select(_db.entities)
              ..where(
                (e) =>
                    e.type.equals(EntityType.goal.name) & e.deletedAt.isNull(),
              )
              ..orderBy([(e) => OrderingTerm.desc(e.updatedAt)]))
            .get();
    if (metas.isEmpty) return [];

    final ids = metas.map((m) => m.id).toSet();
    final rels =
        await (_db.select(_db.relations)..where(
              (r) =>
                  (r.sourceEntityId.isIn(ids) | r.targetEntityId.isIn(ids)) &
                  r.deletedAt.isNull(),
            ))
            .get();
    final resumenes = {
      for (final s in await _projects.loadSummaries()) s.entity.id: s,
    };

    final proyectosDe = <String, Map<String, ProjectSummary>>{};
    for (final r in rels) {
      for (final (meta, otro) in [
        (r.sourceEntityId, r.targetEntityId),
        (r.targetEntityId, r.sourceEntityId),
      ]) {
        final proyecto = resumenes[otro];
        if (ids.contains(meta) && proyecto != null) {
          proyectosDe.putIfAbsent(meta, () => {})[otro] = proyecto;
        }
      }
    }

    return [
      for (final m in metas)
        GoalSummary(
          goal: m,
          projects: (proyectosDe[m.id]?.values.toList() ?? [])
            ..sort((a, b) => a.entity.title.compareTo(b.entity.title)),
        ),
    ];
  }
}
