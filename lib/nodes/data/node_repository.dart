import 'package:drift/drift.dart';

import 'database.dart';

class NodeRepository {
  NodeRepository(this._db);
  final AppDatabase _db;

  Future<void> capturar(String titulo) {
    return _db
        .into(_db.nodes)
        .insert(
          NodesCompanion.insert(
            titulo: titulo,
            tipo: const Value.absent(), // queda en Inbox
          ),
        );
  }

  Stream<List<NodeEntry>> watchInbox() => _db.watchInbox();

  Stream<List<NodeEntry>> watchPorTipo(String tipo) => _db.watchPorTipo(tipo);

  Future<void> tocar(String id) {
    return (_db.update(_db.nodes)..where((n) => n.id.equals(id))).write(
      NodesCompanion(fechaUltimoToque: Value(DateTime.now())),
    );
  }

  Future<void> clasificar(String id, {required String tipo, String? subtipo}) {
    final estadoInicial = tipo == 'wishlist' ? 'someday' : 'activo';
    return (_db.update(_db.nodes)..where((n) => n.id.equals(id))).write(
      NodesCompanion(
        tipo: Value(tipo),
        subtipo: Value(subtipo),
        estado: Value(estadoInicial),
        fechaUltimoToque: Value(DateTime.now()),
      ),
    );
  }

  Future<void> cambiarEstado(String id, String estado) {
    return (_db.update(_db.nodes)..where((n) => n.id.equals(id))).write(
      NodesCompanion(
        estado: Value(estado),
        fechaUltimoToque: Value(DateTime.now()),
      ),
    );
  }

  Future<List<NodeEntry>> nodosActivos() => _db.nodosActivos();
  Future<List<NodeEntry>> nodosEstancados(int diasSinTocar) =>
      _db.nodosEstancados(diasSinTocar);
  Future<List<NodeEntry>> wishlistSugerencias(int cantidad) =>
      _db.wishlistSugerencias(cantidad);
}
