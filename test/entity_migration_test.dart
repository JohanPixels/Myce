import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/inbox/data/inbox_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entities;
  late TagRepository tags;
  late TaskRepository tasks;
  late InboxRepository inbox;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
    tags = TagRepository(db);
    tasks = TaskRepository(db);
    inbox = InboxRepository(db, entities, tags, tasks);
  });

  tearDown(() => db.close());

  test('capturar y clasificar como Project crea la Entity + fila de tipo, y limpia el Inbox', () async {
    await inbox.capture('Terminar la migración a Myce');
    final pending = await db.select(db.inboxItems).get();
    expect(pending, hasLength(1));

    final entityId = await inbox.classify(
      pending.first.id,
      type: EntityType.project,
    );

    final projectsCreated = await entities.watchByType(EntityType.project).first;
    expect(projectsCreated, hasLength(1));
    expect(projectsCreated.first.id, entityId);
    expect(projectsCreated.first.title, 'Terminar la migración a Myce');

    final projectRow = await (db.select(
      db.projects,
    )..where((p) => p.entityId.equals(entityId))).getSingle();
    expect(projectRow.entityId, entityId);

    final remainingInbox = await (db.select(
      db.inboxItems,
    )..where((i) => i.deletedAt.isNull())).get();
    expect(remainingInbox, isEmpty);
  });

  test('clasificar como Resource + wishlist con tag aparece en sugerencias', () async {
    await inbox.capture('El señor de los anillos');
    final item = (await db.select(db.inboxItems).get()).single;

    final entityId = await inbox.classify(
      item.id,
      type: EntityType.resource,
      status: EntityStatus.someday,
      tags: ['libro'],
    );

    final suggestions = await entities.wishlistSuggestions(10);
    expect(suggestions.map((e) => e.id), contains(entityId));

    final entityTags = await tags.watchTagsForEntity(entityId).first;
    expect(entityTags.map((t) => t.name), contains('libro'));
  });

  test('borrar una Task marca sus activity_links como soft-deleted (mitigación de la deuda técnica documentada, necesaria para propagar el borrado por sync)', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    final taskId = await tasks.create(title: 'Hacer algo');
    await tasks.linkToEntity(taskId, entityId, 'part_of');

    expect(await db.select(db.activityLinks).get(), hasLength(1));

    await tasks.delete(taskId);

    final links = await db.select(db.activityLinks).get();
    expect(links, hasLength(1));
    expect(links.single.deletedAt, isNotNull);
    expect(links.single.dirty, isTrue);
    expect(await tasks.watchLinkedToEntity(entityId).first, isEmpty);
  });

  test('editar descripción, tagear y conectar dos entities vía relations', () async {
    final curso = await entities.create(
      type: EntityType.resource,
      title: 'Curso de Flutter',
    );
    final nota = await entities.create(
      type: EntityType.note,
      title: 'Apuntes del curso',
    );

    await entities.updateDescription(curso, 'Módulo 3: Riverpod');
    final actualizada = await entities.watchById(curso).first;
    expect(actualizada!.description, 'Módulo 3: Riverpod');

    await tags.tagEntity(curso, 'programacion');
    final cursoTags = await tags.watchTagsForEntity(curso).first;
    expect(cursoTags.map((t) => t.name), contains('programacion'));

    final relations = RelationRepository(db);
    await relations.create(
      sourceEntityId: nota,
      targetEntityId: curso,
      relationTypeKey: 'related_to',
    );

    final desdeCurso = await relations.listForEntityDisplay(curso);
    expect(desdeCurso, hasLength(1));
    expect(desdeCurso.first.otherEntityId, nota);

    final desdeNota = await relations.listForEntityDisplay(nota);
    expect(desdeNota, hasLength(1));
    expect(desdeNota.first.otherEntityId, curso);
  });

  test('editar fechas de un Project vía su tabla propia (projects), no entities', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Migrar a Myce',
    );

    await entities.updateProjectStartedAt(entityId, DateTime(2026, 1, 1));
    await entities.updateProjectCompletedAt(entityId, DateTime(2026, 3, 1));

    final project = await entities.watchProject(entityId).first;
    expect(project!.startedAt, DateTime(2026, 1, 1));
    expect(project.completedAt, DateTime(2026, 3, 1));
  });

  test('editar contenido de una Note vía su campo propio (notes.content), no description', () async {
    final entityId = await entities.create(
      type: EntityType.note,
      title: 'Apuntes',
    );

    await entities.updateNoteContent(entityId, '# Título\n\nCuerpo en Markdown');

    final note = await entities.watchNote(entityId).first;
    expect(note!.content, '# Título\n\nCuerpo en Markdown');

    final entity = await entities.watchById(entityId).first;
    expect(entity!.description, isNull);
  });

  test('clasificar un InboxItem como Task crea la Task con priority/dueAt y borra el InboxItem', () async {
    await inbox.capture('Pagar el alquiler');
    final item = (await db.select(db.inboxItems).get()).single;

    final dueDate = DateTime(2026, 10, 1);
    final taskId = await inbox.classifyAsTask(
      item.id,
      priority: TaskPriority.high,
      dueAt: dueDate,
    );

    final taskRow = await (db.select(
      db.tasks,
    )..where((t) => t.id.equals(taskId))).getSingle();
    expect(taskRow.title, 'Pagar el alquiler');
    expect(taskRow.priority, 'high');
    expect(taskRow.dueAt, dueDate);
    expect(taskRow.status, 'pending');

    final remainingInbox = await (db.select(
      db.inboxItems,
    )..where((i) => i.deletedAt.isNull())).get();
    expect(remainingInbox, isEmpty);
  });

  test('watchDueTodayOrOverdue trae vencidas, no futuras, no completadas', () async {
    final ayer = DateTime.now().subtract(const Duration(days: 1));
    final enDiez = DateTime.now().add(const Duration(days: 10));

    final vencida = await tasks.create(title: 'Vencida', dueAt: ayer);
    await tasks.create(title: 'Futura', dueAt: enDiez);
    final completadaVencida = await tasks.create(
      title: 'Completada pero vencida',
      dueAt: ayer,
    );
    await tasks.changeStatus(completadaVencida, TaskStatus.completed);

    final resultado = await tasks.watchDueTodayOrOverdue().first;
    expect(resultado.map((t) => t.id), [vencida]);
  });

  test('vincular y desvincular una Task de una Entity vía watchLinkedEntity/unlinkFromEntity', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto Y',
    );
    final taskId = await tasks.createLinkedTo(entityId, title: 'Tarea del proyecto');

    final vinculada = await tasks.watchLinkedEntity(taskId).first;
    expect(vinculada!.id, entityId);

    await tasks.unlinkFromEntity(taskId);

    final desvinculada = await tasks.watchLinkedEntity(taskId).first;
    expect(desvinculada, isNull);
  });
}
