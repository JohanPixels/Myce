import 'package:flutter/widgets.dart';

import '../../activities/domain/task_enums.dart';
import '../../entities/domain/entity_type.dart';

/// Todos los íconos de Myce en un solo lugar: Phosphor (MIT), usado
/// directo desde sus fuentes en `assets/fonts/phosphor/` y no con el paquete
/// `phosphor_flutter` — ese paquete dejó de compilar con Flutter actual
/// (extiende `IconData`, que ahora es `final`) y no se actualiza desde 2024.
/// Las fuentes no envejecen: los códigos de cada ícono salen de su tabla y
/// no cambian. Las pantallas usan estos nombres y nunca los códigos
/// directo: cambiar de librería o de ícono es tocar solo este archivo.
///
/// Todo es `const`: el build de release recorta las fuentes a los íconos
/// realmente usados (tree shaking de íconos).
///
/// Dos pesos, a propósito: **línea** (`AppIcons`) para lo chico y lo que se
/// repite (botones, filas, menús), y **duotono** (`AppIconsDuo`, se dibuja
/// con [IconoDuo]) para lo que tiene protagonismo — la sección activa en la
/// barra, los estados vacíos, los tipos al clasificar.
abstract final class AppIcons {
  // Secciones
  static const IconData ahora = IconData(0xe2de, fontFamily: _linea);
  static const IconData inbox = IconData(0xe4aa, fontFamily: _linea);
  static const IconData tarea = IconData(0xe184, fontFamily: _linea);
  static const IconData proyecto = IconData(0xe3fe, fontFamily: _linea);
  static const IconData area = IconData(0xe7ae, fontFamily: _linea);
  static const IconData recurso = IconData(0xe0e6, fontFamily: _linea);
  static const IconData nota = IconData(0xe63e, fontFamily: _linea);
  static const IconData revision = IconData(0xe198, fontFamily: _linea);
  static const IconData personas = IconData(0xe4d6, fontFamily: _linea);
  static const IconData persona = IconData(0xe4c2, fontFamily: _linea);
  static const IconData hobby = IconData(0xe26e, fontFamily: _linea);
  static const IconData meta = IconData(0xe244, fontFamily: _linea);

  // Tipos de cosas dentro de un proyecto
  static const IconData documento = IconData(0xe23a, fontFamily: _linea);
  static const IconData observacion = IconData(0xe220, fontFamily: _linea);
  static const IconData idea = IconData(0xe2dc, fontFamily: _linea);
  static const IconData requisito = IconData(0xe606, fontFamily: _linea);
  static const IconData tareaHecha = IconData(0xe184, fontFamily: _relleno);
  static const IconData siguiente = IconData(0xe02e, fontFamily: _linea);
  static const IconData despues = IconData(0xe2b8, fontFamily: _linea);
  static const IconData brote = IconData(0xebae, fontFamily: _linea);
  static const IconData conexiones = IconData(0xeb58, fontFamily: _linea);

  // Acciones
  static const IconData agregar = IconData(0xe3d4, fontFamily: _linea);
  static const IconData capturar = IconData(0xe3d6, fontFamily: _linea);
  static const IconData agregarTarea = IconData(0xe3d6, fontFamily: _linea);
  static const IconData cerrar = IconData(0xe4f6, fontFamily: _linea);
  static const IconData editar = IconData(0xe3b4, fontFamily: _linea);
  static const IconData eliminar = IconData(0xe4a6, fontFamily: _linea);
  static const IconData copiar = IconData(0xe1ca, fontFamily: _linea);
  static const IconData buscar = IconData(0xe30c, fontFamily: _linea);
  static const IconData sync = IconData(0xe094, fontFamily: _linea);
  static const IconData recargar = IconData(0xe036, fontFamily: _linea);
  static const IconData ajustes = IconData(0xe272, fontFamily: _linea);
  static const IconData enviar = IconData(0xe396, fontFamily: _linea);
  static const IconData salir = IconData(0xe42a, fontFamily: _linea);
  static const IconData conectar = IconData(0xe2e2, fontFamily: _linea);
  static const IconData enlace = IconData(0xe2e2, fontFamily: _linea);
  static const IconData desconectar = IconData(0xe2e4, fontFamily: _linea);
  static const IconData calendario = IconData(0xe10a, fontFamily: _linea);
  static const IconData mas = IconData(0xe1fe, fontFamily: _linea);
  static const IconData vistaPrevia = IconData(0xe220, fontFamily: _linea);
  static const IconData pantallaCompleta = IconData(0xe0a2, fontFamily: _linea);
  static const IconData indice = IconData(0xe2f2, fontFamily: _linea);
  static const IconData alerta = IconData(0xe4e2, fontFamily: _linea);
  static const IconData prioridad = IconData(0xe244, fontFamily: _relleno);
  static const IconData check = IconData(0xe182, fontFamily: _linea);

  // Navegación
  static const IconData atras = IconData(0xe058, fontFamily: _linea);
  static const IconData flechaDerecha = IconData(0xe06c, fontFamily: _linea);
  static const IconData caretDerecha = IconData(0xe13a, fontFamily: _linea);
  static const IconData caretAbajo = IconData(0xe136, fontFamily: _linea);

  // Editor de texto
  static const IconData titulo = IconData(0xe6ba, fontFamily: _linea);
  static const IconData negrita = IconData(0xe5be, fontFamily: _linea);
  static const IconData lista = IconData(0xe2f4, fontFamily: _linea);
  static const IconData casilla = IconData(0xe186, fontFamily: _linea);

  // Selección
  static const IconData radioOff = IconData(0xe18a, fontFamily: _linea);
  static const IconData radioOn = IconData(0xeb08, fontFamily: _linea);

  // Tema
  static const IconData temaSistema = IconData(0xe18c, fontFamily: _linea);
  static const IconData temaClaro = IconData(0xe472, fontFamily: _linea);
  static const IconData temaOscuro = IconData(0xe330, fontFamily: _linea);

  /// Ahora / Siguiente / Después.
  static IconData deHorizonte(TaskHorizon h) => switch (h) {
    TaskHorizon.now => ahora,
    TaskHorizon.next => siguiente,
    TaskHorizon.later => despues,
  };

  /// Ícono de línea para cada tipo de Entity.
  static IconData deTipo(EntityType type) => switch (type) {
    EntityType.project => proyecto,
    EntityType.area => area,
    EntityType.resource => recurso,
    EntityType.note => nota,
    EntityType.person => persona,
    EntityType.hobby => hobby,
    EntityType.goal => meta,
  };
}

/// Versiones duotono (con relleno suave detrás) — se dibujan con [IconoDuo].
abstract final class AppIconsDuo {
  static const ahora = IconoDuoData(
    IconData(0xe2df, fontFamily: _duo),
    IconData(0xe2de, fontFamily: _duo),
  );
  static const inbox = IconoDuoData(
    IconData(0xe4ab, fontFamily: _duo),
    IconData(0xe4aa, fontFamily: _duo),
  );
  static const tarea = IconoDuoData(
    IconData(0xe185, fontFamily: _duo),
    IconData(0xe184, fontFamily: _duo),
  );
  static const proyecto = IconoDuoData(
    IconData(0xe401, fontFamily: _duo),
    IconData(0xe3fe, fontFamily: _duo),
  );
  static const area = IconoDuoData(
    IconData(0xe7af, fontFamily: _duo),
    IconData(0xe7ae, fontFamily: _duo),
  );
  static const recurso = IconoDuoData(
    IconData(0xe0e7, fontFamily: _duo),
    IconData(0xe0e6, fontFamily: _duo),
  );
  static const nota = IconoDuoData(
    IconData(0xe63f, fontFamily: _duo),
    IconData(0xe63e, fontFamily: _duo),
  );
  static const revision = IconoDuoData(
    IconData(0xe199, fontFamily: _duo),
    IconData(0xe198, fontFamily: _duo),
  );
  static const personas = IconoDuoData(
    IconData(0xe4d7, fontFamily: _duo),
    IconData(0xe4d6, fontFamily: _duo),
  );
  static const persona = IconoDuoData(
    IconData(0xe4c3, fontFamily: _duo),
    IconData(0xe4c2, fontFamily: _duo),
  );
  static const hobby = IconoDuoData(
    IconData(0xe26f, fontFamily: _duo),
    IconData(0xe26e, fontFamily: _duo),
  );
  static const meta = IconoDuoData(
    IconData(0xe245, fontFamily: _duo),
    IconData(0xe244, fontFamily: _duo),
  );
  static const documento = IconoDuoData(
    IconData(0xe23b, fontFamily: _duo),
    IconData(0xe23a, fontFamily: _duo),
  );
  static const observacion = IconoDuoData(
    IconData(0xe221, fontFamily: _duo),
    IconData(0xe220, fontFamily: _duo),
  );
  static const idea = IconoDuoData(
    IconData(0xe2dd, fontFamily: _duo),
    IconData(0xe2dc, fontFamily: _duo),
  );
  static const requisito = IconoDuoData(
    IconData(0xe607, fontFamily: _duo),
    IconData(0xe606, fontFamily: _duo),
  );
  static const brote = IconoDuoData(
    IconData(0xebaf, fontFamily: _duo),
    IconData(0xebae, fontFamily: _duo),
  );
  static const conexiones = IconoDuoData(
    IconData(0xeb59, fontFamily: _duo),
    IconData(0xeb58, fontFamily: _duo),
  );
  static const sinProximaAccion = IconoDuoData(
    IconData(0xe1c9, fontFamily: _duo),
    IconData(0xe1c8, fontFamily: _duo),
  );
  static const celebrar = IconoDuoData(
    IconData(0xe81b, fontFamily: _duo),
    IconData(0xe81a, fontFamily: _duo),
  );

  static const buscar = IconoDuoData(
    IconData(0xe30d, fontFamily: _duo),
    IconData(0xe30c, fontFamily: _duo),
  );
  static const sinResultados = IconoDuoData(
    IconData(0xe62b, fontFamily: _duo),
    IconData(0xe62a, fontFamily: _duo),
  );

  static IconoDuoData deTipo(EntityType type) => switch (type) {
    EntityType.project => proyecto,
    EntityType.area => area,
    EntityType.resource => recurso,
    EntityType.note => nota,
    EntityType.person => persona,
    EntityType.hobby => hobby,
    EntityType.goal => meta,
  };
}

const _linea = 'PhosphorRegular';
const _relleno = 'PhosphorFill';
const _duo = 'PhosphorDuotone';

/// Un ícono duotono de Phosphor son dos glifos de la misma fuente: la
/// figura ([primario]) y su relleno ([secundario]), que se dibujan uno
/// encima del otro.
class IconoDuoData {
  const IconoDuoData(this.primario, this.secundario);

  final IconData primario;
  final IconData secundario;
}

/// Dibuja un ícono duotono: el relleno va en el mismo color con poca
/// opacidad, así el ícono hereda el color del contexto.
class IconoDuo extends StatelessWidget {
  const IconoDuo(this.icono, {super.key, this.size, this.color});

  final IconoDuoData icono;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color;
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(icono.secundario, size: size, color: c?.withValues(alpha: 0.28)),
        Icon(icono.primario, size: size, color: c),
      ],
    );
  }
}
