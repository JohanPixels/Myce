import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../activities/domain/task_enums.dart';
import '../../activities/presentation/task_plan_sheet.dart';
import '../../core/theme/app_theme.dart';
import '../data/focus_repository.dart';
import '../data/focus_repository_provider.dart';
import 'task_tile.dart';

/// Cuántas tareas de "Siguiente" se muestran antes de "Ver todas".
const _siguienteVisibles = 5;

/// Sección "Ahora": qué hacer, de toda la app, sin entrar proyecto por
/// proyecto. Es la pantalla con la que abre Myce.
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  /// Tiempo disponible ("tengo…"); null = sin límite.
  TaskSize? _tengo;
  bool _verTodoSiguiente = false;
  final _captura = TextEditingController();

  @override
  void dispose() {
    _captura.dispose();
    super.dispose();
  }

  void _agregar() {
    final texto = _captura.text.trim();
    if (texto.isEmpty) return;
    // UI optimista: tarea suelta directo a Ahora, sin esperar a la base.
    ref
        .read(taskRepositoryProvider)
        .create(title: texto, horizon: TaskHorizon.now);
    _captura.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atencion = context.octoColors.enCurso;

    return StreamBuilder<List<FocusItem>>(
      stream: ref.watch(focusRepositoryProvider).watchOpenTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final todas = snapshot.data!;
        final visibles = todas
            .where((i) => cabeEnElTiempo(i.task.size.toTaskSize(), _tengo))
            .toList();
        final ocultasSinEstimar = _tengo == null
            ? 0
            : todas.where((i) => i.task.size == null).length;
        List<FocusItem> de(TaskHorizon h) =>
            visibles.where((i) => i.task.horizon.toTaskHorizon() == h).toList();
        final ahora = de(TaskHorizon.now);
        final siguiente = de(TaskHorizon.next);
        final despues = de(TaskHorizon.later);
        final siguienteMostradas = _verTodoSiguiente
            ? siguiente
            : siguiente.take(_siguienteVisibles).toList();

        /// Para el aviso de "máx. 3 en Ahora": cuenta las de su mismo
        /// proyecto (o todas las sueltas, si es suelta).
        int otrasEnAhora(FocusItem item) => todas
            .where(
              (o) =>
                  o.task.id != item.task.id &&
                  o.task.horizon.toTaskHorizon() == TaskHorizon.now &&
                  o.entity?.id == item.entity?.id,
            )
            .length;

        Widget tile(FocusItem item) => TaskTile(
          item: item,
          onPlan: () => mostrarPlanTareaSheet(
            context,
            ref,
            item.task,
            tareasEnAhora: otrasEnAhora(item),
          ),
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            TextField(
              controller: _captura,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _agregar(),
              decoration: InputDecoration(
                hintText: 'Algo para hacer ahora…',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Agregar a Ahora',
                  onPressed: _agregar,
                ),
              ),
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
                  '$ocultasSinEstimar sin tiempo estimado no se muestran.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

            _Titulo(texto: 'Ahora', cantidad: ahora.length, color: atencion),
            if (ahora.isEmpty)
              _Vacio(
                texto: _tengo != null
                    ? 'Nada en Ahora que quepa en ese tiempo.'
                    : siguiente.isEmpty
                    ? 'Nada pendiente. Disfruta el rato 🌱'
                    : 'Nada en Ahora. Elige algo de Siguiente con ⋯ → Ahora.',
              )
            else
              for (final i in ahora) tile(i),

            if (siguiente.isNotEmpty) ...[
              _Titulo(
                texto: 'Siguiente',
                cantidad: siguiente.length,
                color: theme.colorScheme.primary,
              ),
              for (final i in siguienteMostradas) tile(i),
              if (siguiente.length > _siguienteVisibles)
                TextButton(
                  onPressed: () =>
                      setState(() => _verTodoSiguiente = !_verTodoSiguiente),
                  child: Text(
                    _verTodoSiguiente
                        ? 'Ver menos'
                        : 'Ver todas (${siguiente.length})',
                  ),
                ),
            ],

            if (despues.isNotEmpty)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Después · ${despues.length}'),
                  children: [for (final i in despues) tile(i)],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo({
    required this.texto,
    required this.cantidad,
    required this.color,
  });

  final String texto;
  final int cantidad;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
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
