enum NodeType { proyecto, area, recurso, wishlist }

enum NodeEstado { activo, pausado, someday, archivado }

enum WishlistSubtipo { juegos, musica, peliculas, libros }

extension NodeTypeParsing on String? {
  NodeType? toNodeType() => this == null ? null : NodeType.values.byName(this!);
}

extension NodeEstadoParsing on String {
  NodeEstado toNodeEstado() => NodeEstado.values.byName(this);
}
