// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NodesTable extends Nodes with TableInfo<$NodesTable, NodeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtipoMeta = const VerificationMeta(
    'subtipo',
  );
  @override
  late final GeneratedColumn<String> subtipo = GeneratedColumn<String>(
    'subtipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cuerpoMeta = const VerificationMeta('cuerpo');
  @override
  late final GeneratedColumn<String> cuerpo = GeneratedColumn<String>(
    'cuerpo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('activo'),
  );
  static const VerificationMeta _areaRelacionadaIdMeta = const VerificationMeta(
    'areaRelacionadaId',
  );
  @override
  late final GeneratedColumn<String> areaRelacionadaId =
      GeneratedColumn<String>(
        'area_relacionada_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaUltimoToqueMeta = const VerificationMeta(
    'fechaUltimoToque',
  );
  @override
  late final GeneratedColumn<DateTime> fechaUltimoToque =
      GeneratedColumn<DateTime>(
        'fecha_ultimo_toque',
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
    tipo,
    subtipo,
    titulo,
    cuerpo,
    estado,
    areaRelacionadaId,
    fechaCreacion,
    fechaUltimoToque,
    dirty,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('subtipo')) {
      context.handle(
        _subtipoMeta,
        subtipo.isAcceptableOrUnknown(data['subtipo']!, _subtipoMeta),
      );
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('cuerpo')) {
      context.handle(
        _cuerpoMeta,
        cuerpo.isAcceptableOrUnknown(data['cuerpo']!, _cuerpoMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('area_relacionada_id')) {
      context.handle(
        _areaRelacionadaIdMeta,
        areaRelacionadaId.isAcceptableOrUnknown(
          data['area_relacionada_id']!,
          _areaRelacionadaIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_ultimo_toque')) {
      context.handle(
        _fechaUltimoToqueMeta,
        fechaUltimoToque.isAcceptableOrUnknown(
          data['fecha_ultimo_toque']!,
          _fechaUltimoToqueMeta,
        ),
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
  NodeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      ),
      subtipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtipo'],
      ),
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      cuerpo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuerpo'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      areaRelacionadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_relacionada_id'],
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaUltimoToque: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_ultimo_toque'],
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
  $NodesTable createAlias(String alias) {
    return $NodesTable(attachedDatabase, alias);
  }
}

class NodeEntry extends DataClass implements Insertable<NodeEntry> {
  final String id;
  final String? tipo;
  final String? subtipo;
  final String titulo;
  final String? cuerpo;
  final String estado;
  final String? areaRelacionadaId;
  final DateTime fechaCreacion;
  final DateTime fechaUltimoToque;
  final bool dirty;
  final DateTime? deletedAt;
  const NodeEntry({
    required this.id,
    this.tipo,
    this.subtipo,
    required this.titulo,
    this.cuerpo,
    required this.estado,
    this.areaRelacionadaId,
    required this.fechaCreacion,
    required this.fechaUltimoToque,
    required this.dirty,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || tipo != null) {
      map['tipo'] = Variable<String>(tipo);
    }
    if (!nullToAbsent || subtipo != null) {
      map['subtipo'] = Variable<String>(subtipo);
    }
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || cuerpo != null) {
      map['cuerpo'] = Variable<String>(cuerpo);
    }
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || areaRelacionadaId != null) {
      map['area_relacionada_id'] = Variable<String>(areaRelacionadaId);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_ultimo_toque'] = Variable<DateTime>(fechaUltimoToque);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  NodesCompanion toCompanion(bool nullToAbsent) {
    return NodesCompanion(
      id: Value(id),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
      subtipo: subtipo == null && nullToAbsent
          ? const Value.absent()
          : Value(subtipo),
      titulo: Value(titulo),
      cuerpo: cuerpo == null && nullToAbsent
          ? const Value.absent()
          : Value(cuerpo),
      estado: Value(estado),
      areaRelacionadaId: areaRelacionadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(areaRelacionadaId),
      fechaCreacion: Value(fechaCreacion),
      fechaUltimoToque: Value(fechaUltimoToque),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory NodeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeEntry(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<String?>(json['tipo']),
      subtipo: serializer.fromJson<String?>(json['subtipo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      cuerpo: serializer.fromJson<String?>(json['cuerpo']),
      estado: serializer.fromJson<String>(json['estado']),
      areaRelacionadaId: serializer.fromJson<String?>(
        json['areaRelacionadaId'],
      ),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaUltimoToque: serializer.fromJson<DateTime>(json['fechaUltimoToque']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<String?>(tipo),
      'subtipo': serializer.toJson<String?>(subtipo),
      'titulo': serializer.toJson<String>(titulo),
      'cuerpo': serializer.toJson<String?>(cuerpo),
      'estado': serializer.toJson<String>(estado),
      'areaRelacionadaId': serializer.toJson<String?>(areaRelacionadaId),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaUltimoToque': serializer.toJson<DateTime>(fechaUltimoToque),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  NodeEntry copyWith({
    String? id,
    Value<String?> tipo = const Value.absent(),
    Value<String?> subtipo = const Value.absent(),
    String? titulo,
    Value<String?> cuerpo = const Value.absent(),
    String? estado,
    Value<String?> areaRelacionadaId = const Value.absent(),
    DateTime? fechaCreacion,
    DateTime? fechaUltimoToque,
    bool? dirty,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => NodeEntry(
    id: id ?? this.id,
    tipo: tipo.present ? tipo.value : this.tipo,
    subtipo: subtipo.present ? subtipo.value : this.subtipo,
    titulo: titulo ?? this.titulo,
    cuerpo: cuerpo.present ? cuerpo.value : this.cuerpo,
    estado: estado ?? this.estado,
    areaRelacionadaId: areaRelacionadaId.present
        ? areaRelacionadaId.value
        : this.areaRelacionadaId,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaUltimoToque: fechaUltimoToque ?? this.fechaUltimoToque,
    dirty: dirty ?? this.dirty,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  NodeEntry copyWithCompanion(NodesCompanion data) {
    return NodeEntry(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      subtipo: data.subtipo.present ? data.subtipo.value : this.subtipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      cuerpo: data.cuerpo.present ? data.cuerpo.value : this.cuerpo,
      estado: data.estado.present ? data.estado.value : this.estado,
      areaRelacionadaId: data.areaRelacionadaId.present
          ? data.areaRelacionadaId.value
          : this.areaRelacionadaId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaUltimoToque: data.fechaUltimoToque.present
          ? data.fechaUltimoToque.value
          : this.fechaUltimoToque,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeEntry(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('subtipo: $subtipo, ')
          ..write('titulo: $titulo, ')
          ..write('cuerpo: $cuerpo, ')
          ..write('estado: $estado, ')
          ..write('areaRelacionadaId: $areaRelacionadaId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaUltimoToque: $fechaUltimoToque, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    subtipo,
    titulo,
    cuerpo,
    estado,
    areaRelacionadaId,
    fechaCreacion,
    fechaUltimoToque,
    dirty,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeEntry &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.subtipo == this.subtipo &&
          other.titulo == this.titulo &&
          other.cuerpo == this.cuerpo &&
          other.estado == this.estado &&
          other.areaRelacionadaId == this.areaRelacionadaId &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaUltimoToque == this.fechaUltimoToque &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt);
}

class NodesCompanion extends UpdateCompanion<NodeEntry> {
  final Value<String> id;
  final Value<String?> tipo;
  final Value<String?> subtipo;
  final Value<String> titulo;
  final Value<String?> cuerpo;
  final Value<String> estado;
  final Value<String?> areaRelacionadaId;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaUltimoToque;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const NodesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.subtipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.cuerpo = const Value.absent(),
    this.estado = const Value.absent(),
    this.areaRelacionadaId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaUltimoToque = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodesCompanion.insert({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.subtipo = const Value.absent(),
    required String titulo,
    this.cuerpo = const Value.absent(),
    this.estado = const Value.absent(),
    this.areaRelacionadaId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaUltimoToque = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : titulo = Value(titulo);
  static Insertable<NodeEntry> custom({
    Expression<String>? id,
    Expression<String>? tipo,
    Expression<String>? subtipo,
    Expression<String>? titulo,
    Expression<String>? cuerpo,
    Expression<String>? estado,
    Expression<String>? areaRelacionadaId,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaUltimoToque,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (subtipo != null) 'subtipo': subtipo,
      if (titulo != null) 'titulo': titulo,
      if (cuerpo != null) 'cuerpo': cuerpo,
      if (estado != null) 'estado': estado,
      if (areaRelacionadaId != null) 'area_relacionada_id': areaRelacionadaId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaUltimoToque != null) 'fecha_ultimo_toque': fechaUltimoToque,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodesCompanion copyWith({
    Value<String>? id,
    Value<String?>? tipo,
    Value<String?>? subtipo,
    Value<String>? titulo,
    Value<String?>? cuerpo,
    Value<String>? estado,
    Value<String?>? areaRelacionadaId,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaUltimoToque,
    Value<bool>? dirty,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return NodesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      subtipo: subtipo ?? this.subtipo,
      titulo: titulo ?? this.titulo,
      cuerpo: cuerpo ?? this.cuerpo,
      estado: estado ?? this.estado,
      areaRelacionadaId: areaRelacionadaId ?? this.areaRelacionadaId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaUltimoToque: fechaUltimoToque ?? this.fechaUltimoToque,
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
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (subtipo.present) {
      map['subtipo'] = Variable<String>(subtipo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (cuerpo.present) {
      map['cuerpo'] = Variable<String>(cuerpo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (areaRelacionadaId.present) {
      map['area_relacionada_id'] = Variable<String>(areaRelacionadaId.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaUltimoToque.present) {
      map['fecha_ultimo_toque'] = Variable<DateTime>(fechaUltimoToque.value);
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
    return (StringBuffer('NodesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('subtipo: $subtipo, ')
          ..write('titulo: $titulo, ')
          ..write('cuerpo: $cuerpo, ')
          ..write('estado: $estado, ')
          ..write('areaRelacionadaId: $areaRelacionadaId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaUltimoToque: $fechaUltimoToque, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NodesTable nodes = $NodesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [nodes];
}

typedef $$NodesTableCreateCompanionBuilder = NodesCompanion Function({
  Value<String> id,
  Value<String?> tipo,
  Value<String?> subtipo,
  required String titulo,
  Value<String?> cuerpo,
  Value<String> estado,
  Value<String?> areaRelacionadaId,
  Value<DateTime> fechaCreacion,
  Value<DateTime> fechaUltimoToque,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$NodesTableUpdateCompanionBuilder = NodesCompanion Function({
  Value<String> id,
  Value<String?> tipo,
  Value<String?> subtipo,
  Value<String> titulo,
  Value<String?> cuerpo,
  Value<String> estado,
  Value<String?> areaRelacionadaId,
  Value<DateTime> fechaCreacion,
  Value<DateTime> fechaUltimoToque,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$NodesTableFilterComposer extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtipo => $composableBuilder(
    column: $table.subtipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuerpo => $composableBuilder(
    column: $table.cuerpo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get areaRelacionadaId => $composableBuilder(
    column: $table.areaRelacionadaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaUltimoToque => $composableBuilder(
    column: $table.fechaUltimoToque,
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

class $$NodesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtipo => $composableBuilder(
    column: $table.subtipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuerpo => $composableBuilder(
    column: $table.cuerpo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get areaRelacionadaId => $composableBuilder(
    column: $table.areaRelacionadaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaUltimoToque => $composableBuilder(
    column: $table.fechaUltimoToque,
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

class $$NodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get subtipo =>
      $composableBuilder(column: $table.subtipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get cuerpo =>
      $composableBuilder(column: $table.cuerpo, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get areaRelacionadaId => $composableBuilder(
    column: $table.areaRelacionadaId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaUltimoToque => $composableBuilder(
    column: $table.fechaUltimoToque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$NodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodesTable,
          NodeEntry,
          $$NodesTableFilterComposer,
          $$NodesTableOrderingComposer,
          $$NodesTableAnnotationComposer,
          $$NodesTableCreateCompanionBuilder,
          $$NodesTableUpdateCompanionBuilder,
          (NodeEntry, BaseReferences<_$AppDatabase, $NodesTable, NodeEntry>),
          NodeEntry,
          PrefetchHooks Function()
        > {
  $$NodesTableTableManager(_$AppDatabase db, $NodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> tipo = const Value.absent(),
                Value<String?> subtipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> cuerpo = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> areaRelacionadaId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaUltimoToque = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion(
                id: id,
                tipo: tipo,
                subtipo: subtipo,
                titulo: titulo,
                cuerpo: cuerpo,
                estado: estado,
                areaRelacionadaId: areaRelacionadaId,
                fechaCreacion: fechaCreacion,
                fechaUltimoToque: fechaUltimoToque,
                dirty: dirty,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> tipo = const Value.absent(),
                Value<String?> subtipo = const Value.absent(),
                required String titulo,
                Value<String?> cuerpo = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> areaRelacionadaId = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaUltimoToque = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion.insert(
                id: id,
                tipo: tipo,
                subtipo: subtipo,
                titulo: titulo,
                cuerpo: cuerpo,
                estado: estado,
                areaRelacionadaId: areaRelacionadaId,
                fechaCreacion: fechaCreacion,
                fechaUltimoToque: fechaUltimoToque,
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

typedef $$NodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodesTable,
      NodeEntry,
      $$NodesTableFilterComposer,
      $$NodesTableOrderingComposer,
      $$NodesTableAnnotationComposer,
      $$NodesTableCreateCompanionBuilder,
      $$NodesTableUpdateCompanionBuilder,
      (NodeEntry, BaseReferences<_$AppDatabase, $NodesTable, NodeEntry>),
      NodeEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db, _db.nodes);
}
