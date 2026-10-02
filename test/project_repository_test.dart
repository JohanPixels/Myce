import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/inbox/data/inbox_repository.dart';
import 'package:octo_dash/projects/data/project_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entities;
  late TaskRepository tasks;
  late ProjectRepository projects;
  late InboxRepository inbox;
  late String projectId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
    tasks = TaskRepository(db);
    final tags = TagRepository(db);
    inbox = InboxRepository(db, entities, tags, tasks);
    projects = ProjectRepository(
      db,
      entities,
      tasks,
      RelationRepository(db),
      tags,
      inbox,
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

  test('la próxima acción sale de Ahora antes que de una En curso en Siguiente', () async {
    final enCurso = await projects.addTask(projectId, 'En curso en Siguiente');
    await tasks.changeStatus(enCurso, TaskStatus.inProgress);
    await projects.addTask(projectId, 'Después', horizon: TaskHorizon.later);
    await projects.addTask(projectId, 'Ahora', horizon: TaskHorizon.now);

    final s = (await projects.watchSummary(projectId).first)!;
    expect(s.nextTask?.title, 'Ahora');
  });

  test('cambiar horizonte y tamaño marca la tarea dirty', () async {
    final id = await projects.addTask(projectId, 'A');
    await (db.update(db.tasks)..where((t) => t.id.equals(id)))
        .write(const TasksCompanion(dirty: Value(false)));
    final tarea = (await tasks.watchById(id).first)!;

    await projects.moveTo(tarea, TaskHorizon.now);
    await projects.resize(tarea, TaskSize.quick);

    final row = (await tasks.watchById(id).first)!;
    expect(row.horizon, 'now');
    expect(row.size, 'quick');
    expect(row.dirty, isTrue);
  });

  test('cabeEnElTiempo: sin límite cabe todo; sin estimar no cabe en un límite', () {
    expect(cabeEnElTiempo(null, null), isTrue);
    expect(cabeEnElTiempo(TaskSize.long, null), isTrue);
    expect(cabeEnElTiempo(null, TaskSize.hour), isFalse);
    expect(cabeEnElTiempo(TaskSize.quick, TaskSize.quick), isTrue);
    expect(cabeEnElTiempo(TaskSize.hour, TaskSize.quick), isFalse);
    expect(cabeEnElTiempo(TaskSize.quick, TaskSize.hour), isTrue);
    expect(cabeEnElTiempo(TaskSize.long, TaskSize.hour), isFalse);
  });

  test('un horizonte desconocido o null se lee como Siguiente', () {
    expect((null as String?).toTaskHorizon(), TaskHorizon.next);
    expect('algo-raro'.toTaskHorizon(), TaskHorizon.next);
    expect('now'.toTaskHorizon(), TaskHorizon.now);
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

  test('una captura del proyecto no aparece en el Inbox general y cuenta como sin clasificar', () async {
    await inbox.capture('Captura general');
    await projects.capture(projectId, 'Algo de Myce');

    final general = await inbox.watchInbox().first;
    final delProyecto = await projects.watchUnclassified(projectId).first;
    final s = (await projects.watchSummary(projectId).first)!;

    expect(general.map((i) => i.content), ['Captura general']);
    expect(delProyecto.map((i) => i.content), ['Algo de Myce']);
    expect(s.unclassified, 1);
  });

  test('clasificar una captura la convierte en lo elegido y la saca del proyecto', () async {
    for (final texto in ['t', 'o', 'r', 'i', 'd']) {
      await projects.capture(projectId, texto);
    }
    final items = await projects.watchUnclassified(projectId).first;
    String idDe(String texto) => items.firstWhere((i) => i.content == texto).id;

    await projects.classifyCapture(projectId, idDe('t'), ProjectCaptureKind.task);
    await projects.classifyCapture(projectId, idDe('o'), ProjectCaptureKind.observation);
    await projects.classifyCapture(projectId, idDe('r'), ProjectCaptureKind.requirement);
    await projects.classifyCapture(projectId, idDe('i'), ProjectCaptureKind.idea);
    await projects.discardCapture(idDe('d'));

    expect(await projects.watchUnclassified(projectId).first, isEmpty);
    expect((await projects.watchTasks(projectId).first).map((t) => t.title), ['t']);
    expect((await projects.watchRequirements(projectId).first).map((t) => t.title), ['r']);
    final obs = await projects.watchObservations(projectId).first;
    expect(obs.map((o) => (o.note.title, o.isIdea)).toSet(), {('o', false), ('i', true)});
    // procesadas = soft-delete + dirty, para que el sync propague
    final filas = await db.select(db.inboxItems).get();
    expect(filas.every((f) => f.deletedAt != null && f.dirty), isTrue);
  });

  test('una captura larga como tarea recorta el título y guarda el texto en la descripción', () async {
    final largo = 'y' * 260;
    await projects.capture(projectId, largo);
    final item = (await projects.watchUnclassified(projectId).first).single;
    await projects.classifyCapture(projectId, item.id, ProjectCaptureKind.task);

    final tarea = (await projects.watchTasks(projectId).first).single;
    expect(tarea.title.length, lessThanOrEqualTo(200));
    expect(tarea.description, largo);
  });

  test('borrar el proyecto descarta sus capturas sin clasificar', () async {
    await projects.capture(projectId, 'pendiente');
    await entities.delete(projectId);
    final filas = await db.select(db.inboxItems).get();
    expect(filas.single.deletedAt, isNotNull);
  });
}
