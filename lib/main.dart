import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/navigation/app_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registrarLicenciasDeFuentes();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    // La anon key "legacy" sirve igual como publishable key; el parámetro
    // anonKey quedó deprecado en supabase_flutter.
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const OctoDashApp(),
    ),
  );
}

/// Manrope y Bricolage Grotesque (OFL) y los íconos Phosphor (MIT) van
/// empaquetados (pubspec.yaml) — sus licencias piden acompañarlos con su
/// texto; así aparece en la pantalla
/// estándar de licencias de Flutter.
void _registrarLicenciasDeFuentes() {
  LicenseRegistry.addLicense(() async* {
    for (final (paquete, archivo) in [
      ('Manrope', 'assets/fonts/OFL-Manrope.txt'),
      ('Bricolage Grotesque', 'assets/fonts/OFL-BricolageGrotesque.txt'),
      ('Phosphor Icons', 'assets/fonts/phosphor/LICENSE-Phosphor.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        paquete,
      ], await rootBundle.loadString(archivo));
    }
  });
}

class OctoDashApp extends ConsumerWidget {
  const OctoDashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Myce',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: appRouter,
    );
  }
}
