import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/domain/task_enums.dart';
import '../../core/database/app_database.dart';
import '../../core/navigation/navigation_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/project_palette.dart';
import '../../entities/domain/entity_type.dart';
import '../data/project_repository.dart';
import '../data/project_repository_provider.dart';
import 'project_appearance_sheet.dart';
import 'project_avatar.dart';

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

        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                tooltip: 'Más opciones',
                onSelected: (accion) {
                  if (accion == 'apariencia') editarApariencia();
                  if (accion == 'detalles') {
                    pushEntityDetail(context, projectId, generic: true);
                  }
                },
                itemBuilder: (_) => const [
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
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverToBoxAdapter(
                  child: _Cabecera(
                    summary: summary,
                    onTapAvatar: editarApariencia,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      indicatorColor: projectColor(
                        context,
                        summary.project?.color,
                      ),
                      tabs: const [
                        Tab(text: 'Tareas'),
                        Tab(text: 'Observaciones'),
                        Tab(text: 'Requisitos'),
                      ],
                    ),
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  _TareasTab(projectId: projectId),
                  _ObservacionesTab(projectId: projectId),
                  _RequisitosTab(projectId: projectId),
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
  const _Cabecera({required this.summary, required this.onTapAvatar});

  final ProjectSummary summary;
  final VoidCallback onTapAvatar;

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
                    Text(
                      entity.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entity.status.toEntityStatus().label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
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
        ],
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
  const _CampoRapido({required this.hint, required this.onSubmit, this.debajo});

  final String hint;
  final void Function(String texto) onSubmit;
  final Widget? debajo;

  @override
  State<_CampoRapido> createState() => _CampoRapidoState();
}

class _CampoRapidoState extends State<_CampoRapido> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    widget.onSubmit(texto);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _enviar(),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Agregar',
              onPressed: _enviar,
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
  });

  final String texto;
  final int cantidad;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          if (color != null) ...[
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
        ],
      ),
    );
  }
}

class _TareasTab extends ConsumerWidget {
  const _TareasTab({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(projectRepositoryProvider);
    final atencion = context.octoColors.enCurso;

    return StreamBuilder<List<TaskRow>>(
      stream: repo.watchTasks(projectId),
      builder: (context, snapshot) {
        final tareas = snapshot.data ?? const <TaskRow>[];
        final enCurso = tareas
            .where((t) => t.status == TaskStatus.inProgress.name)
            .toList();
        final pendientes = tareas
            .where((t) => t.status == TaskStatus.pending.name)
            .toList();
        final hechas = tareas
            .where((t) => t.status == TaskStatus.completed.name)
            .toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            _CampoRapido(
              hint: 'Nueva tarea…',
              onSubmit: (texto) => repo.addTask(projectId, texto),
            ),
            if (enCurso.isNotEmpty) ...[
              _TituloSeccion(
                texto: 'En curso',
                cantidad: enCurso.length,
                color: atencion,
              ),
              for (final t in enCurso) _TareaTile(tarea: t),
            ],
            _TituloSeccion(texto: 'Pendientes', cantidad: pendientes.length),
            if (pendientes.isEmpty)
              const _Vacio(texto: 'Nada pendiente. Anota la próxima acción.')
            else
              for (final t in pendientes) _TareaTile(tarea: t),
            if (hechas.isNotEmpty)
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Hechas · ${hechas.length}'),
                  children: [for (final t in hechas) _TareaTile(tarea: t)],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TareaTile extends ConsumerWidget {
  const _TareaTile({required this.tarea});

  final TaskRow tarea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(projectRepositoryProvider);
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;
    final hecha = tarea.status == TaskStatus.completed.name;
    final enCurso = tarea.status == TaskStatus.inProgress.name;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: enCurso
            ? BorderSide(color: atencion.withValues(alpha: 0.5))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushTaskDetail(context, tarea.id),
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
                child: Text(
                  tarea.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: hecha ? TextDecoration.lineThrough : null,
                    color: hecha ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                ),
              ),
              if (!hecha)
                IconButton(
                  icon: Icon(
                    enCurso ? Icons.bolt : Icons.bolt_outlined,
                    color: enCurso ? atencion : null,
                  ),
                  tooltip: enCurso ? 'Quitar de en curso' : 'Empezar ahora',
                  onPressed: () => repo.toggleInProgress(tarea),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        texto,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ObservacionesTab extends ConsumerStatefulWidget {
  const _ObservacionesTab({required this.projectId});

  final String projectId;

  @override
  ConsumerState<_ObservacionesTab> createState() => _ObservacionesTabState();
}

class _ObservacionesTabState extends ConsumerState<_ObservacionesTab> {
  bool _esIdea = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(projectRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<ProjectNoteItem>>(
      stream: repo.watchObservations(widget.projectId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ProjectNoteItem>[];
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            _CampoRapido(
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
              const _Vacio(texto: 'Nada pendiente por pensar.')
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
                  icon: const Icon(Icons.arrow_forward, size: 18),
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
              hint: 'Nuevo requisito…',
              onSubmit: (texto) => repo.addRequirement(projectId, texto),
            ),
            const SizedBox(height: 12),
            if (reqs.isEmpty)
              const _Vacio(
                texto: 'Sin requisitos todavía. Ej: "Funciona sin internet".',
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
