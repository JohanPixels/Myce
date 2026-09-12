enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { none, low, medium, high }

extension TaskStatusParsing on String {
  TaskStatus toTaskStatus() => TaskStatus.values.byName(this);
}

extension TaskPriorityParsing on String {
  TaskPriority toTaskPriority() => TaskPriority.values.byName(this);
}
