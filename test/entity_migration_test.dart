import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/inbox/data/inbox_repository.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';
import 'package:octo_dash/activities/data/task_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entities;
  late TagRepository tags;
  late InboxRepository inbox;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    entities = EntityRepository(db);
    tags = TagRepository(db);
    inbox = InboxRepository(db, entities, tags);
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

  test('borrar una Task limpia sus activity_links (mitigación de la deuda técnica documentada)', () async {
    final entityId = await entities.create(
      type: EntityType.project,
      title: 'Proyecto X',
    );
    final taskRepo = TaskRepository(db);
    final taskId = await taskRepo.create(title: 'Hacer algo');
    await taskRepo.linkToEntity(taskId, entityId, 'part_of');

    expect(await db.select(db.activityLinks).get(), hasLength(1));

    await taskRepo.delete(taskId);

    expect(await db.select(db.activityLinks).get(), isEmpty);
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
}
