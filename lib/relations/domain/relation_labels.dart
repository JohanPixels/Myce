import '../../core/database/app_database.dart';

/// Etiquetas en español de los tipos de relación, por `key`. En la base
/// (local y Supabase) `relation_types.label`/`inverse_label` quedaron en
/// inglés desde la siembra inicial; traducir acá, en la capa de UI, evita
/// tocar filas sembradas y sincronizadas. Un tipo sin traducción cae en el
/// label de la base.
const _etiquetas = <String, (String, String)>{
  'belongs_to': ('Pertenece a', 'Contiene'),
  'uses': ('Usa', 'Usado por'),
  'related_to': ('Relacionado con', 'Relacionado con'),
  'derived_from': ('Derivado de', 'Origen de'),
  'inspired_by': ('Inspirado en', 'Inspira'),
  'relevant_to': ('Relevante para', 'Le es relevante'),
  'supports': ('Apoya', 'Apoyado por'),
  'recommends': ('Recomienda', 'Recomendado por'),
  'contributes_to': ('Contribuye a', 'Recibe aportes de'),
};

extension RelationTypeLabelEs on RelationTypeRow {
  String get labelEs => _etiquetas[key]?.$1 ?? label;
  String get inverseLabelEs => _etiquetas[key]?.$2 ?? inverseLabel;
}
