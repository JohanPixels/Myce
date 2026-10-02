import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// Campo de texto largo en Markdown con dos modos: **vista previa** (por
/// defecto si ya hay contenido) y **edición**. Pensado para textos largos
/// (recursos, notas): la vista previa vive en una caja con scroll propio y
/// alto máximo — se scrollea solo el texto, y tocando/deslizando fuera de la
/// caja se sigue con el resto de la pantalla — más un índice de títulos y
/// lectura a pantalla completa.
class MarkdownField extends StatefulWidget {
  const MarkdownField({
    super.key,
    required this.label,
    required this.value,
    required this.onSave,
    this.hint = 'Escribe aquí… (soporta Markdown)',
    this.tituloLectura,
  });

  final String label;
  final String? value;

  /// Recibe el texto ya recortado, o null si quedó vacío.
  final Future<void> Function(String? nuevo) onSave;
  final String hint;

  /// Título de la pantalla completa de lectura (ej. el nombre del recurso).
  final String? tituloLectura;

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  late bool _editando = (widget.value ?? '').trim().isEmpty;
  final _controller = TextEditingController();
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(MarkdownField old) {
    super.didUpdateWidget(old);
    // Llegó un valor nuevo (otro dispositivo, o se acaba de guardar) y no
    // hay edición local en curso: se refleja en el editor.
    if (!_dirty && _controller.text != (widget.value ?? '')) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final texto = _controller.text.trim();
    await widget.onSave(texto.isEmpty ? null : texto);
    if (!mounted) return;
    setState(() {
      _dirty = false;
      if (texto.isNotEmpty) _editando = false;
    });
  }

  void _descartar() {
    setState(() {
      _controller.text = widget.value ?? '';
      _dirty = false;
      if ((widget.value ?? '').trim().isNotEmpty) _editando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texto = widget.value ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(widget.label, style: theme.textTheme.titleMedium),
            ),
            SegmentedButton<bool>(
              showSelectedIcon: false,
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.visibility_outlined, size: 18),
                  tooltip: 'Vista previa',
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Editar',
                ),
              ],
              selected: {_editando},
              onSelectionChanged: (s) => setState(() => _editando = s.first),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_editando)
          _Editor(
            controller: _controller,
            hint: widget.hint,
            onChanged: () {
              if (!_dirty) setState(() => _dirty = true);
            },
          )
        else if (texto.trim().isEmpty)
          _Vacio(onTap: () => setState(() => _editando = true))
        else
          _VistaPrevia(
            texto: texto,
            onPantallaCompleta: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MarkdownLecturaScreen(
                  titulo: widget.tituloLectura ?? widget.label,
                  texto: texto,
                ),
              ),
            ),
          ),
        if (_dirty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: _descartar, child: const Text('Descartar')),
              const SizedBox(width: 8),
              FilledButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ],
      ],
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Text(
          'Vacío. Toca para escribir.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Editor con su propio scroll (alto acotado) y una barra mínima para lo
/// que cuesta escribir en el teclado del celular: título, negrita, lista y
/// casilla.
class _Editor extends StatelessWidget {
  const _Editor({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  /// Pone [prefijo] al inicio de la línea donde está el cursor.
  void _prefijarLinea(String prefijo) {
    final texto = controller.text;
    final sel = controller.selection;
    final pos = sel.isValid ? sel.start : texto.length;
    final inicio = pos == 0 ? 0 : texto.lastIndexOf('\n', pos - 1) + 1;
    controller.value = TextEditingValue(
      text: texto.replaceRange(inicio, inicio, prefijo),
      selection: TextSelection.collapsed(offset: pos + prefijo.length),
    );
    onChanged();
  }

  /// Envuelve la selección con [marca] (ej. `**` para negrita).
  void _envolver(String marca) {
    final texto = controller.text;
    final sel = controller.selection;
    if (!sel.isValid) return;
    final elegido = sel.textInside(texto);
    controller.value = TextEditingValue(
      text: texto.replaceRange(sel.start, sel.end, '$marca$elegido$marca'),
      selection: elegido.isEmpty
          ? TextSelection.collapsed(offset: sel.start + marca.length)
          : TextSelection(
              baseOffset: sel.start + marca.length,
              extentOffset: sel.end + marca.length,
            ),
    );
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.title),
              tooltip: 'Título',
              onPressed: () => _prefijarLinea('## '),
            ),
            IconButton(
              icon: const Icon(Icons.format_bold),
              tooltip: 'Negrita',
              onPressed: () => _envolver('**'),
            ),
            IconButton(
              icon: const Icon(Icons.format_list_bulleted),
              tooltip: 'Lista',
              onPressed: () => _prefijarLinea('- '),
            ),
            IconButton(
              icon: const Icon(Icons.check_box_outlined),
              tooltip: 'Casilla',
              onPressed: () => _prefijarLinea('- [ ] '),
            ),
          ],
        ),
        TextField(
          controller: controller,
          minLines: 8,
          maxLines: 18,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: hint),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

/// Un trozo del documento que empieza en un título (`#`, `##`, `###`) —
/// cada uno se dibuja con su propia `GlobalKey` para poder saltar a él
/// desde el índice.
class _Seccion {
  _Seccion(this.titulo, this.nivel, this.texto);

  final String? titulo;
  final int nivel;
  final String texto;
  final key = GlobalKey();
}

final _reTitulo = RegExp(r'^(#{1,3})\s+(.+?)\s*#*\s*$');

/// Títulos del índice (nivel, texto), en orden — expuesto para tests.
@visibleForTesting
List<(int, String)> titulosMarkdown(String md) => [
  for (final s in _dividir(md))
    if (s.titulo != null) (s.nivel, s.titulo!),
];

List<_Seccion> _dividir(String md) {
  final secciones = <_Seccion>[];
  String? titulo;
  var nivel = 0;
  final buffer = StringBuffer();
  var enBloqueCodigo = false;

  void cerrar() {
    final texto = buffer.toString();
    if (titulo != null || texto.trim().isNotEmpty) {
      secciones.add(_Seccion(titulo, nivel, texto));
    }
    buffer.clear();
  }

  for (final linea in md.split('\n')) {
    final recortada = linea.trimLeft();
    if (recortada.startsWith('```') || recortada.startsWith('~~~')) {
      enBloqueCodigo = !enBloqueCodigo;
    }
    final m = enBloqueCodigo ? null : _reTitulo.firstMatch(linea);
    if (m != null) {
      cerrar();
      titulo = m.group(2);
      nivel = m.group(1)!.length;
    }
    buffer.writeln(linea);
  }
  cerrar();
  return secciones;
}

MarkdownStyleSheet _estilo(BuildContext context) {
  final theme = Theme.of(context);
  return MarkdownStyleSheet.fromTheme(theme).copyWith(
    p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
    h1: theme.textTheme.headlineSmall,
    h2: theme.textTheme.titleLarge,
    h3: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    blockSpacing: 12,
    code: theme.textTheme.bodyMedium?.copyWith(
      fontFamily: 'monospace',
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    ),
    codeblockDecoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
    ),
    blockquoteDecoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

/// Las secciones una debajo de otra, cada una seleccionable para copiar.
class _Documento extends StatelessWidget {
  const _Documento({required this.secciones});

  final List<_Seccion> secciones;

  @override
  Widget build(BuildContext context) {
    final estilo = _estilo(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in secciones)
          Padding(
            key: s.key,
            padding: const EdgeInsets.only(bottom: 4),
            child: MarkdownBody(
              data: s.texto,
              selectable: true,
              styleSheet: estilo,
            ),
          ),
      ],
    );
  }
}

Future<void> _mostrarIndice(BuildContext context, List<_Seccion> secciones) {
  final conTitulo = secciones.where((s) => s.titulo != null).toList();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.7,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text('Índice', style: Theme.of(ctx).textTheme.titleLarge),
          ),
          for (final s in conTitulo)
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 20.0 + (s.nivel - 1) * 16,
                right: 20,
              ),
              title: Text(
                s.titulo!,
                style: s.nivel == 1
                    ? const TextStyle(fontWeight: FontWeight.w800)
                    : null,
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                final destino = s.key.currentContext;
                if (destino != null) {
                  Scrollable.ensureVisible(
                    destino,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
            ),
        ],
      ),
    ),
  );
}

/// Vista previa dentro de una caja de alto acotado con scroll propio.
class _VistaPrevia extends StatefulWidget {
  const _VistaPrevia({required this.texto, required this.onPantallaCompleta});

  final String texto;
  final VoidCallback onPantallaCompleta;

  @override
  State<_VistaPrevia> createState() => _VistaPreviaState();
}

class _VistaPreviaState extends State<_VistaPrevia> {
  final _scroll = ScrollController();
  late List<_Seccion> _secciones = _dividir(widget.texto);

  @override
  void didUpdateWidget(_VistaPrevia old) {
    super.didUpdateWidget(old);
    if (old.texto != widget.texto) _secciones = _dividir(widget.texto);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titulos = _secciones.where((s) => s.titulo != null).length;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: Scrollbar(
              controller: _scroll,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 14, 20, 14),
                child: _Documento(secciones: _secciones),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                if (titulos >= 2)
                  TextButton.icon(
                    icon: const Icon(Icons.toc, size: 20),
                    label: Text('Índice ($titulos)'),
                    onPressed: () => _mostrarIndice(context, _secciones),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.open_in_full, size: 20),
                  tooltip: 'Leer en pantalla completa',
                  onPressed: widget.onPantallaCompleta,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lectura cómoda de un texto largo: pantalla completa, con el índice en
/// la barra superior.
class MarkdownLecturaScreen extends StatefulWidget {
  const MarkdownLecturaScreen({
    super.key,
    required this.titulo,
    required this.texto,
  });

  final String titulo;
  final String texto;

  @override
  State<MarkdownLecturaScreen> createState() => _MarkdownLecturaScreenState();
}

class _MarkdownLecturaScreenState extends State<MarkdownLecturaScreen> {
  late final _secciones = _dividir(widget.texto);

  @override
  Widget build(BuildContext context) {
    final titulos = _secciones.where((s) => s.titulo != null).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, overflow: TextOverflow.ellipsis),
        actions: [
          if (titulos >= 2)
            IconButton(
              icon: const Icon(Icons.toc),
              tooltip: 'Índice',
              onPressed: () => _mostrarIndice(context, _secciones),
            ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
          child: _Documento(secciones: _secciones),
        ),
      ),
    );
  }
}
