import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_provider.dart';

/// Dónde va el botón flotante de captura rápida (el "+"). `oculto` lo
/// quita y la captura pasa a un ícono en la barra superior — capturar
/// rápido tiene que seguir a un toque de distancia.
enum CaptureButtonPosition { derecha, centro, izquierda, oculto }

extension CaptureButtonPositionLabel on CaptureButtonPosition {
  String get label => switch (this) {
    CaptureButtonPosition.derecha => 'Derecha',
    CaptureButtonPosition.centro => 'Centro',
    CaptureButtonPosition.izquierda => 'Izquierda',
    CaptureButtonPosition.oculto => 'Arriba',
  };

  FloatingActionButtonLocation get location => switch (this) {
    CaptureButtonPosition.izquierda => FloatingActionButtonLocation.startFloat,
    CaptureButtonPosition.centro => FloatingActionButtonLocation.centerFloat,
    _ => FloatingActionButtonLocation.endFloat,
  };
}

const _clave = 'capture_button_position';

/// Preferencia del dispositivo (no se sincroniza), igual que el tema.
class CaptureButtonNotifier extends Notifier<CaptureButtonPosition> {
  @override
  CaptureButtonPosition build() {
    final guardado = ref.watch(sharedPreferencesProvider).getString(_clave);
    return CaptureButtonPosition.values.asNameMap()[guardado] ??
        CaptureButtonPosition.derecha;
  }

  void set(CaptureButtonPosition posicion) {
    state = posicion;
    ref.read(sharedPreferencesProvider).setString(_clave, posicion.name);
  }
}

final captureButtonProvider =
    NotifierProvider<CaptureButtonNotifier, CaptureButtonPosition>(
      CaptureButtonNotifier.new,
    );
