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

/// Cuándo toca una tarea, sin fechas: el usuario no tiene horario fijo, así
/// que planifica por orden y no por calendario. `null` en la base = [next].
enum TaskHorizon { now, next, later }

/// Cuánto tiempo pide una tarea — alimenta el filtro "tengo 15 min / 1 hora".
/// `null` en la base = sin estimar.
enum TaskSize { quick, hour, long }

/// Máximo sugerido de tareas en "Ahora" — si hay más, ya no ayuda a decidir
/// qué hacer primero. Es un aviso en la UI, no una restricción.
const maxTareasAhora = 3;

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

extension TaskHorizonParsing on String? {
  TaskHorizon toTaskHorizon() =>
      TaskHorizon.values.asNameMap()[this] ?? TaskHorizon.next;
}

extension TaskSizeParsing on String? {
  TaskSize? toTaskSize() => TaskSize.values.asNameMap()[this];
}

extension TaskHorizonLabel on TaskHorizon {
  String get label => switch (this) {
    TaskHorizon.now => 'Ahora',
    TaskHorizon.next => 'Siguiente',
    TaskHorizon.later => 'Después',
  };
}

extension TaskSizeLabel on TaskSize {
  String get label => switch (this) {
    TaskSize.quick => '15 min',
    TaskSize.hour => '1 h',
    TaskSize.long => '+1 h',
  };
}

/// ¿Cabe una tarea de tamaño [size] en el tiempo disponible [limite]?
/// `limite == null` = sin límite (cabe todo). Una tarea sin estimar no
/// cabe en ningún límite: no se sabe si alcanza.
bool cabeEnElTiempo(TaskSize? size, TaskSize? limite) {
  if (limite == null) return true;
  if (size == null) return false;
  return size.index <= limite.index;
}
