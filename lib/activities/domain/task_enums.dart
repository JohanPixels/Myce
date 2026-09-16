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
