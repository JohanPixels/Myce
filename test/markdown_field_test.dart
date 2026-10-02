import 'package:flutter_test/flutter_test.dart';
import 'package:octo_dash/core/widgets/markdown_field.dart';

void main() {
  test('el índice toma #, ## y ### pero ignora lo que hay dentro de bloques de código', () {
    const md = '''
Intro sin título

# Uno
texto
## Uno punto uno
```
# esto es un comentario de bash, no un título
```
### Detalle
#### Muy profundo (no entra al índice)
# Dos
''';
    expect(titulosMarkdown(md), [
      (1, 'Uno'),
      (2, 'Uno punto uno'),
      (3, 'Detalle'),
      (1, 'Dos'),
    ]);
  });

  test('sin títulos, el índice queda vacío', () {
    expect(titulosMarkdown('solo texto\n\n- una lista'), isEmpty);
  });
}
