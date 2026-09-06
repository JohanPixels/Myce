import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../nodes/data/database.dart'; // ajusta la ruta a donde tengas database.dart

Future<List<NodeEntry>> _obtenerNodosSucios(AppDatabase db) {
  return (db.select(db.nodes)..where((n) => n.dirty.equals(true))).get();
}

Map<String, dynamic> _aSupabaseMap(NodeEntry node, String userId) {
  return {
    'id': node.id,
    'user_id': userId,
    'tipo': node.tipo,
    'subtipo': node.subtipo,
    'titulo': node.titulo,
    'cuerpo': node.cuerpo,
    'estado': node.estado,
    'area_relacionada': node.areaRelacionadaId,
    'fecha_creacion': node.fechaCreacion.toIso8601String(),
    'fecha_ultimo_toque': node.fechaUltimoToque.toIso8601String(),
    'deleted_at': node.deletedAt?.toIso8601String(),
  };
}

Future<void> pushDirtyNodes(AppDatabase db) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return; // sin sesión, no hay a dónde subir
  final nodosSucios = await _obtenerNodosSucios(db);
  if (nodosSucios.isEmpty) return;
  final client = Supabase.instance.client;
  for (final node in nodosSucios) {
    try {
      await client.from('nodes').upsert(_aSupabaseMap(node, userId));
      await (db.update(db.nodes)..where((n) => n.id.equals(node.id))).write(
        const NodesCompanion(dirty: Value(false)),
      );
    } catch (e) {
      // no tocamos dirty: se reintenta solo en el próximo ciclo de sync
    }
  }
}
