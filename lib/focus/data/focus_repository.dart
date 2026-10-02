import 'package:drift/drift.dart';

import '../../activities/domain/task_enums.dart';
import '../../core/database/app_database.dart';
import '../../entities/domain/entity_type.dart';
import '../../projects/data/project_repository.dart';

/// Una tarea abierta con su contexto (a qué está vinculada, si a algo).
class FocusItem {
  FocusItem({required this.task, this.entity, this.project});

  final TaskRow task;

  /// La Entity vinculada por `activity_links` (null = tarea suelta).
  final EntityRow? entity;

  /// Fila de `projects` cuando [entity] es un Project (emoji/color).
  final ProjectRow? project;
}

/// Vista "Ahora": todas las tareas abiertas de la app en un solo lugar —
/// las de proyectos activos, las vinculadas a otras cosas y las sueltas —
/// sin requisitos (no son acciones) ni tareas de proyectos pausados,
/// archivados o de "algún día".
class FocusRepository {
  FocusRepository(this._db);
  final AppDatabase _db;

  Stream<List<FocusItem>> watchOpenTasks() => _watch(soloParaHacer: true);

  /// Todas las tareas (abiertas y cerradas, de cualquier proyecto) con su
  /// contexto — para la pestaña Tareas, que es el inventario completo.
  /// Sigue sin incluir requisitos.
  Stream<List<FocusItem>> watchAllTasks() => _watch(soloParaHacer: false);

  Stream<List<FocusItem>> _watch({required bool soloParaHacer}) => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.tasks, _db.activityLinks, _db.entities, _db.projects},
      )
      .watch()
      .asyncMap((_) => _load(soloParaHacer: soloParaHacer));

  /// [soloParaHacer]: solo abiertas y fuera las de proyectos no activos.
  Future<List<FocusItem>> _load({required bool soloParaHacer}) async {
    final tareas =
        await (_db.select(_db.tasks)..where(
              (t) =>
                  t.deletedAt.isNull() &
                  (soloParaHacer
                      ? t.status.isIn([
                          TaskStatus.pending.name,
                          TaskStatus.inProgress.name,
                        ])
                      : const Constant(true)),
            ))
            .get();
    if (tareas.isEmpty) return [];

    final links =
        await (_db.select(_db.activityLinks).join([
              innerJoin(
                _db.entities,
                _db.entities.id.equalsExp(_db.activityLinks.entityId),
              ),
              leftOuterJoin(
                _db.projects,
                _db.projects.entityId.equalsExp(_db.entities.id),
              ),
            ])..where(
              _db.activityLinks.activityType.equals('task') &
                  _db.activityLinks.activityId.isIn(tareas.map((t) => t.id)) &
                  _db.activityLinks.deletedAt.isNull() &
                  _db.entities.deletedAt.isNull(),
            ))
            .get();

    final requisitos = <String>{};
    final contexto = <String, (EntityRow, ProjectRow?)>{};
    for (final l in links) {
      final link = l.readTable(_db.activityLinks);
      if (link.linkType == requirementLinkType) {
        requisitos.add(link.activityId);
        continue;
      }
      contexto.putIfAbsent(
        link.activityId,
        () => (l.readTable(_db.entities), l.readTableOrNull(_db.projects)),
      );
    }

    final items = <FocusItem>[];
    for (final t in tareas) {
      if (requisitos.contains(t.id)) continue;
      final ctx = contexto[t.id];
      final entity = ctx?.$1;
      final esProyectoInactivo =
          entity != null &&
          entity.type == EntityType.project.name &&
          entity.status != EntityStatus.active.name;
      if (soloParaHacer && esProyectoInactivo) continue;
      items.add(FocusItem(task: t, entity: entity, project: ctx?.$2));
    }
    items.sort((a, b) => compararPorPlan(a.task, b.task));
    return items;
  }
}
