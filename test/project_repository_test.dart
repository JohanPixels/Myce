import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/projects/data/project_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entities;
  late TaskRepository tasks;
  late ProjectRepository projects;
  late String projectId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
    tasks = TaskRepository(db);
    projects = ProjectRepository(
      db,
      entities,
      tasks,
      RelationRepository(db),
      TagRepository(db),
    );
    projectId = await entities.create(type: EntityType.project, title: 'Myce');
  });

  tearDown(() => db.close());

  test(
    'un requisito no aparece en Tareas ni en la lista general de tareas',
    () async {
      await projects.addTask(projectId, 'Pantalla de proyecto');
      await projects.addRequirement(projectId, 'Funciona sin internet');

      final tareas = await projects.watchTasks(projectId).first;
      final requisitos = await projects.watchRequirements(projectId).first;
      final todas = await tasks.watchAll().first;

      expect(tareas.map((t) => t.title), ['Pantalla de proyecto']);
      expect(requisitos.map((t) => t.title), ['Funciona sin internet']);
      expect(todas.map((t) => t.title), ['Pantalla de proyecto']);
    },
  );

  test('el resumen cuenta progreso sin requisitos y elige En curso como próxima acción', () async {
    final a = await projects.addTask(projectId, 'A');
    await projects.addTask(projectId, 'B');
    final c = await projects.addTask(projectId, 'C');
    await projects.addRequirement(projectId, 'Requisito');
    await tasks.changeStatus(a, TaskStatus.completed);
    await tasks.changeStatus(c, TaskStatus.inProgress);

    final s = (await projects.watchSummary(projectId).first)!;
    expect(s.done, 1);
    expect(s.total, 3);
    expect(s.nextTask?.title, 'C');
  });

  test('un proyecto sin pendientes no tiene próxima acción', () async {
    final s = (await projects.watchSummary(projectId).first)!;
    expect(s.total, 0);
    expect(s.nextTask, isNull);
  });

  test('observaciones e ideas son Notes belongs_to del proyecto; convertir archiva la Note', () async {
    await projects.addObservation(projectId, 'El sync se siente lento');
    final ideaId = await projects.addObservation(
      projectId,
      'Color por proyecto',
      idea: true,
    );

    var obs = await projects.watchObservations(projectId).first;
    expect(obs, hasLength(2));
    expect(obs.firstWhere((o) => o.note.id == ideaId).isIdea, isTrue);
    expect(obs.where((o) => o.isIdea), hasLength(1));

    final lenta = obs.firstWhere((o) => !o.isIdea).note;
    await projects.convertToTask(projectId, lenta);

    obs = await projects.watchObservations(projectId).first;
    expect(obs.map((o) => o.note.id), [ideaId]);
    final tareas = await projects.watchTasks(projectId).first;
    expect(tareas.map((t) => t.title), ['El sync se siente lento']);
    final nota = await (db.select(
      db.entities,
    )..where((e) => e.id.equals(lenta.id))).getSingle();
    expect(nota.status, EntityStatus.archived.name);
    expect(nota.deletedAt, isNull);
  });

  test(
    'una observación larga guarda el texto completo en notes.content',
    () async {
      final largo = 'x' * 300;
      final id = await projects.addObservation(projectId, largo);
      final note = await entities.watchNote(id).first;
      final entity = await entities.watchById(id).first;
      expect(note!.content, largo);
      expect(entity!.title.length, lessThanOrEqualTo(120));
    },
  );

  test('updateAppearance guarda emoji y color y marca dirty', () async {
    await (db.update(db.projects)..where((p) => p.entityId.equals(projectId)))
        .write(const ProjectsCompanion(dirty: Value(false)));
    await projects.updateAppearance(projectId, emoji: '🍄', color: 'orange');

    final row = await (db.select(
      db.projects,
    )..where((p) => p.entityId.equals(projectId))).getSingle();
    expect(row.emoji, '🍄');
    expect(row.color, 'orange');
    expect(row.dirty, isTrue);
  });
}
