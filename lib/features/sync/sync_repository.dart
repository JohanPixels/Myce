import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/database/app_database.dart';

// NOTA: esto sube solo `entities` (la tabla de identidad común) — todavía no
// sincroniza relations/tasks/activity_links/tablas de tipo. Es el mínimo
// para desbloquear el paso 4; sync multi-tabla completo queda pendiente
// hasta definir el schema de Supabase (paso 5, docs/fuente_de_verdad.md §16).
Future<List<EntityRow>> _obtenerEntitiesSucias(AppDatabase db) {
  return (db.select(db.entities)..where((e) => e.dirty.equals(true))).get();
}

Map<String, dynamic> _aSupabaseMap(EntityRow entity, String userId) {
  return {
    'id': entity.id,
    'user_id': userId,
    'type': entity.type,
    'title': entity.title,
    'description': entity.description,
    'status': entity.status,
    'created_at': entity.createdAt.toIso8601String(),
    'updated_at': entity.updatedAt.toIso8601String(),
    'deleted_at': entity.deletedAt?.toIso8601String(),
  };
}

Future<void> pushDirtyEntities(AppDatabase db) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return; // sin sesión, no hay a dónde subir
  final entitiesSucias = await _obtenerEntitiesSucias(db);
  if (entitiesSucias.isEmpty) return;
  final client = Supabase.instance.client;
  for (final entity in entitiesSucias) {
    try {
      await client.from('entities').upsert(_aSupabaseMap(entity, userId));
      await (db.update(
        db.entities,
      )..where((e) => e.id.equals(entity.id))).write(
        const EntitiesCompanion(dirty: Value(false)),
      );
    } catch (e) {
      // no tocamos dirty: se reintenta solo en el próximo ciclo de sync
    }
  }
}
