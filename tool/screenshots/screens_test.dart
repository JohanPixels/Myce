// "Fotógrafo" de pantallas: renderiza las pantallas reales de Myce con datos
// de prueba a PNG, para revisar el diseño sin tener que abrir el celular.
// Vive fuera de test/ a propósito: no corre con `flutter test` normal.
//
//   flutter test tool/screenshots/screens_test.dart --update-goldens
//
// Los PNG quedan en tool/screenshots/out/ (ignorado por git).
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/activities/data/task_repository.dart';
import 'package:octo_dash/activities/presentation/task_list_screen.dart';
import 'package:octo_dash/activities/domain/task_enums.dart';
import 'package:octo_dash/core/database/app_database.dart';
import 'package:octo_dash/core/database/database_provider.dart';
import 'package:octo_dash/core/navigation/app_sections.dart';
import 'package:octo_dash/core/navigation/carousel_nav_bar.dart';
import 'package:octo_dash/core/theme/app_icons.dart';
import 'package:octo_dash/core/theme/app_theme.dart';
import 'package:octo_dash/entities/data/entity_repository.dart';
import 'package:octo_dash/entities/domain/entity_type.dart';
import 'package:octo_dash/focus/presentation/focus_screen.dart';
import 'package:octo_dash/goals/presentation/goal_list_screen.dart';
import 'package:octo_dash/inbox/data/inbox_repository.dart';
import 'package:octo_dash/inbox/inbox_screen.dart';
import 'package:octo_dash/projects/data/project_repository.dart';
import 'package:octo_dash/projects/presentation/project_detail_screen.dart';
import 'package:octo_dash/projects/presentation/project_list_screen.dart';
import 'package:octo_dash/relations/data/relation_repository.dart';
import 'package:octo_dash/tags/data/tag_repository.dart';

Future<void> _cargarFuente(String familia, List<String> archivos) async {
  final loader = FontLoader(familia);
  for (final a in archivos) {
    final bytes = await File(a).readAsBytes();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

String _flutterRoot() {
  final flutter = Process.runSync('which', ['flutter']).stdout.toString().trim();
  return File(flutter).resolveSymbolicLinksSync().replaceAll('/bin/flutter', '');
}

late String _projectId;

Future<void> _sembrar(AppDatabase db) async {
  final entities = EntityRepository(db);
  final tasks = TaskRepository(db);
  final relations = RelationRepository(db);
  final tags = TagRepository(db);
  final inbox = InboxRepository(db, entities, tags, tasks);
  final projects = ProjectRepository(db, entities, tasks, relations, tags, inbox);

  final myce = await entities.create(
    type: EntityType.project,
    title: 'Myce',
    description:
        'Sistema personal para capturar rápido, organizar después y conectarlo todo.',
  );
  _projectId = myce;
  await projects.updateAppearance(myce, emoji: null, color: 'moss');
  final video = await entities.create(
    type: EntityType.project,
    title: 'Video: cómo construí Myce',
  );
  await projects.updateAppearance(video, emoji: null, color: 'orange');
  final porta = await entities.create(
    type: EntityType.project,
    title: 'Portafolio de ilustración',
  );
  await projects.updateAppearance(porta, emoji: null, color: 'violet');

  Future<void> tarea(
    String p,
    String t, {
    TaskHorizon h = TaskHorizon.next,
    TaskSize? s,
    bool hecha = false,
  }) async {
    final id = await projects.addTask(p, t, horizon: h);
    if (s != null) await tasks.changeSize(id, s);
    if (hecha) await tasks.changeStatus(id, TaskStatus.completed);
  }

  await tarea(myce, 'Pantalla propia de Proyecto', h: TaskHorizon.now, s: TaskSize.long);
  await tarea(myce, 'Definir los estados de un proyecto', h: TaskHorizon.now, s: TaskSize.quick);
  await tarea(myce, 'Agregar Ahora / Siguiente / Después', s: TaskSize.hour);
  await tarea(myce, 'Cambiar anonKey por publishableKey', s: TaskSize.quick);
  await tarea(myce, 'Kanban de tareas del proyecto', s: TaskSize.long);
  await tarea(myce, 'Pantallas para Personas y Hobbies', h: TaskHorizon.later);
  for (final t in ['Navegación con go_router', 'Buscador general', 'Sync push + pull', 'Ícono de la app']) {
    await tarea(myce, t, hecha: true);
  }
  await tarea(video, 'Escribir el guion del intro', h: TaskHorizon.now, s: TaskSize.hour);
  await tarea(video, 'Grabar pantalla del Inbox');
  await tarea(video, 'Editar', hecha: true);
  await projects.addRequirement(myce, 'Funciona sin internet');
  await projects.addRequirement(myce, 'Siempre sé qué hacer primero');
  await projects.addObservation(myce, 'El sync se siente lento al abrir la app con mala señal.');
  await projects.addObservation(myce, '¿Y si cada proyecto tuviera su propio color?', idea: true);
  final doc = await projects.addDocument(myce, 'Especificación del modelo');
  await entities.updateNoteContent(doc, '# Modelo\nEntities + Activities + Relations.');
  await projects.capture(myce, 'El botón de borrar tarea queda muy abajo');
  await projects.capture(myce, 'Tiene que poder usarse con una mano');
  await tasks.create(title: 'Pagar el internet', horizon: TaskHorizon.now, );

  final meta = await entities.create(type: EntityType.goal, title: 'Vivir de lo que creo');
  await relations.create(sourceEntityId: myce, targetEntityId: meta, relationTypeKey: 'supports');
  await relations.create(sourceEntityId: video, targetEntityId: meta, relationTypeKey: 'supports');
  await inbox.capture('Idea: modo enfoque con temporizador');
  await inbox.capture('Comprar audífonos');
}

Widget _shell(String seccion, Widget body, {bool conAppBar = true}) {
  final index = appSections.indexWhere((s) => s.path == seccion);
  return DefaultTabController(
    length: appSections.length,
    initialIndex: index,
    child: Scaffold(
      appBar: conAppBar
          ? AppBar(
              title: Text(appSections[index].titulo),
              actions: const [
                IconButton(onPressed: null, icon: Icon(AppIcons.buscar)),
                IconButton(onPressed: null, icon: Icon(AppIcons.sync)),
                IconButton(onPressed: null, icon: Icon(AppIcons.ajustes)),
              ],
            )
          : null,
      body: body,
      floatingActionButton: conAppBar
          ? FloatingActionButton(onPressed: () {}, child: const Icon(AppIcons.agregar))
          : null,
      bottomNavigationBar: conAppBar
          ? Builder(
              builder: (context) {
                final colors = Theme.of(context).colorScheme;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    border: Border(
                      top: BorderSide(color: colors.outlineVariant),
                    ),
                  ),
                  child: SafeArea(child: CarouselNavBar(onTapActual: () {})),
                );
              },
            )
          : null,
    ),
  );
}

void main() {
  setUpAll(() async {
    final root = _flutterRoot();
    await _cargarFuente('Manrope', [
      for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'])
        'assets/fonts/Manrope-$w.ttf',
    ]);
    await _cargarFuente('BricolageGrotesque', [
      for (final w in ['SemiBold', 'Bold', 'ExtraBold'])
        'assets/fonts/BricolageGrotesque-$w.ttf',
    ]);
    for (final (familia, archivo) in [
      ('PhosphorRegular', 'Phosphor.ttf'),
      ('PhosphorDuotone', 'Phosphor-Duotone.ttf'),
      ('PhosphorFill', 'Phosphor-Fill.ttf'),
    ]) {
      await _cargarFuente(familia, ['assets/fonts/phosphor/$archivo']);
    }
    await _cargarFuente('MaterialIcons', [
      '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ]);
  });

  final pantallas = <String, Widget Function()>{
    'ahora': () => _shell('ahora', const FocusScreen()),
    'proyectos': () => _shell('projects', const ProjectListScreen()),
    'proyecto': () => ProjectDetailScreen(projectId: _projectId),
    'metas': () => _shell('goals', const GoalListScreen()),
    'inbox': () => _shell('inbox', const InboxScreen()),
    'tareas': () => _shell('tasks', const TaskListScreen()),
  };

  for (final modo in [Brightness.dark, Brightness.light]) {
    for (final entrada in pantallas.entries) {
      final nombre = '${entrada.key}_${modo.name}';
      testWidgets(nombre, (tester) async {
        tester.view.physicalSize = const Size(390 * 2, 844 * 2);
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);

        final db = AppDatabase.forTesting(NativeDatabase.memory());
        await tester.runAsync(() => _sembrar(db));
        await tester.runAsync(() async {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [databaseProvider.overrideWithValue(db)],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: modo == Brightness.dark
                    ? buildDarkTheme()
                    : buildLightTheme(),
                home: entrada.value(),
              ),
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 300));
        });
        await tester.pump();
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('out/$nombre.png'),
        );

        await tester.runAsync(() async {
          await tester.pumpWidget(const SizedBox());
          await db.close();
        });
      });
    }
  }
}
