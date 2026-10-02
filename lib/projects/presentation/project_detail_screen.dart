import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/domain/task_enums.dart';
import '../../activities/presentation/task_plan_sheet.dart';
import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/project_palette.dart';
import '../../entities/domain/entity_type.dart';
import '../data/project_repository.dart';
import '../data/project_repository_provider.dart';
import 'classify_capture_sheet.dart';
import 'project_appearance_sheet.dart';
import 'project_avatar.dart';
import '../../core/widgets/copiar.dart';
import '../../core/widgets/renombrar_dialog.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../core/widgets/markdown_field.dart';
import '../../relations/presentation/add_relation_sheet.dart';
import '../../links/presentation/wiki_links.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/estado_vacio.dart';

/// Pantalla propia de un Project: cabecera con progreso y tres pestañas —
/// Tareas (acciones), Observaciones (cosas que notaste, Notes del proyecto)
/// y Requisitos (lo que el proyecto debe cumplir). Tags, fechas y
/// relaciones siguen en la pantalla genérica, accesible desde el menú.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(projectRepositoryProvider);

    return StreamBuilder<ProjectSummary?>(
      stream: repo.watchSummary(projectId),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState != ConnectionState.active) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final summary = snapshot.data;
        if (summary == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Esto ya no existe')),
          );
        }

        void editarApariencia() => mostrarAparienciaProyectoSheet(
          context,
          ref,
          projectId: projectId,
          title: summary.entity.title,
          emoji: summary.project?.emoji,
          colorKey: summary.project?.color,
        );

        Future<void> renombrar() async {
          final nuevo = await pedirNuevoTexto(
            context,
            titulo: 'Renombrar proyecto',
            actual: summary.entity.title,
            maxLength: 200,
          );
          if (nuevo != null) {
            ref.read(entityRepositoryProvider).updateTitle(projectId, nuevo);
          }
        }

        Future<void> cambiarEstado() async {
          final actual = summary.entity.status.toEntityStatus();
          final nuevo = await showModalBottomSheet<EntityStatus>(
            context: context,
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final estado in EntityStatus.values)
                    ListTile(
                      leading: Icon(
                        estado == actual ? AppIcons.radioOn : AppIcons.radioOff,
                      ),
                      title: Text(estado.label),
                      subtitle: Text(switch (estado) {
                        EntityStatus.active => 'En movimiento',
                        EntityStatus.paused =>
                          'Detenido por ahora, vuelvo luego',
                        EntityStatus.someday => 'Quizás algún día',
                        EntityStatus.archived => 'Terminado o descartado',
                      }),
                      onTap: () => Navigator.of(ctx).pop(estado),
                    ),
                ],
              ),
            ),
          );
          if (nuevo != null && nuevo != actual) {
            ref.read(entityRepositoryProvider).changeStatus(projectId, nuevo);
          }
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                tooltip: 'Más opciones',
                onSelected: (accion) {
                  if (accion == 'renombrar') renombrar();
                  if (accion == 'estado') cambiarEstado();
                  if (accion == 'apariencia') editarApariencia();
                  if (accion == 'detalles') {
                    pushEntityDetail(context, projectId, generic: true);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'renombrar', child: Text('Renombrar')),
                  PopupMenuItem(value: 'estado', child: Text('Cambiar estado')),
                  PopupMenuItem(
                    value: 'apariencia',
                    child: Text('Cambiar emoji y color'),
                  ),
                  PopupMenuItem(
                    value: 'detalles',
                    child: Text('Detalles, tags y conexiones'),
                  ),
                ],
              ),
            ],
          ),
          body: DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverToBoxAdapter(
                  child: _Cabecera(
                    summary: summary,
                    onTapAvatar: editarApariencia,
                    onTapTitulo: renombrar,
                    onTapEstado: cambiarEstado,
                    onCapture: (texto) => repo.capture(projectId, texto),
                    onClasificar: () => mostrarClasificarCapturasSheet(
                      context,
                      projectId: projectId,
                      projectTitle: summary.entity.title,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      // 4 pestañas en el ancho de un celular: sin el padding
                      // por defecto (16 a cada lado) "Requisitos" no cabe.
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      indicatorColor: projectColor(
                        context,
                        summary.project?.color,
                      ),
                      tabs: const [
                        Tab(text: 'Tareas'),
                        Tab(text: 'Notas'),
                        Tab(text: 'Requisitos'),
                        Tab(text: 'Contexto'),
                      ],
                    ),
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  _TareasTab(projectId: projectId),
                  _NotasTab(projectId: projectId),
                  _RequisitosTab(projectId: projectId),
                  _ContextoTab(summary: summary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({
    required this.summary,
    required this.onTapAvatar,
    required this.onTapTitulo,
    required this.onTapEstado,
    required this.onCapture,
    required this.onClasificar,
  });

  final ProjectSummary summary;
  final VoidCallback onTapAvatar;
  final VoidCallback onTapTitulo;
  final VoidCallback onTapEstado;
  final void Function(String texto) onCapture;
  final VoidCallback onClasificar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.octoSpacing;
    final entity = summary.entity;
    final color = projectColor(context, summary.project?.color);
    final progreso = summary.total == 0 ? 0.0 : summary.done / summary.total;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md + 4,
        0,
        spacing.md + 4,
        spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Tooltip(
                message: 'Cambiar emoji y color',
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTapAvatar,
                  child: ProjectAvatar(
                    title: entity.title,
                    emoji: summary.project?.emoji,
                    colorKey: summary.project?.color,
                    size: 64,
                  ),
                ),
              ),
              SizedBox(width: spacing.md - 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onTapTitulo,
                      child: Text(
                        entity.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: onTapEstado,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: color),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entity.status.toEntityStatus().label,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(AppIcons.caretAbajo, size: 18, color: color),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (entity.description != null &&
              entity.description!.trim().isNotEmpty) ...[
            SizedBox(height: spacing.md - 4),
            Text(
              entity.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 8,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.15),
                  ),
                ),
              ),
              SizedBox(width: spacing.md - 4),
              Text(
                '${summary.done}/${summary.total}',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          _CampoRapido(
            hint: 'Anotar algo en ${entity.title}…',
            onSubmit: onCapture,
            textoBoton: 'Anotar',
          ),
          if (summary.unclassified > 0) ...[
            SizedBox(height: spacing.sm + 2),
            _SinClasificarBanner(
              cantidad: summary.unclassified,
              onTap: onClasificar,
            ),
          ],
        ],
      ),
    );
  }
}

class _SinClasificarBanner extends StatelessWidget {
  const _SinClasificarBanner({required this.cantidad, required this.onTap});

  final int cantidad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    return Material(
      color: atencion.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: atencion.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: atencion,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$cantidad',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.octoColors.onEnCurso,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sin clasificar',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Toca para decidir qué es cada cosa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(AppIcons.caretDerecha, color: atencion),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar, this.fondo);

  final TabBar tabBar;
  final Color fondo;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) =>
      Material(color: fondo, child: tabBar);

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.tabBar != tabBar || old.fondo != fondo;
}

/// Campo de captura rápida al tope de cada pestaña. UI optimista: no espera
/// a la base — limpia y sigue, el stream refresca la lista solo.
class _CampoRapido extends StatefulWidget {
  const _CampoRapido({
    required this.hint,
    required this.onSubmit,
    this.debajo,
    this.colapsado,
    this.textoBoton,
  });

  final String hint;
  final void Function(String texto) onSubmit;
  final Widget? debajo;

  /// Si se da, el campo arranca escondido detrás de un botón con este texto
  /// (ej. "Nueva tarea") — así la pantalla no muestra dos campos de texto
  /// casi iguales (el "Anotar…" de la cabecera ya es la entrada principal).
  final String? colapsado;

  /// Botón con texto en vez del ícono + (ej. "Anotar", como en el mockup).
  final String? textoBoton;

  @override
  State<_CampoRapido> createState() => _CampoRapidoState();
}

class _CampoRapidoState extends State<_CampoRapido> {
  final _controller = TextEditingController();
  final _foco = FocusNode();
  late bool _abierto = widget.colapsado == null;

  @override
  void initState() {
    super.initState();
    // Al perder el foco sin haber escrito nada, vuelve a ser un botón.
    _foco.addListener(() {
      if (!_foco.hasFocus &&
          widget.colapsado != null &&
          _controller.text.trim().isEmpty) {
        setState(() => _abierto = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    widget.onSubmit(texto);
    _controller.clear();
    _foco.requestFocus(); // seguir anotando sin volver a tocar
  }

  @override
  Widget build(BuildContext context) {
    if (!_abierto) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(AppIcons.agregar, size: 20),
          label: Text(widget.colapsado!),
          onPressed: () {
            setState(() => _abierto = true);
            _foco.requestFocus();
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _foco,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _enviar(),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.textoBoton == null
                ? IconButton(
                    icon: const Icon(AppIcons.agregar),
                    tooltip: 'Agregar',
                    onPressed: _enviar,
                  )
                : Padding(
                    padding: const EdgeInsets.all(6),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: _enviar,
                      child: Text(widget.textoBoton!),
                    ),
                  ),
          ),
        ),
        ?widget.debajo,
      ],
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({
    required this.texto,
    required this.cantidad,
    this.color,
    this.pista,
    this.icono,
  });

  final String texto;
  final int cantidad;
  final Color? color;
  final String? pista;

  /// Ícono a la izquierda del título; sin ícono se dibuja un punto de
  /// [color] (o nada, si tampoco hay color).
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          if (icono != null) ...[
            Icon(
              icono,
              size: 18,
              color: color ?? theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
          ] else if (color != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            texto,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$cantidad',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (pista != null) ...[
            const Spacer(),
            Text(
              pista!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TareasTab extends ConsumerStatefulWidget {
  const _TareasTab({required this.projectId});

  final String projectId;

  @override
  ConsumerState<_TareasTab> createState() => _TareasTabState();
}

class _TareasTabState extends ConsumerState<_TareasTab> {
  /// Tiempo disponible ("tengo…"); null = sin límite.
  TaskSize? _tengo;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(projectRepositoryProvider);
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;

    return StreamBuilder<List<TaskRow>>(
      stream: repo.watchTasks(widget.projectId),
      builder: (context, snapshot) {
        final tareas = snapshot.data ?? const <TaskRow>[];
        final abiertas =
            tareas
                .where(
                  (t) =>
                      t.status == TaskStatus.pending.name ||
                      t.status == TaskStatus.inProgress.name,
                )
                .toList()
              ..sort(compararPorPlan);
        final visibles = abiertas
            .where((t) => cabeEnElTiempo(t.size.toTaskSize(), _tengo))
            .toList();
        final ocultasSinEstimar = abiertas
            .where((t) => _tengo != null && t.size == null)
            .length;
        final enAhora = abiertas
            .where((t) => t.horizon.toTaskHorizon() == TaskHorizon.now)
            .length;
        final hechas = tareas
            .where((t) => t.status == TaskStatus.completed.name)
            .toList();

        List<TaskRow> de(TaskHorizon h) =>
            visibles.where((t) => t.horizon.toTaskHorizon() == h).toList();

        Widget seccion(TaskHorizon h, Color? color, String vacio) {
          final items = de(h);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TituloSeccion(
                texto: h.label,
                cantidad: items.length,
                color: color,
                icono: AppIcons.deHorizonte(h),
                pista: h == TaskHorizon.now ? 'máx. $maxTareasAhora' : null,
              ),
              if (items.isEmpty)
                EstadoVacio(
                  texto: _tengo == null
                      ? vacio
                      : 'Nada que quepa en ese tiempo.',
                  icono: h == TaskHorizon.now
                      ? AppIconsDuo.ahora
                      : AppIconsDuo.brote,
                )
              else
                for (final t in items)
                  _TareaTile(
                    tarea: t,
                    onPlan: () => mostrarPlanTareaSheet(
                      context,
                      ref,
                      t,
                      tareasEnAhora:
                          enAhora -
                          (t.horizon.toTaskHorizon() == TaskHorizon.now
                              ? 1
                              : 0),
                    ),
                  ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            _CampoRapido(
              hint: 'Nueva tarea…',
              colapsado: 'Nueva tarea',
              onSubmit: (texto) => repo.addTask(widget.projectId, texto),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Tengo',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [
                      for (final (valor, texto) in [
                        (TaskSize.quick, '15 min'),
                        (TaskSize.hour, '1 hora'),
                        (null, 'Sin límite'),
                      ])
                        ChoiceChip(
                          label: Text(texto),
                          selected: _tengo == valor,
                          onSelected: (_) => setState(() => _tengo = valor),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (ocultasSinEstimar > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '$ocultasSinEstimar sin tiempo estimado no se muestran — '
                  'toca ⋯ en una tarea para estimarla.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            seccion(
              TaskHorizon.now,
              atencion,
              'Elige 1 a $maxTareasAhora tareas para tu próximo rato (⋯ → Ahora).',
            ),
            seccion(
              TaskHorizon.next,
              theme.colorScheme.primary,
              'Nada pendiente. Anota la próxima acción.',
            ),
            seccion(
              TaskHorizon.later,
              theme.colorScheme.outline,
              'Nada para después.',
            ),
            if (hechas.isNotEmpty)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Hechas · ${hechas.length}'),
                  children: [
                    for (final t in hechas) _TareaTile(tarea: t, onPlan: null),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TareaTile extends ConsumerWidget {
  const _TareaTile({required this.tarea, required this.onPlan});

  final TaskRow tarea;

  /// Abre el sheet de Ahora/Siguiente/Después + tamaño; null en las hechas.
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(projectRepositoryProvider);
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    final hecha = tarea.status == TaskStatus.completed.name;
    final enCurso = tarea.status == TaskStatus.inProgress.name;
    final enAhora = !hecha && tarea.horizon.toTaskHorizon() == TaskHorizon.now;
    final size = tarea.size.toTaskSize();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: enAhora
            ? BorderSide(color: atencion.withValues(alpha: 0.5))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushTaskDetail(context, tarea.id),
        onLongPress: () =>
            copiarTexto(context, tituloYCuerpo(tarea.title, tarea.description)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              Checkbox(
                value: hecha,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (_) => repo.toggleDone(tarea),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarea.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: hecha ? TextDecoration.lineThrough : null,
                        color: hecha
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    if (enCurso)
                      Text(
                        'En curso',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: atencion,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              if (size != null && !hecha)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    size.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (onPlan != null)
                IconButton(
                  icon: const Icon(AppIcons.mas),
                  tooltip: 'Cuándo y cuánto tiempo',
                  onPressed: onPlan,
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotasTab extends ConsumerStatefulWidget {
  const _NotasTab({required this.projectId});

  final String projectId;

  @override
  ConsumerState<_NotasTab> createState() => _NotasTabState();
}

class _NotasTabState extends ConsumerState<_NotasTab> {
  bool _esIdea = false;

  Future<void> _nuevoDocumento(BuildContext context) async {
    final titulo = await pedirNuevoTexto(
      context,
      titulo: 'Nuevo documento',
      actual: '',
      maxLength: 200,
    );
    if (titulo == null || !context.mounted) return;
    final id = await ref
        .read(projectRepositoryProvider)
        .addDocument(widget.projectId, titulo);
    // Se abre para escribirlo (el contenido arranca en modo edición).
    if (context.mounted) pushEntityDetail(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(projectRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<ProjectNoteItem>>(
      stream: repo.watchNotes(widget.projectId),
      builder: (context, snapshot) {
        final todas = snapshot.data ?? const <ProjectNoteItem>[];
        final documentos = todas.where((n) => n.isDocument).toList();
        final items = todas.where((n) => !n.isDocument).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            Row(
              children: [
                Expanded(
                  child: _TituloSeccion(
                    texto: 'Documentos',
                    icono: AppIcons.documento,
                    cantidad: documentos.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextButton.icon(
                    icon: const Icon(AppIcons.agregar, size: 18),
                    label: const Text('Nuevo'),
                    onPressed: () => _nuevoDocumento(context),
                  ),
                ),
              ],
            ),
            if (documentos.isEmpty)
              const EstadoVacio(
                texto:
                    'Especificaciones, guías, decisiones… lo que quieras '
                    'tener a mano. Se escriben en Markdown.',
                icono: AppIconsDuo.documento,
              )
            else
              for (final d in documentos) _DocumentoCard(item: d),
            _TituloSeccion(
              texto: 'Observaciones e ideas',
              icono: AppIcons.idea,
              cantidad: items.length,
            ),
            _CampoRapido(
              colapsado: 'Nueva observación o idea',
              hint: _esIdea ? 'Anotar una idea…' : 'Anotar algo que notaste…',
              onSubmit: (texto) =>
                  repo.addObservation(widget.projectId, texto, idea: _esIdea),
              debajo: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: false, label: Text('Observación')),
                    ButtonSegment(value: true, label: Text('Idea')),
                  ],
                  selected: {_esIdea},
                  onSelectionChanged: (s) => setState(() => _esIdea = s.first),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cosas que notaste y aún no sabes cómo resolver. Cuando lo '
              'tengas claro, conviértelas en tarea.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const EstadoVacio(
                texto: 'Nada pendiente por pensar.',
                icono: AppIconsDuo.idea,
              )
            else
              for (final item in items)
                _ObservacionCard(projectId: widget.projectId, item: item),
          ],
        );
      },
    );
  }
}

class _ObservacionCard extends ConsumerWidget {
  const _ObservacionCard({required this.projectId, required this.item});

  final String projectId;
  final ProjectNoteItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorTipo = item.isIdea
        ? context.octoColors.enCurso
        : theme.colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushEntityDetail(context, item.note.id),
        onLongPress: () => copiarTexto(context, item.note.title),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: colorTipo),
                    ),
                    child: Text(
                      item.isIdea ? 'Idea' : 'Observación',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorTipo,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _haceCuanto(item.note.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(item.note.title, style: theme.textTheme.bodyLarge),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(AppIcons.flechaDerecha, size: 18),
                  label: const Text('Convertir en tarea'),
                  onPressed: () {
                    ref
                        .read(projectRepositoryProvider)
                        .convertToTask(projectId, item.note);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ahora es una tarea del proyecto'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _haceCuanto(DateTime fecha) {
  final hoy = DateTime.now();
  final dias = DateTime(
    hoy.year,
    hoy.month,
    hoy.day,
  ).difference(DateTime(fecha.year, fecha.month, fecha.day)).inDays;
  if (dias <= 0) return 'hoy';
  if (dias == 1) return 'ayer';
  if (dias < 7) return 'hace $dias días';
  if (dias < 14) return 'hace 1 semana';
  if (dias < 60) return 'hace ${dias ~/ 7} semanas';
  return '${fecha.day}/${fecha.month}/${fecha.year}';
}

class _RequisitosTab extends ConsumerWidget {
  const _RequisitosTab({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(projectRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<TaskRow>>(
      stream: repo.watchRequirements(projectId),
      builder: (context, snapshot) {
        final reqs = (snapshot.data ?? const <TaskRow>[])
            .where((r) => r.status != TaskStatus.cancelled.name)
            .toList();
        final cumplidos = reqs
            .where((r) => r.status == TaskStatus.completed.name)
            .length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$cumplidos de ${reqs.length}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'cumplidos',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: reqs.isEmpty ? 0 : cumplidos / reqs.length,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lo que el proyecto tiene que lograr. No se "hacen": '
                      'se cumplen gracias a las tareas.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CampoRapido(
              colapsado: 'Nuevo requisito',
              hint: 'Nuevo requisito…',
              onSubmit: (texto) => repo.addRequirement(projectId, texto),
            ),
            const SizedBox(height: 12),
            if (reqs.isEmpty)
              const EstadoVacio(
                texto: 'Sin requisitos todavía. Ej: "Funciona sin internet".',
                icono: AppIconsDuo.requisito,
              )
            else
              for (final r in reqs) _RequisitoTile(requisito: r),
          ],
        );
      },
    );
  }
}

class _RequisitoTile extends ConsumerWidget {
  const _RequisitoTile({required this.requisito});

  final TaskRow requisito;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cumplido = requisito.status == TaskStatus.completed.name;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushTaskDetail(context, requisito.id),
        onLongPress: () => copiarTexto(
          context,
          tituloYCuerpo(requisito.title, requisito.description),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 14, 2),
          child: Row(
            children: [
              Checkbox(
                value: cumplido,
                shape: const CircleBorder(),
                onChanged: (_) =>
                    ref.read(projectRepositoryProvider).toggleDone(requisito),
              ),
              Expanded(
                child: Text(
                  requisito.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cumplido ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                ),
              ),
              Text(
                cumplido ? 'Cumplido' : 'Pendiente',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cumplido
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentoCard extends StatelessWidget {
  const _DocumentoCard({required this.item});

  final ProjectNoteItem item;

  /// Primeras líneas con texto, sin la sintaxis de Markdown más ruidosa.
  String? get _vistaPrevia {
    final lineas = (item.content ?? '')
        .split('\n')
        .map((l) => l.replaceAll(RegExp(r'^[#>\-\*\s\[\]x]+'), '').trim())
        .where((l) => l.isNotEmpty && !l.startsWith('```'))
        .take(2)
        .join(' · ');
    return lineas.isEmpty ? null : lineas;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previa = _vistaPrevia;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushEntityDetail(context, item.note.id),
        onLongPress: () =>
            copiarTexto(context, tituloYCuerpo(item.note.title, item.content)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppIcons.documento, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.note.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      previa ?? 'Vacío — toca para escribir',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                AppIcons.caretDerecha,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Todo lo que rodea al proyecto: de qué se trata (Markdown) y con qué está
/// conectado — Meta/Área, Recursos, Personas, otras conexiones.
class _ContextoTab extends ConsumerWidget {
  const _ContextoTab({required this.summary});

  final ProjectSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(projectRepositoryProvider);
    final entityRepo = ref.watch(entityRepositoryProvider);
    final projectId = summary.entity.id;

    return StreamBuilder<List<ProjectContextItem>>(
      stream: repo.watchContext(projectId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ProjectContextItem>[];
        List<ProjectContextItem> de(ProjectContextGroup g) =>
            items.where((i) => i.group == g).toList();

        Widget grupo(
          String titulo,
          ProjectContextGroup g,
          String vacio, {
          bool siempre = true,
        }) {
          final lista = de(g);
          if (!siempre && lista.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TituloSeccion(
                      texto: titulo,
                      icono: switch (g) {
                        ProjectContextGroup.belongsTo => AppIcons.meta,
                        ProjectContextGroup.resources => AppIcons.recurso,
                        ProjectContextGroup.people => AppIcons.personas,
                        ProjectContextGroup.other => AppIcons.conexiones,
                      },
                      cantidad: lista.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextButton.icon(
                      icon: const Icon(AppIcons.conectar, size: 18),
                      label: const Text('Conectar'),
                      onPressed: () =>
                          mostrarAgregarRelacionSheet(context, ref, projectId),
                    ),
                  ),
                ],
              ),
              if (lista.isEmpty)
                EstadoVacio(texto: vacio)
              else
                for (final item in lista)
                  _ConexionTile(
                    item: item,
                    onQuitar: () => repo.disconnect(item.relationId),
                  ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            MarkdownField(
              label: 'Sobre el proyecto',
              value: summary.entity.description,
              tituloLectura: summary.entity.title,
              hint:
                  'De qué se trata, para qué es, decisiones importantes… '
                  '(soporta Markdown)',
              onSave: (v) => entityRepo.updateDescription(projectId, v),
              enlaces: enlacesWiki(context, ref),
            ),
            grupo(
              'Pertenece a',
              ProjectContextGroup.belongsTo,
              'Conéctalo a la Meta o el Área que empuja.',
            ),
            grupo(
              'Recursos',
              ProjectContextGroup.resources,
              'Cursos, repos, videos, enlaces que usas en este proyecto.',
            ),
            grupo(
              'Personas',
              ProjectContextGroup.people,
              'Quién colabora, quién te inspira, a quién le preguntas.',
            ),
            grupo(
              'Otras conexiones',
              ProjectContextGroup.other,
              '',
              siempre: false,
            ),
            MencionesSection(entity: summary.entity),
          ],
        );
      },
    );
  }
}

class _ConexionTile extends StatelessWidget {
  const _ConexionTile({required this.item, required this.onQuitar});

  final ProjectContextItem item;
  final VoidCallback onQuitar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = item.entity.type.toEntityType();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(AppIcons.deTipo(type), color: theme.colorScheme.primary),
        title: Text(item.entity.title),
        subtitle: Text(
          type.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () => pushEntityDetail(context, item.entity.id),
        onLongPress: () => copiarTexto(context, item.entity.title),
        trailing: IconButton(
          icon: const Icon(AppIcons.desconectar),
          tooltip: 'Quitar conexión',
          onPressed: onQuitar,
        ),
      ),
    );
  }
}
