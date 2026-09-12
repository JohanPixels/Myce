// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EntitiesTable extends Entities
    with TableInfo<$EntitiesTable, EntityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    description,
    status,
    createdAt,
    updatedAt,
    dirty,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

class EntityRow extends DataClass implements Insertable<EntityRow> {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool dirty;
  final DateTime? deletedAt;
  const EntityRow({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dirty,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EntitiesCompanion toCompanion(bool nullToAbsent) {
    return EntitiesCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EntityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityRow(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EntityRow copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> description = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? dirty,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EntityRow(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EntityRow copyWithCompanion(EntitiesCompanion data) {
    return EntityRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    description,
    status,
    createdAt,
    updatedAt,
    dirty,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt);
}

class EntitiesCompanion extends UpdateCompanion<EntityRow> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EntitiesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : type = Value(type),
       title = Value(title);
  static Insertable<EntityRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EntitiesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [entityId, startedAt, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String entityId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const ProjectRow({required this.entityId, this.startedAt, this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      entityId: Value(entityId),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      entityId: serializer.fromJson<String>(json['entityId']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  ProjectRow copyWith({
    String? entityId,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => ProjectRow(
    entityId: entityId ?? this.entityId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('entityId: $entityId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityId, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.entityId == this.entityId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> entityId;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.entityId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String entityId,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<ProjectRow> custom({
    Expression<String>? entityId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? entityId,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      entityId: entityId ?? this.entityId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('entityId: $entityId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [entityId, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String entityId;
  final String? content;
  const NoteRow({required this.entityId, this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      entityId: Value(entityId),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
    );
  }

  factory NoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      entityId: serializer.fromJson<String>(json['entityId']),
      content: serializer.fromJson<String?>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'content': serializer.toJson<String?>(content),
    };
  }

  NoteRow copyWith({
    String? entityId,
    Value<String?> content = const Value.absent(),
  }) => NoteRow(
    entityId: entityId ?? this.entityId,
    content: content.present ? content.value : this.content,
  );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('entityId: $entityId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityId, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.entityId == this.entityId &&
          other.content == this.content);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> entityId;
  final Value<String?> content;
  final Value<int> rowid;
  const NotesCompanion({
    this.entityId = const Value.absent(),
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String entityId,
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<NoteRow> custom({
    Expression<String>? entityId,
    Expression<String>? content,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (content != null) 'content': content,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? entityId,
    Value<String?>? content,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      entityId: entityId ?? this.entityId,
      content: content ?? this.content,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('content: $content, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AreasTable extends Areas with TableInfo<$AreasTable, AreaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AreasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'areas';
  @override
  VerificationContext validateIntegrity(
    Insertable<AreaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  AreaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AreaRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $AreasTable createAlias(String alias) {
    return $AreasTable(attachedDatabase, alias);
  }
}

class AreaRow extends DataClass implements Insertable<AreaRow> {
  final String entityId;
  const AreaRow({required this.entityId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  AreasCompanion toCompanion(bool nullToAbsent) {
    return AreasCompanion(entityId: Value(entityId));
  }

  factory AreaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AreaRow(entityId: serializer.fromJson<String>(json['entityId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'entityId': serializer.toJson<String>(entityId)};
  }

  AreaRow copyWith({String? entityId}) =>
      AreaRow(entityId: entityId ?? this.entityId);
  AreaRow copyWithCompanion(AreasCompanion data) {
    return AreaRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AreaRow(')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => entityId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AreaRow && other.entityId == this.entityId);
}

class AreasCompanion extends UpdateCompanion<AreaRow> {
  final Value<String> entityId;
  final Value<int> rowid;
  const AreasCompanion({
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AreasCompanion.insert({
    required String entityId,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<AreaRow> custom({
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AreasCompanion copyWith({Value<String>? entityId, Value<int>? rowid}) {
    return AreasCompanion(
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreasCompanion(')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResourcesTable extends Resources
    with TableInfo<$ResourcesTable, ResourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resources';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  ResourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResourceRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $ResourcesTable createAlias(String alias) {
    return $ResourcesTable(attachedDatabase, alias);
  }
}

class ResourceRow extends DataClass implements Insertable<ResourceRow> {
  final String entityId;
  const ResourceRow({required this.entityId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  ResourcesCompanion toCompanion(bool nullToAbsent) {
    return ResourcesCompanion(entityId: Value(entityId));
  }

  factory ResourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResourceRow(entityId: serializer.fromJson<String>(json['entityId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'entityId': serializer.toJson<String>(entityId)};
  }

  ResourceRow copyWith({String? entityId}) =>
      ResourceRow(entityId: entityId ?? this.entityId);
  ResourceRow copyWithCompanion(ResourcesCompanion data) {
    return ResourceRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResourceRow(')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => entityId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResourceRow && other.entityId == this.entityId);
}

class ResourcesCompanion extends UpdateCompanion<ResourceRow> {
  final Value<String> entityId;
  final Value<int> rowid;
  const ResourcesCompanion({
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResourcesCompanion.insert({
    required String entityId,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<ResourceRow> custom({
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResourcesCompanion copyWith({Value<String>? entityId, Value<int>? rowid}) {
    return ResourcesCompanion(
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResourcesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeopleTable extends People with TableInfo<$PeopleTable, PersonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  PersonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class PersonRow extends DataClass implements Insertable<PersonRow> {
  final String entityId;
  const PersonRow({required this.entityId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(entityId: Value(entityId));
  }

  factory PersonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonRow(entityId: serializer.fromJson<String>(json['entityId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'entityId': serializer.toJson<String>(entityId)};
  }

  PersonRow copyWith({String? entityId}) =>
      PersonRow(entityId: entityId ?? this.entityId);
  PersonRow copyWithCompanion(PeopleCompanion data) {
    return PersonRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonRow(')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => entityId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonRow && other.entityId == this.entityId);
}

class PeopleCompanion extends UpdateCompanion<PersonRow> {
  final Value<String> entityId;
  final Value<int> rowid;
  const PeopleCompanion({
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeopleCompanion.insert({
    required String entityId,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<PersonRow> custom({
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeopleCompanion copyWith({Value<String>? entityId, Value<int>? rowid}) {
    return PeopleCompanion(
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HobbiesTable extends Hobbies with TableInfo<$HobbiesTable, HobbyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HobbiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hobbies';
  @override
  VerificationContext validateIntegrity(
    Insertable<HobbyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  HobbyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HobbyRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $HobbiesTable createAlias(String alias) {
    return $HobbiesTable(attachedDatabase, alias);
  }
}

class HobbyRow extends DataClass implements Insertable<HobbyRow> {
  final String entityId;
  const HobbyRow({required this.entityId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  HobbiesCompanion toCompanion(bool nullToAbsent) {
    return HobbiesCompanion(entityId: Value(entityId));
  }

  factory HobbyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HobbyRow(entityId: serializer.fromJson<String>(json['entityId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'entityId': serializer.toJson<String>(entityId)};
  }

  HobbyRow copyWith({String? entityId}) =>
      HobbyRow(entityId: entityId ?? this.entityId);
  HobbyRow copyWithCompanion(HobbiesCompanion data) {
    return HobbyRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HobbyRow(')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => entityId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HobbyRow && other.entityId == this.entityId);
}

class HobbiesCompanion extends UpdateCompanion<HobbyRow> {
  final Value<String> entityId;
  final Value<int> rowid;
  const HobbiesCompanion({
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HobbiesCompanion.insert({
    required String entityId,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<HobbyRow> custom({
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HobbiesCompanion copyWith({Value<String>? entityId, Value<int>? rowid}) {
    return HobbiesCompanion(
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HobbiesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String entityId;
  const GoalRow({required this.entityId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(entityId: Value(entityId));
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(entityId: serializer.fromJson<String>(json['entityId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'entityId': serializer.toJson<String>(entityId)};
  }

  GoalRow copyWith({String? entityId}) =>
      GoalRow(entityId: entityId ?? this.entityId);
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => entityId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow && other.entityId == this.entityId);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> entityId;
  final Value<int> rowid;
  const GoalsCompanion({
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String entityId,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId);
  static Insertable<GoalRow> custom({
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({Value<String>? entityId, Value<int>? rowid}) {
    return GoalsCompanion(
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationTypesTable extends RelationTypes
    with TableInfo<$RelationTypesTable, RelationTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inverseLabelMeta = const VerificationMeta(
    'inverseLabel',
  );
  @override
  late final GeneratedColumn<String> inverseLabel = GeneratedColumn<String>(
    'inverse_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directedMeta = const VerificationMeta(
    'directed',
  );
  @override
  late final GeneratedColumn<bool> directed = GeneratedColumn<bool>(
    'directed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("directed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    label,
    inverseLabel,
    directed,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relation_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<RelationTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('inverse_label')) {
      context.handle(
        _inverseLabelMeta,
        inverseLabel.isAcceptableOrUnknown(
          data['inverse_label']!,
          _inverseLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inverseLabelMeta);
    }
    if (data.containsKey('directed')) {
      context.handle(
        _directedMeta,
        directed.isAcceptableOrUnknown(data['directed']!, _directedMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      inverseLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inverse_label'],
      )!,
      directed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}directed'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $RelationTypesTable createAlias(String alias) {
    return $RelationTypesTable(attachedDatabase, alias);
  }
}

class RelationTypeRow extends DataClass implements Insertable<RelationTypeRow> {
  final String id;
  final String key;
  final String label;
  final String inverseLabel;
  final bool directed;
  final String? description;
  const RelationTypeRow({
    required this.id,
    required this.key,
    required this.label,
    required this.inverseLabel,
    required this.directed,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['label'] = Variable<String>(label);
    map['inverse_label'] = Variable<String>(inverseLabel);
    map['directed'] = Variable<bool>(directed);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  RelationTypesCompanion toCompanion(bool nullToAbsent) {
    return RelationTypesCompanion(
      id: Value(id),
      key: Value(key),
      label: Value(label),
      inverseLabel: Value(inverseLabel),
      directed: Value(directed),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory RelationTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationTypeRow(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      label: serializer.fromJson<String>(json['label']),
      inverseLabel: serializer.fromJson<String>(json['inverseLabel']),
      directed: serializer.fromJson<bool>(json['directed']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'label': serializer.toJson<String>(label),
      'inverseLabel': serializer.toJson<String>(inverseLabel),
      'directed': serializer.toJson<bool>(directed),
      'description': serializer.toJson<String?>(description),
    };
  }

  RelationTypeRow copyWith({
    String? id,
    String? key,
    String? label,
    String? inverseLabel,
    bool? directed,
    Value<String?> description = const Value.absent(),
  }) => RelationTypeRow(
    id: id ?? this.id,
    key: key ?? this.key,
    label: label ?? this.label,
    inverseLabel: inverseLabel ?? this.inverseLabel,
    directed: directed ?? this.directed,
    description: description.present ? description.value : this.description,
  );
  RelationTypeRow copyWithCompanion(RelationTypesCompanion data) {
    return RelationTypeRow(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
      inverseLabel: data.inverseLabel.present
          ? data.inverseLabel.value
          : this.inverseLabel,
      directed: data.directed.present ? data.directed.value : this.directed,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationTypeRow(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('inverseLabel: $inverseLabel, ')
          ..write('directed: $directed, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, key, label, inverseLabel, directed, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationTypeRow &&
          other.id == this.id &&
          other.key == this.key &&
          other.label == this.label &&
          other.inverseLabel == this.inverseLabel &&
          other.directed == this.directed &&
          other.description == this.description);
}

class RelationTypesCompanion extends UpdateCompanion<RelationTypeRow> {
  final Value<String> id;
  final Value<String> key;
  final Value<String> label;
  final Value<String> inverseLabel;
  final Value<bool> directed;
  final Value<String?> description;
  final Value<int> rowid;
  const RelationTypesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.inverseLabel = const Value.absent(),
    this.directed = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationTypesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String label,
    required String inverseLabel,
    this.directed = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       label = Value(label),
       inverseLabel = Value(inverseLabel);
  static Insertable<RelationTypeRow> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<String>? label,
    Expression<String>? inverseLabel,
    Expression<bool>? directed,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (inverseLabel != null) 'inverse_label': inverseLabel,
      if (directed != null) 'directed': directed,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? key,
    Value<String>? label,
    Value<String>? inverseLabel,
    Value<bool>? directed,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return RelationTypesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      inverseLabel: inverseLabel ?? this.inverseLabel,
      directed: directed ?? this.directed,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (inverseLabel.present) {
      map['inverse_label'] = Variable<String>(inverseLabel.value);
    }
    if (directed.present) {
      map['directed'] = Variable<bool>(directed.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationTypesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('inverseLabel: $inverseLabel, ')
          ..write('directed: $directed, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationsTable extends Relations
    with TableInfo<$RelationsTable, RelationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _sourceEntityIdMeta = const VerificationMeta(
    'sourceEntityId',
  );
  @override
  late final GeneratedColumn<String> sourceEntityId = GeneratedColumn<String>(
    'source_entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetEntityIdMeta = const VerificationMeta(
    'targetEntityId',
  );
  @override
  late final GeneratedColumn<String> targetEntityId = GeneratedColumn<String>(
    'target_entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relationTypeIdMeta = const VerificationMeta(
    'relationTypeId',
  );
  @override
  late final GeneratedColumn<String> relationTypeId = GeneratedColumn<String>(
    'relation_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES relation_types (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceEntityId,
    targetEntityId,
    relationTypeId,
    note,
    metadata,
    createdAt,
    dirty,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<RelationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_entity_id')) {
      context.handle(
        _sourceEntityIdMeta,
        sourceEntityId.isAcceptableOrUnknown(
          data['source_entity_id']!,
          _sourceEntityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceEntityIdMeta);
    }
    if (data.containsKey('target_entity_id')) {
      context.handle(
        _targetEntityIdMeta,
        targetEntityId.isAcceptableOrUnknown(
          data['target_entity_id']!,
          _targetEntityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetEntityIdMeta);
    }
    if (data.containsKey('relation_type_id')) {
      context.handle(
        _relationTypeIdMeta,
        relationTypeId.isAcceptableOrUnknown(
          data['relation_type_id']!,
          _relationTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationTypeIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_entity_id'],
      )!,
      targetEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_entity_id'],
      )!,
      relationTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $RelationsTable createAlias(String alias) {
    return $RelationsTable(attachedDatabase, alias);
  }
}

class RelationRow extends DataClass implements Insertable<RelationRow> {
  final String id;
  final String sourceEntityId;
  final String targetEntityId;
  final String relationTypeId;
  final String? note;
  final String? metadata;
  final DateTime createdAt;
  final bool dirty;
  final DateTime? deletedAt;
  const RelationRow({
    required this.id,
    required this.sourceEntityId,
    required this.targetEntityId,
    required this.relationTypeId,
    this.note,
    this.metadata,
    required this.createdAt,
    required this.dirty,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_entity_id'] = Variable<String>(sourceEntityId);
    map['target_entity_id'] = Variable<String>(targetEntityId);
    map['relation_type_id'] = Variable<String>(relationTypeId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  RelationsCompanion toCompanion(bool nullToAbsent) {
    return RelationsCompanion(
      id: Value(id),
      sourceEntityId: Value(sourceEntityId),
      targetEntityId: Value(targetEntityId),
      relationTypeId: Value(relationTypeId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory RelationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationRow(
      id: serializer.fromJson<String>(json['id']),
      sourceEntityId: serializer.fromJson<String>(json['sourceEntityId']),
      targetEntityId: serializer.fromJson<String>(json['targetEntityId']),
      relationTypeId: serializer.fromJson<String>(json['relationTypeId']),
      note: serializer.fromJson<String?>(json['note']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceEntityId': serializer.toJson<String>(sourceEntityId),
      'targetEntityId': serializer.toJson<String>(targetEntityId),
      'relationTypeId': serializer.toJson<String>(relationTypeId),
      'note': serializer.toJson<String?>(note),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  RelationRow copyWith({
    String? id,
    String? sourceEntityId,
    String? targetEntityId,
    String? relationTypeId,
    Value<String?> note = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
    bool? dirty,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => RelationRow(
    id: id ?? this.id,
    sourceEntityId: sourceEntityId ?? this.sourceEntityId,
    targetEntityId: targetEntityId ?? this.targetEntityId,
    relationTypeId: relationTypeId ?? this.relationTypeId,
    note: note.present ? note.value : this.note,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
    dirty: dirty ?? this.dirty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  RelationRow copyWithCompanion(RelationsCompanion data) {
    return RelationRow(
      id: data.id.present ? data.id.value : this.id,
      sourceEntityId: data.sourceEntityId.present
          ? data.sourceEntityId.value
          : this.sourceEntityId,
      targetEntityId: data.targetEntityId.present
          ? data.targetEntityId.value
          : this.targetEntityId,
      relationTypeId: data.relationTypeId.present
          ? data.relationTypeId.value
          : this.relationTypeId,
      note: data.note.present ? data.note.value : this.note,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationRow(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('relationTypeId: $relationTypeId, ')
          ..write('note: $note, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceEntityId,
    targetEntityId,
    relationTypeId,
    note,
    metadata,
    createdAt,
    dirty,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationRow &&
          other.id == this.id &&
          other.sourceEntityId == this.sourceEntityId &&
          other.targetEntityId == this.targetEntityId &&
          other.relationTypeId == this.relationTypeId &&
          other.note == this.note &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt);
}

class RelationsCompanion extends UpdateCompanion<RelationRow> {
  final Value<String> id;
  final Value<String> sourceEntityId;
  final Value<String> targetEntityId;
  final Value<String> relationTypeId;
  final Value<String?> note;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const RelationsCompanion({
    this.id = const Value.absent(),
    this.sourceEntityId = const Value.absent(),
    this.targetEntityId = const Value.absent(),
    this.relationTypeId = const Value.absent(),
    this.note = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationsCompanion.insert({
    this.id = const Value.absent(),
    required String sourceEntityId,
    required String targetEntityId,
    required String relationTypeId,
    this.note = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sourceEntityId = Value(sourceEntityId),
       targetEntityId = Value(targetEntityId),
       relationTypeId = Value(relationTypeId);
  static Insertable<RelationRow> custom({
    Expression<String>? id,
    Expression<String>? sourceEntityId,
    Expression<String>? targetEntityId,
    Expression<String>? relationTypeId,
    Expression<String>? note,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceEntityId != null) 'source_entity_id': sourceEntityId,
      if (targetEntityId != null) 'target_entity_id': targetEntityId,
      if (relationTypeId != null) 'relation_type_id': relationTypeId,
      if (note != null) 'note': note,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceEntityId,
    Value<String>? targetEntityId,
    Value<String>? relationTypeId,
    Value<String?>? note,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
    Value<bool>? dirty,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RelationsCompanion(
      id: id ?? this.id,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      relationTypeId: relationTypeId ?? this.relationTypeId,
      note: note ?? this.note,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      dirty: dirty ?? this.dirty,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceEntityId.present) {
      map['source_entity_id'] = Variable<String>(sourceEntityId.value);
    }
    if (targetEntityId.present) {
      map['target_entity_id'] = Variable<String>(targetEntityId.value);
    }
    if (relationTypeId.present) {
      map['relation_type_id'] = Variable<String>(relationTypeId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationsCompanion(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('relationTypeId: $relationTypeId, ')
          ..write('note: $note, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    status,
    priority,
    dueAt,
    completedAt,
    createdAt,
    updatedAt,
    dirty,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool dirty;
  final DateTime? deletedAt;
  const TaskRow({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.dirty,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      priority: Value(priority),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? status,
    String? priority,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? dirty,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    status,
    priority,
    dueAt,
    completedAt,
    createdAt,
    updatedAt,
    dirty,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.dueAt == this.dueAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> status;
  final Value<String> priority;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (dueAt != null) 'due_at': dueAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? status,
    Value<String>? priority,
    Value<DateTime?>? dueAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLinksTable extends ActivityLinks
    with TableInfo<$ActivityLinksTable, ActivityLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _linkTypeMeta = const VerificationMeta(
    'linkType',
  );
  @override
  late final GeneratedColumn<String> linkType = GeneratedColumn<String>(
    'link_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityType,
    activityId,
    entityId,
    linkType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLinkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityTypeMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('link_type')) {
      context.handle(
        _linkTypeMeta,
        linkType.isAcceptableOrUnknown(data['link_type']!, _linkTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_linkTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLinkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      linkType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityLinksTable createAlias(String alias) {
    return $ActivityLinksTable(attachedDatabase, alias);
  }
}

class ActivityLinkRow extends DataClass implements Insertable<ActivityLinkRow> {
  final String id;
  final String activityType;
  final String activityId;
  final String entityId;
  final String linkType;
  final DateTime createdAt;
  const ActivityLinkRow({
    required this.id,
    required this.activityType,
    required this.activityId,
    required this.entityId,
    required this.linkType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['activity_type'] = Variable<String>(activityType);
    map['activity_id'] = Variable<String>(activityId);
    map['entity_id'] = Variable<String>(entityId);
    map['link_type'] = Variable<String>(linkType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityLinksCompanion toCompanion(bool nullToAbsent) {
    return ActivityLinksCompanion(
      id: Value(id),
      activityType: Value(activityType),
      activityId: Value(activityId),
      entityId: Value(entityId),
      linkType: Value(linkType),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLinkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLinkRow(
      id: serializer.fromJson<String>(json['id']),
      activityType: serializer.fromJson<String>(json['activityType']),
      activityId: serializer.fromJson<String>(json['activityId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      linkType: serializer.fromJson<String>(json['linkType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activityType': serializer.toJson<String>(activityType),
      'activityId': serializer.toJson<String>(activityId),
      'entityId': serializer.toJson<String>(entityId),
      'linkType': serializer.toJson<String>(linkType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityLinkRow copyWith({
    String? id,
    String? activityType,
    String? activityId,
    String? entityId,
    String? linkType,
    DateTime? createdAt,
  }) => ActivityLinkRow(
    id: id ?? this.id,
    activityType: activityType ?? this.activityType,
    activityId: activityId ?? this.activityId,
    entityId: entityId ?? this.entityId,
    linkType: linkType ?? this.linkType,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityLinkRow copyWithCompanion(ActivityLinksCompanion data) {
    return ActivityLinkRow(
      id: data.id.present ? data.id.value : this.id,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      linkType: data.linkType.present ? data.linkType.value : this.linkType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLinkRow(')
          ..write('id: $id, ')
          ..write('activityType: $activityType, ')
          ..write('activityId: $activityId, ')
          ..write('entityId: $entityId, ')
          ..write('linkType: $linkType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, activityType, activityId, entityId, linkType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLinkRow &&
          other.id == this.id &&
          other.activityType == this.activityType &&
          other.activityId == this.activityId &&
          other.entityId == this.entityId &&
          other.linkType == this.linkType &&
          other.createdAt == this.createdAt);
}

class ActivityLinksCompanion extends UpdateCompanion<ActivityLinkRow> {
  final Value<String> id;
  final Value<String> activityType;
  final Value<String> activityId;
  final Value<String> entityId;
  final Value<String> linkType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityLinksCompanion({
    this.id = const Value.absent(),
    this.activityType = const Value.absent(),
    this.activityId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.linkType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLinksCompanion.insert({
    this.id = const Value.absent(),
    required String activityType,
    required String activityId,
    required String entityId,
    required String linkType,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityType = Value(activityType),
       activityId = Value(activityId),
       entityId = Value(entityId),
       linkType = Value(linkType);
  static Insertable<ActivityLinkRow> custom({
    Expression<String>? id,
    Expression<String>? activityType,
    Expression<String>? activityId,
    Expression<String>? entityId,
    Expression<String>? linkType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityType != null) 'activity_type': activityType,
      if (activityId != null) 'activity_id': activityId,
      if (entityId != null) 'entity_id': entityId,
      if (linkType != null) 'link_type': linkType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? activityType,
    Value<String>? activityId,
    Value<String>? entityId,
    Value<String>? linkType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ActivityLinksCompanion(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      activityId: activityId ?? this.activityId,
      entityId: entityId ?? this.entityId,
      linkType: linkType ?? this.linkType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (linkType.present) {
      map['link_type'] = Variable<String>(linkType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLinksCompanion(')
          ..write('id: $id, ')
          ..write('activityType: $activityType, ')
          ..write('activityId: $activityId, ')
          ..write('entityId: $entityId, ')
          ..write('linkType: $linkType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InboxItemsTable extends InboxItems
    with TableInfo<$InboxItemsTable, InboxItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InboxItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    createdAt,
    dirty,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inbox_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InboxItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InboxItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InboxItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $InboxItemsTable createAlias(String alias) {
    return $InboxItemsTable(attachedDatabase, alias);
  }
}

class InboxItemRow extends DataClass implements Insertable<InboxItemRow> {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool dirty;
  final DateTime? deletedAt;
  const InboxItemRow({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.dirty,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  InboxItemsCompanion toCompanion(bool nullToAbsent) {
    return InboxItemsCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory InboxItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InboxItemRow(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  InboxItemRow copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    bool? dirty,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => InboxItemRow(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    dirty: dirty ?? this.dirty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  InboxItemRow copyWithCompanion(InboxItemsCompanion data) {
    return InboxItemRow(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InboxItemRow(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt, dirty, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InboxItemRow &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt);
}

class InboxItemsCompanion extends UpdateCompanion<InboxItemRow> {
  final Value<String> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const InboxItemsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InboxItemsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.createdAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : content = Value(content);
  static Insertable<InboxItemRow> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InboxItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<bool>? dirty,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return InboxItemsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      dirty: dirty ?? this.dirty,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InboxItemsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String name;
  const TagRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  TagRow copyWith({String? id, String? name}) =>
      TagRow(id: id ?? this.id, name: name ?? this.name);
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityTagsTable extends EntityTags
    with TableInfo<$EntityTagsTable, EntityTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [entityId, tagId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, tagId};
  @override
  EntityTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityTagRow(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EntityTagsTable createAlias(String alias) {
    return $EntityTagsTable(attachedDatabase, alias);
  }
}

class EntityTagRow extends DataClass implements Insertable<EntityTagRow> {
  final String entityId;
  final String tagId;
  final DateTime createdAt;
  const EntityTagRow({
    required this.entityId,
    required this.tagId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['tag_id'] = Variable<String>(tagId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntityTagsCompanion toCompanion(bool nullToAbsent) {
    return EntityTagsCompanion(
      entityId: Value(entityId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
    );
  }

  factory EntityTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityTagRow(
      entityId: serializer.fromJson<String>(json['entityId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'tagId': serializer.toJson<String>(tagId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntityTagRow copyWith({
    String? entityId,
    String? tagId,
    DateTime? createdAt,
  }) => EntityTagRow(
    entityId: entityId ?? this.entityId,
    tagId: tagId ?? this.tagId,
    createdAt: createdAt ?? this.createdAt,
  );
  EntityTagRow copyWithCompanion(EntityTagsCompanion data) {
    return EntityTagRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityTagRow(')
          ..write('entityId: $entityId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityId, tagId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityTagRow &&
          other.entityId == this.entityId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt);
}

class EntityTagsCompanion extends UpdateCompanion<EntityTagRow> {
  final Value<String> entityId;
  final Value<String> tagId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EntityTagsCompanion({
    this.entityId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityTagsCompanion.insert({
    required String entityId,
    required String tagId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId),
       tagId = Value(tagId);
  static Insertable<EntityTagRow> custom({
    Expression<String>? entityId,
    Expression<String>? tagId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityTagsCompanion copyWith({
    Value<String>? entityId,
    Value<String>? tagId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EntityTagsCompanion(
      entityId: entityId ?? this.entityId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityTagsCompanion(')
          ..write('entityId: $entityId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $AreasTable areas = $AreasTable(this);
  late final $ResourcesTable resources = $ResourcesTable(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $HobbiesTable hobbies = $HobbiesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $RelationTypesTable relationTypes = $RelationTypesTable(this);
  late final $RelationsTable relations = $RelationsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ActivityLinksTable activityLinks = $ActivityLinksTable(this);
  late final $InboxItemsTable inboxItems = $InboxItemsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $EntityTagsTable entityTags = $EntityTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    entities,
    projects,
    notes,
    areas,
    resources,
    people,
    hobbies,
    goals,
    relationTypes,
    relations,
    tasks,
    activityLinks,
    inboxItems,
    tags,
    entityTags,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('projects', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('areas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('resources', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('people', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('hobbies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entity_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entity_tags', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$EntitiesTableCreateCompanionBuilder = EntitiesCompanion Function({
  Value<String> id,
  required String type,
  required String title,
  Value<String?> description,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$EntitiesTableUpdateCompanionBuilder = EntitiesCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> title,
  Value<String?> description,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$EntitiesTableReferences
    extends BaseReferences<_$AppDatabase, $EntitiesTable, EntityRow> {
  $$EntitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectsTable, List<ProjectRow>>
  _projectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'entities__id__projects__entity_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'entities__id__notes__entity_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AreasTable, List<AreaRow>> _areasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.areas,
    aliasName: 'entities__id__areas__entity_id',
  );

  $$AreasTableProcessedTableManager get areasRefs {
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_areasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResourcesTable, List<ResourceRow>>
  _resourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resources,
    aliasName: 'entities__id__resources__entity_id',
  );

  $$ResourcesTableProcessedTableManager get resourcesRefs {
    final manager = $$ResourcesTableTableManager(
      $_db,
      $_db.resources,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_resourcesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PeopleTable, List<PersonRow>> _peopleRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.people,
    aliasName: 'entities__id__people__entity_id',
  );

  $$PeopleTableProcessedTableManager get peopleRefs {
    final manager = $$PeopleTableTableManager(
      $_db,
      $_db.people,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_peopleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HobbiesTable, List<HobbyRow>> _hobbiesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.hobbies,
    aliasName: 'entities__id__hobbies__entity_id',
  );

  $$HobbiesTableProcessedTableManager get hobbiesRefs {
    final manager = $$HobbiesTableTableManager(
      $_db,
      $_db.hobbies,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_hobbiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalsTable, List<GoalRow>> _goalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: 'entities__id__goals__entity_id',
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RelationsTable, List<RelationRow>>
  _relationsAsSourceTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.relations,
    aliasName: 'entities__id__relations__source_entity_id',
  );

  $$RelationsTableProcessedTableManager get relationsAsSource {
    final manager = $$RelationsTableTableManager(
      $_db,
      $_db.relations,
    ).filter((f) => f.sourceEntityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_relationsAsSourceTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RelationsTable, List<RelationRow>>
  _relationsAsTargetTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.relations,
    aliasName: 'entities__id__relations__target_entity_id',
  );

  $$RelationsTableProcessedTableManager get relationsAsTarget {
    final manager = $$RelationsTableTableManager(
      $_db,
      $_db.relations,
    ).filter((f) => f.targetEntityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_relationsAsTargetTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivityLinksTable, List<ActivityLinkRow>>
  _activityLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activityLinks,
    aliasName: 'entities__id__activity_links__entity_id',
  );

  $$ActivityLinksTableProcessedTableManager get activityLinksRefs {
    final manager = $$ActivityLinksTableTableManager(
      $_db,
      $_db.activityLinks,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activityLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EntityTagsTable, List<EntityTagRow>>
  _entityTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entityTags,
    aliasName: 'entities__id__entity_tags__entity_id',
  );

  $$EntityTagsTableProcessedTableManager get entityTagsRefs {
    final manager = $$EntityTagsTableTableManager(
      $_db,
      $_db.entityTags,
    ).filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EntitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> areasRefs(
    Expression<bool> Function($$AreasTableFilterComposer f) f,
  ) {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableFilterComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resourcesRefs(
    Expression<bool> Function($$ResourcesTableFilterComposer f) f,
  ) {
    final $$ResourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableFilterComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> peopleRefs(
    Expression<bool> Function($$PeopleTableFilterComposer f) f,
  ) {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableFilterComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> hobbiesRefs(
    Expression<bool> Function($$HobbiesTableFilterComposer f) f,
  ) {
    final $$HobbiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hobbies,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HobbiesTableFilterComposer(
            $db: $db,
            $table: $db.hobbies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> relationsAsSource(
    Expression<bool> Function($$RelationsTableFilterComposer f) f,
  ) {
    final $$RelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.sourceEntityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableFilterComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> relationsAsTarget(
    Expression<bool> Function($$RelationsTableFilterComposer f) f,
  ) {
    final $$RelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.targetEntityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableFilterComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityLinksRefs(
    Expression<bool> Function($$ActivityLinksTableFilterComposer f) f,
  ) {
    final $$ActivityLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityLinks,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityLinksTableFilterComposer(
            $db: $db,
            $table: $db.activityLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> entityTagsRefs(
    Expression<bool> Function($$EntityTagsTableFilterComposer f) f,
  ) {
    final $$EntityTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTags,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTagsTableFilterComposer(
            $db: $db,
            $table: $db.entityTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> areasRefs<T extends Object>(
    Expression<T> Function($$AreasTableAnnotationComposer a) f,
  ) {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableAnnotationComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resourcesRefs<T extends Object>(
    Expression<T> Function($$ResourcesTableAnnotationComposer a) f,
  ) {
    final $$ResourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resources,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.resources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> peopleRefs<T extends Object>(
    Expression<T> Function($$PeopleTableAnnotationComposer a) f,
  ) {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableAnnotationComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> hobbiesRefs<T extends Object>(
    Expression<T> Function($$HobbiesTableAnnotationComposer a) f,
  ) {
    final $$HobbiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hobbies,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HobbiesTableAnnotationComposer(
            $db: $db,
            $table: $db.hobbies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> relationsAsSource<T extends Object>(
    Expression<T> Function($$RelationsTableAnnotationComposer a) f,
  ) {
    final $$RelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.sourceEntityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> relationsAsTarget<T extends Object>(
    Expression<T> Function($$RelationsTableAnnotationComposer a) f,
  ) {
    final $$RelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.targetEntityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activityLinksRefs<T extends Object>(
    Expression<T> Function($$ActivityLinksTableAnnotationComposer a) f,
  ) {
    final $$ActivityLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityLinks,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.activityLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> entityTagsRefs<T extends Object>(
    Expression<T> Function($$EntityTagsTableAnnotationComposer a) f,
  ) {
    final $$EntityTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTags,
      getReferencedColumn: (t) => t.entityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.entityTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitiesTable,
          EntityRow,
          $$EntitiesTableFilterComposer,
          $$EntitiesTableOrderingComposer,
          $$EntitiesTableAnnotationComposer,
          $$EntitiesTableCreateCompanionBuilder,
          $$EntitiesTableUpdateCompanionBuilder,
          (EntityRow, $$EntitiesTableReferences),
          EntityRow,
          PrefetchHooks Function({
            bool projectsRefs,
            bool notesRefs,
            bool areasRefs,
            bool resourcesRefs,
            bool peopleRefs,
            bool hobbiesRefs,
            bool goalsRefs,
            bool relationsAsSource,
            bool relationsAsTarget,
            bool activityLinksRefs,
            bool entityTagsRefs,
          })
        > {
  $$EntitiesTableTableManager(_$AppDatabase db, $EntitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion(
                id: id,
                type: type,
                title: title,
                description: description,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String type,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion.insert(
                id: id,
                type: type,
                title: title,
                description: description,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectsRefs = false,
                notesRefs = false,
                areasRefs = false,
                resourcesRefs = false,
                peopleRefs = false,
                hobbiesRefs = false,
                goalsRefs = false,
                relationsAsSource = false,
                relationsAsTarget = false,
                activityLinksRefs = false,
                entityTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectsRefs) db.projects,
                    if (notesRefs) db.notes,
                    if (areasRefs) db.areas,
                    if (resourcesRefs) db.resources,
                    if (peopleRefs) db.people,
                    if (hobbiesRefs) db.hobbies,
                    if (goalsRefs) db.goals,
                    if (relationsAsSource) db.relations,
                    if (relationsAsTarget) db.relations,
                    if (activityLinksRefs) db.activityLinks,
                    if (entityTagsRefs) db.entityTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          ProjectRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          NoteRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (areasRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          AreaRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._areasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).areasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resourcesRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          ResourceRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._resourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).resourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (peopleRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          PersonRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._peopleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).peopleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (hobbiesRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          HobbyRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._hobbiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).hobbiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalsRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          GoalRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._goalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).goalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (relationsAsSource)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          RelationRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._relationsAsSourceTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).relationsAsSource,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceEntityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (relationsAsTarget)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          RelationRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._relationsAsTargetTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).relationsAsTarget,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetEntityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityLinksRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          ActivityLinkRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._activityLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (entityTagsRefs)
                        await $_getPrefetchedData<
                          EntityRow,
                          $EntitiesTable,
                          EntityTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntitiesTableReferences
                              ._entityTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).entityTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EntitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitiesTable,
      EntityRow,
      $$EntitiesTableFilterComposer,
      $$EntitiesTableOrderingComposer,
      $$EntitiesTableAnnotationComposer,
      $$EntitiesTableCreateCompanionBuilder,
      $$EntitiesTableUpdateCompanionBuilder,
      (EntityRow, $$EntitiesTableReferences),
      EntityRow,
      PrefetchHooks Function({
        bool projectsRefs,
        bool notesRefs,
        bool areasRefs,
        bool resourcesRefs,
        bool peopleRefs,
        bool hobbiesRefs,
        bool goalsRefs,
        bool relationsAsSource,
        bool relationsAsTarget,
        bool activityLinksRefs,
        bool entityTagsRefs,
      })
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String entityId,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> entityId,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('projects__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectRow, $$ProjectsTableReferences),
          ProjectRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                entityId: entityId,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                entityId: entityId,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$ProjectsTableReferences
                            ._entityIdTable(db),
                        referencedColumn: $$ProjectsTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, $$ProjectsTableReferences),
      ProjectRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String entityId,
  Value<String?> content,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> entityId,
  Value<String?> content,
  Value<int> rowid,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NoteRow> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('notes__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          NoteRow,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (NoteRow, $$NotesTableReferences),
          NoteRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                entityId: entityId,
                content: content,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                Value<String?> content = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                entityId: entityId,
                content: content,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$NotesTableReferences._entityIdTable(
                          db,
                        ),
                        referencedColumn: $$NotesTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      NoteRow,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (NoteRow, $$NotesTableReferences),
      NoteRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$AreasTableCreateCompanionBuilder = AreasCompanion Function({
  required String entityId,
  Value<int> rowid,
});
typedef $$AreasTableUpdateCompanionBuilder = AreasCompanion Function({
  Value<String> entityId,
  Value<int> rowid,
});

final class $$AreasTableReferences
    extends BaseReferences<_$AppDatabase, $AreasTable, AreaRow> {
  $$AreasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('areas__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AreasTableFilterComposer extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AreasTableOrderingComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AreasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AreasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AreasTable,
          AreaRow,
          $$AreasTableFilterComposer,
          $$AreasTableOrderingComposer,
          $$AreasTableAnnotationComposer,
          $$AreasTableCreateCompanionBuilder,
          $$AreasTableUpdateCompanionBuilder,
          (AreaRow, $$AreasTableReferences),
          AreaRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$AreasTableTableManager(_$AppDatabase db, $AreasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AreasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AreasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AreasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AreasCompanion(entityId: entityId, rowid: rowid),
          createCompanionCallback: ({
            required String entityId,
            Value<int> rowid = const Value.absent(),
          }) => AreasCompanion.insert(entityId: entityId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AreasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$AreasTableReferences._entityIdTable(
                          db,
                        ),
                        referencedColumn: $$AreasTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AreasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AreasTable,
      AreaRow,
      $$AreasTableFilterComposer,
      $$AreasTableOrderingComposer,
      $$AreasTableAnnotationComposer,
      $$AreasTableCreateCompanionBuilder,
      $$AreasTableUpdateCompanionBuilder,
      (AreaRow, $$AreasTableReferences),
      AreaRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$ResourcesTableCreateCompanionBuilder = ResourcesCompanion Function({
  required String entityId,
  Value<int> rowid,
});
typedef $$ResourcesTableUpdateCompanionBuilder = ResourcesCompanion Function({
  Value<String> entityId,
  Value<int> rowid,
});

final class $$ResourcesTableReferences
    extends BaseReferences<_$AppDatabase, $ResourcesTable, ResourceRow> {
  $$ResourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('resources__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResourcesTableFilterComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResourcesTable> {
  $$ResourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResourcesTable,
          ResourceRow,
          $$ResourcesTableFilterComposer,
          $$ResourcesTableOrderingComposer,
          $$ResourcesTableAnnotationComposer,
          $$ResourcesTableCreateCompanionBuilder,
          $$ResourcesTableUpdateCompanionBuilder,
          (ResourceRow, $$ResourcesTableReferences),
          ResourceRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$ResourcesTableTableManager(_$AppDatabase db, $ResourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ResourcesCompanion(entityId: entityId, rowid: rowid),
          createCompanionCallback: ({
            required String entityId,
            Value<int> rowid = const Value.absent(),
          }) => ResourcesCompanion.insert(entityId: entityId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$ResourcesTableReferences
                            ._entityIdTable(db),
                        referencedColumn: $$ResourcesTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ResourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResourcesTable,
      ResourceRow,
      $$ResourcesTableFilterComposer,
      $$ResourcesTableOrderingComposer,
      $$ResourcesTableAnnotationComposer,
      $$ResourcesTableCreateCompanionBuilder,
      $$ResourcesTableUpdateCompanionBuilder,
      (ResourceRow, $$ResourcesTableReferences),
      ResourceRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  required String entityId,
  Value<int> rowid,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<String> entityId,
  Value<int> rowid,
});

final class $$PeopleTableReferences
    extends BaseReferences<_$AppDatabase, $PeopleTable, PersonRow> {
  $$PeopleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('people__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PeopleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeopleTable,
          PersonRow,
          $$PeopleTableFilterComposer,
          $$PeopleTableOrderingComposer,
          $$PeopleTableAnnotationComposer,
          $$PeopleTableCreateCompanionBuilder,
          $$PeopleTableUpdateCompanionBuilder,
          (PersonRow, $$PeopleTableReferences),
          PersonRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PeopleCompanion(entityId: entityId, rowid: rowid),
          createCompanionCallback: ({
            required String entityId,
            Value<int> rowid = const Value.absent(),
          }) => PeopleCompanion.insert(entityId: entityId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PeopleTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$PeopleTableReferences._entityIdTable(
                          db,
                        ),
                        referencedColumn: $$PeopleTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PeopleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeopleTable,
      PersonRow,
      $$PeopleTableFilterComposer,
      $$PeopleTableOrderingComposer,
      $$PeopleTableAnnotationComposer,
      $$PeopleTableCreateCompanionBuilder,
      $$PeopleTableUpdateCompanionBuilder,
      (PersonRow, $$PeopleTableReferences),
      PersonRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$HobbiesTableCreateCompanionBuilder = HobbiesCompanion Function({
  required String entityId,
  Value<int> rowid,
});
typedef $$HobbiesTableUpdateCompanionBuilder = HobbiesCompanion Function({
  Value<String> entityId,
  Value<int> rowid,
});

final class $$HobbiesTableReferences
    extends BaseReferences<_$AppDatabase, $HobbiesTable, HobbyRow> {
  $$HobbiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('hobbies__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HobbiesTableFilterComposer
    extends Composer<_$AppDatabase, $HobbiesTable> {
  $$HobbiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HobbiesTableOrderingComposer
    extends Composer<_$AppDatabase, $HobbiesTable> {
  $$HobbiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HobbiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HobbiesTable> {
  $$HobbiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HobbiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HobbiesTable,
          HobbyRow,
          $$HobbiesTableFilterComposer,
          $$HobbiesTableOrderingComposer,
          $$HobbiesTableAnnotationComposer,
          $$HobbiesTableCreateCompanionBuilder,
          $$HobbiesTableUpdateCompanionBuilder,
          (HobbyRow, $$HobbiesTableReferences),
          HobbyRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$HobbiesTableTableManager(_$AppDatabase db, $HobbiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HobbiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HobbiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HobbiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => HobbiesCompanion(entityId: entityId, rowid: rowid),
          createCompanionCallback: ({
            required String entityId,
            Value<int> rowid = const Value.absent(),
          }) => HobbiesCompanion.insert(entityId: entityId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HobbiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$HobbiesTableReferences
                            ._entityIdTable(db),
                        referencedColumn: $$HobbiesTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HobbiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HobbiesTable,
      HobbyRow,
      $$HobbiesTableFilterComposer,
      $$HobbiesTableOrderingComposer,
      $$HobbiesTableAnnotationComposer,
      $$HobbiesTableCreateCompanionBuilder,
      $$HobbiesTableUpdateCompanionBuilder,
      (HobbyRow, $$HobbiesTableReferences),
      HobbyRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String entityId,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> entityId,
  Value<int> rowid,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, GoalRow> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('goals__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, $$GoalsTableReferences),
          GoalRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => GoalsCompanion(entityId: entityId, rowid: rowid),
          createCompanionCallback: ({
            required String entityId,
            Value<int> rowid = const Value.absent(),
          }) => GoalsCompanion.insert(entityId: entityId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$GoalsTableReferences._entityIdTable(
                          db,
                        ),
                        referencedColumn: $$GoalsTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, $$GoalsTableReferences),
      GoalRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$RelationTypesTableCreateCompanionBuilder =
    RelationTypesCompanion Function({
      Value<String> id,
      required String key,
      required String label,
      required String inverseLabel,
      Value<bool> directed,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$RelationTypesTableUpdateCompanionBuilder =
    RelationTypesCompanion Function({
      Value<String> id,
      Value<String> key,
      Value<String> label,
      Value<String> inverseLabel,
      Value<bool> directed,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$RelationTypesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RelationTypesTable, RelationTypeRow> {
  $$RelationTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RelationsTable, List<RelationRow>>
  _relationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.relations,
    aliasName: 'relation_types__id__relations__relation_type_id',
  );

  $$RelationsTableProcessedTableManager get relationsRefs {
    final manager = $$RelationsTableTableManager(
      $_db,
      $_db.relations,
    ).filter((f) => f.relationTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_relationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RelationTypesTableFilterComposer
    extends Composer<_$AppDatabase, $RelationTypesTable> {
  $$RelationTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inverseLabel => $composableBuilder(
    column: $table.inverseLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get directed => $composableBuilder(
    column: $table.directed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> relationsRefs(
    Expression<bool> Function($$RelationsTableFilterComposer f) f,
  ) {
    final $$RelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.relationTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableFilterComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RelationTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationTypesTable> {
  $$RelationTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inverseLabel => $composableBuilder(
    column: $table.inverseLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get directed => $composableBuilder(
    column: $table.directed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RelationTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationTypesTable> {
  $$RelationTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get inverseLabel => $composableBuilder(
    column: $table.inverseLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get directed =>
      $composableBuilder(column: $table.directed, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> relationsRefs<T extends Object>(
    Expression<T> Function($$RelationsTableAnnotationComposer a) f,
  ) {
    final $$RelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.relations,
      getReferencedColumn: (t) => t.relationTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.relations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RelationTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RelationTypesTable,
          RelationTypeRow,
          $$RelationTypesTableFilterComposer,
          $$RelationTypesTableOrderingComposer,
          $$RelationTypesTableAnnotationComposer,
          $$RelationTypesTableCreateCompanionBuilder,
          $$RelationTypesTableUpdateCompanionBuilder,
          (RelationTypeRow, $$RelationTypesTableReferences),
          RelationTypeRow,
          PrefetchHooks Function({bool relationsRefs})
        > {
  $$RelationTypesTableTableManager(_$AppDatabase db, $RelationTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> inverseLabel = const Value.absent(),
                Value<bool> directed = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationTypesCompanion(
                id: id,
                key: key,
                label: label,
                inverseLabel: inverseLabel,
                directed: directed,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String key,
                required String label,
                required String inverseLabel,
                Value<bool> directed = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationTypesCompanion.insert(
                id: id,
                key: key,
                label: label,
                inverseLabel: inverseLabel,
                directed: directed,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RelationTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({relationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (relationsRefs) db.relations],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (relationsRefs)
                    await $_getPrefetchedData<
                      RelationTypeRow,
                      $RelationTypesTable,
                      RelationRow
                    >(
                      currentTable: table,
                      referencedTable: $$RelationTypesTableReferences
                          ._relationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RelationTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).relationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.relationTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RelationTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RelationTypesTable,
      RelationTypeRow,
      $$RelationTypesTableFilterComposer,
      $$RelationTypesTableOrderingComposer,
      $$RelationTypesTableAnnotationComposer,
      $$RelationTypesTableCreateCompanionBuilder,
      $$RelationTypesTableUpdateCompanionBuilder,
      (RelationTypeRow, $$RelationTypesTableReferences),
      RelationTypeRow,
      PrefetchHooks Function({bool relationsRefs})
    >;
typedef $$RelationsTableCreateCompanionBuilder = RelationsCompanion Function({
  Value<String> id,
  required String sourceEntityId,
  required String targetEntityId,
  required String relationTypeId,
  Value<String?> note,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$RelationsTableUpdateCompanionBuilder = RelationsCompanion Function({
  Value<String> id,
  Value<String> sourceEntityId,
  Value<String> targetEntityId,
  Value<String> relationTypeId,
  Value<String?> note,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$RelationsTableReferences
    extends BaseReferences<_$AppDatabase, $RelationsTable, RelationRow> {
  $$RelationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _sourceEntityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('relations__source_entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get sourceEntityId {
    final $_column = $_itemColumn<String>('source_entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceEntityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EntitiesTable _targetEntityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('relations__target_entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get targetEntityId {
    final $_column = $_itemColumn<String>('target_entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetEntityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RelationTypesTable _relationTypeIdTable(_$AppDatabase db) => db
      .relationTypes
      .createAlias('relations__relation_type_id__relation_types__id');

  $$RelationTypesTableProcessedTableManager get relationTypeId {
    final $_column = $_itemColumn<String>('relation_type_id')!;

    final manager = $$RelationTypesTableTableManager(
      $_db,
      $_db.relationTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relationTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RelationsTableFilterComposer
    extends Composer<_$AppDatabase, $RelationsTable> {
  $$RelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntitiesTableFilterComposer get sourceEntityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EntitiesTableFilterComposer get targetEntityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RelationTypesTableFilterComposer get relationTypeId {
    final $$RelationTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relationTypeId,
      referencedTable: $db.relationTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationTypesTableFilterComposer(
            $db: $db,
            $table: $db.relationTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationsTable> {
  $$RelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntitiesTableOrderingComposer get sourceEntityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EntitiesTableOrderingComposer get targetEntityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RelationTypesTableOrderingComposer get relationTypeId {
    final $$RelationTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relationTypeId,
      referencedTable: $db.relationTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationTypesTableOrderingComposer(
            $db: $db,
            $table: $db.relationTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationsTable> {
  $$RelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get sourceEntityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EntitiesTableAnnotationComposer get targetEntityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetEntityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RelationTypesTableAnnotationComposer get relationTypeId {
    final $$RelationTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relationTypeId,
      referencedTable: $db.relationTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RelationTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.relationTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RelationsTable,
          RelationRow,
          $$RelationsTableFilterComposer,
          $$RelationsTableOrderingComposer,
          $$RelationsTableAnnotationComposer,
          $$RelationsTableCreateCompanionBuilder,
          $$RelationsTableUpdateCompanionBuilder,
          (RelationRow, $$RelationsTableReferences),
          RelationRow,
          PrefetchHooks Function({
            bool sourceEntityId,
            bool targetEntityId,
            bool relationTypeId,
          })
        > {
  $$RelationsTableTableManager(_$AppDatabase db, $RelationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceEntityId = const Value.absent(),
                Value<String> targetEntityId = const Value.absent(),
                Value<String> relationTypeId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationsCompanion(
                id: id,
                sourceEntityId: sourceEntityId,
                targetEntityId: targetEntityId,
                relationTypeId: relationTypeId,
                note: note,
                metadata: metadata,
                createdAt: createdAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sourceEntityId,
                required String targetEntityId,
                required String relationTypeId,
                Value<String?> note = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationsCompanion.insert(
                id: id,
                sourceEntityId: sourceEntityId,
                targetEntityId: targetEntityId,
                relationTypeId: relationTypeId,
                note: note,
                metadata: metadata,
                createdAt: createdAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceEntityId = false,
                targetEntityId = false,
                relationTypeId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceEntityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceEntityId,
                            referencedTable: $$RelationsTableReferences
                                ._sourceEntityIdTable(db),
                            referencedColumn: $$RelationsTableReferences
                                ._sourceEntityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (targetEntityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetEntityId,
                            referencedTable: $$RelationsTableReferences
                                ._targetEntityIdTable(db),
                            referencedColumn: $$RelationsTableReferences
                                ._targetEntityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (relationTypeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.relationTypeId,
                            referencedTable: $$RelationsTableReferences
                                ._relationTypeIdTable(db),
                            referencedColumn: $$RelationsTableReferences
                                ._relationTypeIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RelationsTable,
      RelationRow,
      $$RelationsTableFilterComposer,
      $$RelationsTableOrderingComposer,
      $$RelationsTableAnnotationComposer,
      $$RelationsTableCreateCompanionBuilder,
      $$RelationsTableUpdateCompanionBuilder,
      (RelationRow, $$RelationsTableReferences),
      RelationRow,
      PrefetchHooks Function({
        bool sourceEntityId,
        bool targetEntityId,
        bool relationTypeId,
      })
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  required String title,
  Value<String?> description,
  Value<String> status,
  Value<String> priority,
  Value<DateTime?> dueAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> status,
  Value<String> priority,
  Value<DateTime?> dueAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                dueAt: dueAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                dueAt: dueAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityLinksTableCreateCompanionBuilder =
    ActivityLinksCompanion Function({
      Value<String> id,
      required String activityType,
      required String activityId,
      required String entityId,
      required String linkType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ActivityLinksTableUpdateCompanionBuilder =
    ActivityLinksCompanion Function({
      Value<String> id,
      Value<String> activityType,
      Value<String> activityId,
      Value<String> entityId,
      Value<String> linkType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ActivityLinksTableReferences
    extends
        BaseReferences<_$AppDatabase, $ActivityLinksTable, ActivityLinkRow> {
  $$ActivityLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('activity_links__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLinksTable> {
  $$ActivityLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkType => $composableBuilder(
    column: $table.linkType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLinksTable> {
  $$ActivityLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkType => $composableBuilder(
    column: $table.linkType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLinksTable> {
  $$ActivityLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkType =>
      $composableBuilder(column: $table.linkType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLinksTable,
          ActivityLinkRow,
          $$ActivityLinksTableFilterComposer,
          $$ActivityLinksTableOrderingComposer,
          $$ActivityLinksTableAnnotationComposer,
          $$ActivityLinksTableCreateCompanionBuilder,
          $$ActivityLinksTableUpdateCompanionBuilder,
          (ActivityLinkRow, $$ActivityLinksTableReferences),
          ActivityLinkRow,
          PrefetchHooks Function({bool entityId})
        > {
  $$ActivityLinksTableTableManager(_$AppDatabase db, $ActivityLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> linkType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLinksCompanion(
                id: id,
                activityType: activityType,
                activityId: activityId,
                entityId: entityId,
                linkType: linkType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String activityType,
                required String activityId,
                required String entityId,
                required String linkType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLinksCompanion.insert(
                id: id,
                activityType: activityType,
                activityId: activityId,
                entityId: entityId,
                linkType: linkType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$ActivityLinksTableReferences
                            ._entityIdTable(db),
                        referencedColumn: $$ActivityLinksTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLinksTable,
      ActivityLinkRow,
      $$ActivityLinksTableFilterComposer,
      $$ActivityLinksTableOrderingComposer,
      $$ActivityLinksTableAnnotationComposer,
      $$ActivityLinksTableCreateCompanionBuilder,
      $$ActivityLinksTableUpdateCompanionBuilder,
      (ActivityLinkRow, $$ActivityLinksTableReferences),
      ActivityLinkRow,
      PrefetchHooks Function({bool entityId})
    >;
typedef $$InboxItemsTableCreateCompanionBuilder = InboxItemsCompanion Function({
  Value<String> id,
  required String content,
  Value<DateTime> createdAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$InboxItemsTableUpdateCompanionBuilder = InboxItemsCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$InboxItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InboxItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InboxItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$InboxItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InboxItemsTable,
          InboxItemRow,
          $$InboxItemsTableFilterComposer,
          $$InboxItemsTableOrderingComposer,
          $$InboxItemsTableAnnotationComposer,
          $$InboxItemsTableCreateCompanionBuilder,
          $$InboxItemsTableUpdateCompanionBuilder,
          (
            InboxItemRow,
            BaseReferences<_$AppDatabase, $InboxItemsTable, InboxItemRow>,
          ),
          InboxItemRow,
          PrefetchHooks Function()
        > {
  $$InboxItemsTableTableManager(_$AppDatabase db, $InboxItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InboxItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InboxItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InboxItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InboxItemsCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InboxItemsCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InboxItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InboxItemsTable,
      InboxItemRow,
      $$InboxItemsTableFilterComposer,
      $$InboxItemsTableOrderingComposer,
      $$InboxItemsTableAnnotationComposer,
      $$InboxItemsTableCreateCompanionBuilder,
      $$InboxItemsTableUpdateCompanionBuilder,
      (
        InboxItemRow,
        BaseReferences<_$AppDatabase, $InboxItemsTable, InboxItemRow>,
      ),
      InboxItemRow,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  required String name,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagRow> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntityTagsTable, List<EntityTagRow>>
  _entityTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entityTags,
    aliasName: 'tags__id__entity_tags__tag_id',
  );

  $$EntityTagsTableProcessedTableManager get entityTagsRefs {
    final manager = $$EntityTagsTableTableManager(
      $_db,
      $_db.entityTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entityTagsRefs(
    Expression<bool> Function($$EntityTagsTableFilterComposer f) f,
  ) {
    final $$EntityTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTagsTableFilterComposer(
            $db: $db,
            $table: $db.entityTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> entityTagsRefs<T extends Object>(
    Expression<T> Function($$EntityTagsTableAnnotationComposer a) f,
  ) {
    final $$EntityTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.entityTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, $$TagsTableReferences),
          TagRow,
          PrefetchHooks Function({bool entityTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({entityTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entityTagsRefs) db.entityTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entityTagsRefs)
                    await $_getPrefetchedData<TagRow, $TagsTable, EntityTagRow>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._entityTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).entityTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, $$TagsTableReferences),
      TagRow,
      PrefetchHooks Function({bool entityTagsRefs})
    >;
typedef $$EntityTagsTableCreateCompanionBuilder = EntityTagsCompanion Function({
  required String entityId,
  required String tagId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$EntityTagsTableUpdateCompanionBuilder = EntityTagsCompanion Function({
  Value<String> entityId,
  Value<String> tagId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$EntityTagsTableReferences
    extends BaseReferences<_$AppDatabase, $EntityTagsTable, EntityTagRow> {
  $$EntityTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias('entity_tags__entity_id__entities__id');

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager(
      $_db,
      $_db.entities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('entity_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntityTagsTableFilterComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableFilterComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableOrderingComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entityId,
      referencedTable: $db.entities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.entities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntityTagsTable,
          EntityTagRow,
          $$EntityTagsTableFilterComposer,
          $$EntityTagsTableOrderingComposer,
          $$EntityTagsTableAnnotationComposer,
          $$EntityTagsTableCreateCompanionBuilder,
          $$EntityTagsTableUpdateCompanionBuilder,
          (EntityTagRow, $$EntityTagsTableReferences),
          EntityTagRow,
          PrefetchHooks Function({bool entityId, bool tagId})
        > {
  $$EntityTagsTableTableManager(_$AppDatabase db, $EntityTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntityTagsCompanion(
                entityId: entityId,
                tagId: tagId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                required String tagId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntityTagsCompanion.insert(
                entityId: entityId,
                tagId: tagId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntityTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entityId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entityId,
                        referencedTable: $$EntityTagsTableReferences
                            ._entityIdTable(db),
                        referencedColumn: $$EntityTagsTableReferences
                            ._entityIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$EntityTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$EntityTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EntityTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntityTagsTable,
      EntityTagRow,
      $$EntityTagsTableFilterComposer,
      $$EntityTagsTableOrderingComposer,
      $$EntityTagsTableAnnotationComposer,
      $$EntityTagsTableCreateCompanionBuilder,
      $$EntityTagsTableUpdateCompanionBuilder,
      (EntityTagRow, $$EntityTagsTableReferences),
      EntityTagRow,
      PrefetchHooks Function({bool entityId, bool tagId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntitiesTableTableManager get entities =>
      $$EntitiesTableTableManager(_db, _db.entities);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$AreasTableTableManager get areas =>
      $$AreasTableTableManager(_db, _db.areas);
  $$ResourcesTableTableManager get resources =>
      $$ResourcesTableTableManager(_db, _db.resources);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$HobbiesTableTableManager get hobbies =>
      $$HobbiesTableTableManager(_db, _db.hobbies);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$RelationTypesTableTableManager get relationTypes =>
      $$RelationTypesTableTableManager(_db, _db.relationTypes);
  $$RelationsTableTableManager get relations =>
      $$RelationsTableTableManager(_db, _db.relations);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ActivityLinksTableTableManager get activityLinks =>
      $$ActivityLinksTableTableManager(_db, _db.activityLinks);
  $$InboxItemsTableTableManager get inboxItems =>
      $$InboxItemsTableTableManager(_db, _db.inboxItems);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$EntityTagsTableTableManager get entityTags =>
      $$EntityTagsTableTableManager(_db, _db.entityTags);
}
