/// `activity_links.link_type` de una Task que es un Requisito de un
/// Project ("funciona sin internet") y no una acción: se cumple, no se
/// "hace". Reusa Task (status `completed` = cumplido) en vez de crear una
/// tabla nueva — vocabulario de link_type separado del de relation_types
/// (CLAUDE.md, regla 4).
const requirementLinkType = 'requirement';

/// link_type por defecto de una Task vinculada a una Entity.
const partOfLinkType = 'part_of';

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { none, low, medium, high }

extension TaskStatusParsing on String {
  TaskStatus toTaskStatus() => TaskStatus.values.byName(this);
}

extension TaskPriorityParsing on String {
  TaskPriority toTaskPriority() => TaskPriority.values.byName(this);
}

extension TaskStatusLabel on TaskStatus {
  String get label => switch (this) {
    TaskStatus.pending => 'Pendiente',
    TaskStatus.inProgress => 'En curso',
    TaskStatus.completed => 'Completada',
    TaskStatus.cancelled => 'Cancelada',
  };
}

extension TaskPriorityLabel on TaskPriority {
  String get label => switch (this) {
    TaskPriority.none => 'Sin prioridad',
    TaskPriority.low => 'Baja',
    TaskPriority.medium => 'Media',
    TaskPriority.high => 'Alta',
  };
}
