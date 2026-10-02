import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/core/widgets/markdown_field.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/focus/data/focus_repository.dart';
import 'package:octo_dash/goals/data/goal_repository.dart';
import 'package:octo_dash/inbox/data/inbox_repository.dart';
import 'package:octo_dash/links/data/link_repository.dart';
import 'package:octo_dash/projects/data/project_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entities;
  late TaskRepository tasks;
  late RelationRepository relations;
  late ProjectRepository projects;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
    tasks = TaskRepository(db);
    relations = RelationRepository(db);
    final tags = TagRepository(db);
    projects = ProjectRepository(
      db,
      entities,
      tasks,
      relations,
      tags,
      InboxRepository(db, entities, tags, tasks),
    );
  });

  tearDown(() => db.close());

  group('Ahora', () {
    test('junta tareas de proyectos activos y sueltas, sin requisitos ni proyectos pausados', () async {
      final activo = await entities.create(
        type: EntityType.project,
        title: 'Activo',
      );
      final pausado = await entities.create(
        type: EntityType.project,
        title: 'Pausado',
        status: EntityStatus.paused,
      );
      await projects.addTask(activo, 'De activo', horizon: TaskHorizon.now);
      await projects.addRequirement(activo, 'Requisito');
      await projects.addTask(pausado, 'De pausado');
      await tasks.create(title: 'Suelta');
      final hecha = await tasks.create(title: 'Hecha');
      await tasks.changeStatus(hecha, TaskStatus.completed);

      final items = await FocusRepository(db).watchOpenTasks().first;
      expect(items.map((i) => i.task.title), ['De activo', 'Suelta']);
      expect(items.first.entity?.title, 'Activo');
      expect(items.last.entity, isNull);
    });
  });

  group('Metas', () {
    test(
      'agrega el avance de los proyectos conectados en cualquier dirección',
      () async {
        final meta = await entities.create(
          type: EntityType.goal,
          title: 'Meta',
        );
        final a = await entities.create(type: EntityType.project, title: 'A');
        final b = await entities.create(type: EntityType.project, title: 'B');
        await entities.create(type: EntityType.project, title: 'Sin conectar');
        await relations.create(
          sourceEntityId: a,
          targetEntityId: meta,
          relationTypeKey: 'supports',
        );
        await relations.create(
          sourceEntityId: meta,
          targetEntityId: b,
          relationTypeKey: 'related_to',
        );
        final t = await projects.addTask(a, 'tarea A');
        await projects.addTask(b, 'tarea B');
        await tasks.changeStatus(t, TaskStatus.completed);

        final metas = await GoalRepository(db, projects).watchGoals().first;
        final g = metas.single;
        expect(g.projects.map((p) => p.entity.title), ['A', 'B']);
        expect((g.done, g.total), (1, 2));
      },
    );
  });

  group('Enlaces [[...]]', () {
    test(
      'sugiere títulos, resuelve sin distinguir mayúsculas y prefiere la Nota',
      () async {
        final links = LinkRepository(db, entities);
        await entities.create(type: EntityType.project, title: 'Sync');
        final nota = await entities.create(
          type: EntityType.note,
          title: 'Sync',
        );
        await entities.create(type: EntityType.resource, title: 'Otro');

        expect(await links.suggestTitles('syn'), ['Sync']);
        expect((await links.findByTitle('  sync '))?.id, nota);
        expect(await links.findByTitle('No existe'), isNull);
      },
    );

    test(
      'Mencionado en: notas, descripciones y tareas que contienen [[título]]',
      () async {
        final links = LinkRepository(db, entities);
        final destino = await entities.create(
          type: EntityType.note,
          title: 'Offline first',
        );
        final nota = await entities.create(type: EntityType.note, title: 'N');
        await entities.updateNoteContent(nota, 'ver [[offline first]] luego');
        final recurso = await entities.create(
          type: EntityType.resource,
          title: 'R',
        );
        await entities.updateDescription(
          recurso,
          'relacionado: [[Offline first]]',
        );
        final tarea = await tasks.create(title: 'T');
        await tasks.updateDescription(tarea, '[[Offline first]]');
        await entities.create(type: EntityType.note, title: 'Sin mención');

        final row = (await entities.watchById(destino).first)!;
        final hits = await links.watchBacklinks(row).first;
        expect(hits.map((h) => (h.title, h.isTask)).toSet(), {
          ('N', false),
          ('R', false),
          ('T', true),
        });
      },
    );

    test(
      '[[...]] se vuelve enlace tocable salvo dentro de bloques de código',
      () {
        const md = 'ver [[Mi nota]]\n```\n[[no tocar]]\n```';
        final out = conEnlacesWikiParaTest(md);
        expect(out, contains('[Mi nota](wiki:Mi%20nota)'));
        expect(out, contains('[[no tocar]]'));
      },
    );
  });
}
