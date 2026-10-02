import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'copiar.dart';
import '../theme/app_icons.dart';

/// Cómo se resuelven los enlaces `[[Otra nota]]` dentro de un
/// [MarkdownField] — lo provee quien conoce la base (ver
/// `links/presentation/wiki_links.dart`); sin esto, `[[...]]` se ve como
/// texto plano y el editor no sugiere nada.
class MarkdownEnlaces {
  const MarkdownEnlaces({required this.sugerir, required this.abrir});

  /// Títulos que coinciden con lo escrito después de `[[`.
  final Future<List<String>> Function(String query) sugerir;

  /// Tocar un `[[Título]]` en la vista previa.
  final void Function(String titulo) abrir;
}

final _reEnlaceWiki = RegExp(r'\[\[([^\[\]\n]+)\]\]');
const _esquemaWiki = 'wiki:';

/// `[[Título]]` → link Markdown normal con un esquema propio, para que
/// `MarkdownBody` lo dibuje como enlace tocable. No toca bloques de código.
@visibleForTesting
String conEnlacesWikiParaTest(String md) => _conEnlacesWiki(md);

String _conEnlacesWiki(String md) {
  var enCodigo = false;
  return md
      .split('\n')
      .map((linea) {
        final t = linea.trimLeft();
        if (t.startsWith('```') || t.startsWith('~~~')) enCodigo = !enCodigo;
        if (enCodigo) return linea;
        return linea.replaceAllMapped(
          _reEnlaceWiki,
          (m) => '[${m[1]}]($_esquemaWiki${Uri.encodeComponent(m[1]!.trim())})',
        );
      })
      .join('\n');
}

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
    this.enlaces,
  });

  final String label;
  final String? value;

  /// Recibe el texto ya recortado, o null si quedó vacío.
  final Future<void> Function(String? nuevo) onSave;
  final String hint;

  /// Título de la pantalla completa de lectura (ej. el nombre del recurso).
  final String? tituloLectura;

  /// Habilita `[[enlaces]]`: sugerencias al escribir y tocar para abrir.
  final MarkdownEnlaces? enlaces;

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
                  icon: Icon(AppIcons.vistaPrevia, size: 18),
                  tooltip: 'Vista previa',
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(AppIcons.editar, size: 18),
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
            enlaces: widget.enlaces,
            onChanged: () {
              if (!_dirty) setState(() => _dirty = true);
            },
          )
        else if (texto.trim().isEmpty)
          _Vacio(onTap: () => setState(() => _editando = true))
        else
          _VistaPrevia(
            texto: texto,
            enlaces: widget.enlaces,
            onPantallaCompleta: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MarkdownLecturaScreen(
                  titulo: widget.tituloLectura ?? widget.label,
                  texto: texto,
                  enlaces: widget.enlaces,
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
/// que cuesta escribir en el teclado del celular: título, negrita, lista,
/// casilla y enlace. Si hay [enlaces], al escribir `[[` aparece una fila de
/// sugerencias con títulos existentes.
class _Editor extends StatefulWidget {
  const _Editor({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.enlaces,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;
  final MarkdownEnlaces? enlaces;

  @override
  State<_Editor> createState() => _EditorState();
}

/// `[[` abierto sin cerrar justo antes del cursor.
final _reEnlaceAbierto = RegExp(r'\[\[([^\[\]\n]*)$');

class _EditorState extends State<_Editor> {
  TextEditingController get controller => widget.controller;

  /// Lo escrito después de `[[` (null = no se está escribiendo un enlace).
  String? _consulta;
  Future<List<String>>? _sugerencias;

  @override
  void initState() {
    super.initState();
    controller.addListener(_revisarEnlace);
  }

  @override
  void dispose() {
    controller.removeListener(_revisarEnlace);
    super.dispose();
  }

  void _revisarEnlace() {
    final enlaces = widget.enlaces;
    if (enlaces == null) return;
    final sel = controller.selection;
    String? consulta;
    if (sel.isValid && sel.isCollapsed) {
      final antes = controller.text.substring(0, sel.start);
      consulta = _reEnlaceAbierto.firstMatch(antes)?.group(1);
    }
    if (consulta == _consulta) return;
    setState(() {
      _consulta = consulta;
      _sugerencias = consulta == null ? null : enlaces.sugerir(consulta);
    });
  }

  /// Completa el `[[…` abierto con `[[titulo]]`.
  void _completar(String titulo) {
    final texto = controller.text;
    final pos = controller.selection.start;
    final inicio = texto.lastIndexOf('[[', pos);
    final enlace = '[[$titulo]]';
    controller.value = TextEditingValue(
      text: texto.replaceRange(inicio, pos, enlace),
      selection: TextSelection.collapsed(offset: inicio + enlace.length),
    );
    widget.onChanged();
  }

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
    widget.onChanged();
  }

  /// Envuelve la selección con [abre]/[cierra] (ej. `**` para negrita).
  void _envolver(String abre, [String? cierra]) {
    final texto = controller.text;
    final sel = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: texto.length);
    final fin = cierra ?? abre;
    final elegido = sel.textInside(texto);
    controller.value = TextEditingValue(
      text: texto.replaceRange(sel.start, sel.end, '$abre$elegido$fin'),
      selection: elegido.isEmpty
          ? TextSelection.collapsed(offset: sel.start + abre.length)
          : TextSelection(
              baseOffset: sel.start + abre.length,
              extentOffset: sel.end + abre.length,
            ),
    );
    widget.onChanged();
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
              icon: const Icon(AppIcons.titulo),
              tooltip: 'Título',
              onPressed: () => _prefijarLinea('## '),
            ),
            IconButton(
              icon: const Icon(AppIcons.negrita),
              tooltip: 'Negrita',
              onPressed: () => _envolver('**'),
            ),
            IconButton(
              icon: const Icon(AppIcons.lista),
              tooltip: 'Lista',
              onPressed: () => _prefijarLinea('- '),
            ),
            IconButton(
              icon: const Icon(AppIcons.casilla),
              tooltip: 'Casilla',
              onPressed: () => _prefijarLinea('- [ ] '),
            ),
            if (widget.enlaces != null)
              IconButton(
                icon: const Icon(AppIcons.enlace),
                tooltip: 'Enlazar a otra nota ([[ ]])',
                onPressed: () => _envolver('[[', ']]'),
              ),
          ],
        ),
        if (_sugerencias != null)
          FutureBuilder<List<String>>(
            future: _sugerencias,
            builder: (context, snapshot) {
              final titulos = snapshot.data ?? const <String>[];
              final consulta = _consulta?.trim() ?? '';
              final existe = titulos.any(
                (t) => t.toLowerCase() == consulta.toLowerCase(),
              );
              return SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final t in titulos)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          avatar: const Icon(AppIcons.enlace, size: 16),
                          label: Text(t),
                          onPressed: () => _completar(t),
                        ),
                      ),
                    // Enlazar a algo que todavía no existe: se crea al
                    // tocar el enlace en la vista previa.
                    if (consulta.isNotEmpty && !existe)
                      ActionChip(
                        avatar: const Icon(AppIcons.agregar, size: 16),
                        label: Text('Nueva: $consulta'),
                        onPressed: () => _completar(consulta),
                      ),
                  ],
                ),
              );
            },
          ),
        TextField(
          controller: controller,
          minLines: 8,
          maxLines: 18,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: widget.hint),
          onChanged: (_) => widget.onChanged(),
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
  const _Documento({required this.secciones, this.enlaces});

  final List<_Seccion> secciones;
  final MarkdownEnlaces? enlaces;

  void _tocarEnlace(BuildContext context, String? href) {
    if (href == null) return;
    if (href.startsWith(_esquemaWiki)) {
      enlaces?.abrir(Uri.decodeComponent(href.substring(_esquemaWiki.length)));
      return;
    }
    // Sin navegador integrado (url_launcher): el enlace externo se copia
    // para pegarlo donde se quiera.
    copiarTexto(context, href);
  }

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
              data: enlaces == null ? s.texto : _conEnlacesWiki(s.texto),
              onTapLink: (_, href, _) => _tocarEnlace(context, href),
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
  const _VistaPrevia({
    required this.texto,
    required this.onPantallaCompleta,
    this.enlaces,
  });

  final String texto;
  final MarkdownEnlaces? enlaces;
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
                child: _Documento(
                  secciones: _secciones,
                  enlaces: widget.enlaces,
                ),
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
                    icon: const Icon(AppIcons.indice, size: 20),
                    label: Text('Índice ($titulos)'),
                    onPressed: () => _mostrarIndice(context, _secciones),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(AppIcons.pantallaCompleta, size: 20),
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
    this.enlaces,
  });

  final String titulo;
  final String texto;
  final MarkdownEnlaces? enlaces;

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
              icon: const Icon(AppIcons.indice),
              tooltip: 'Índice',
              onPressed: () => _mostrarIndice(context, _secciones),
            ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
          child: _Documento(secciones: _secciones, enlaces: widget.enlaces),
        ),
      ),
    );
  }
}
