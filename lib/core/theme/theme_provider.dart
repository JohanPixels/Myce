import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Se inyecta en main.dart (override del ProviderScope) ya cargado, así el
/// tema guardado se aplica desde el primer frame sin parpadeo.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('override en main.dart'),
);

const _claveTema = 'theme_mode';

/// Preferencia de tema del dispositivo (Sistema / Claro / Oscuro). Vive en
/// SharedPreferences y no en la base: es de este dispositivo, no se
/// sincroniza (en el PC puedes querer otro tema que en el celular).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final guardado = ref.watch(sharedPreferencesProvider).getString(_claveTema);
    return ThemeMode.values.asNameMap()[guardado] ?? ThemeMode.system;
  }

  void set(ThemeMode modo) {
    state = modo;
    ref.read(sharedPreferencesProvider).setString(_claveTema, modo.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
