enum EntityType { project, area, resource, note, person, hobby, goal }

enum EntityStatus { active, paused, someday, archived }

extension EntityTypeParsing on String {
  EntityType toEntityType() => EntityType.values.byName(this);
}

extension EntityStatusParsing on String {
  EntityStatus toEntityStatus() => EntityStatus.values.byName(this);
}

extension EntityTypeLabel on EntityType {
  String get label => switch (this) {
    EntityType.project => 'Proyecto',
    EntityType.area => 'Área',
    EntityType.resource => 'Recurso',
    EntityType.note => 'Nota',
    EntityType.person => 'Persona',
    EntityType.hobby => 'Hobby',
    EntityType.goal => 'Meta',
  };
}
