import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import 'capture_button_preference.dart';

/// Preferencias del dispositivo y de la cuenta. Pantalla completa (fuera
/// del carrusel de secciones), se abre desde el ícono de engranaje.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmarCerrarSesion(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Lo que ya está en este dispositivo se queda guardado aquí. '
          'Si hay cambios sin sincronizar, se suben la próxima vez que '
          'entres con esta misma cuenta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    // El redirect de go_router (escucha onAuthStateChange) lleva al login.
    if (confirmado == true) await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = context.octoSpacing;
    final modo = ref.watch(themeModeProvider);
    final email = Supabase.instance.client.auth.currentUser?.email;

    Widget titulo(String texto) => Padding(
      padding: EdgeInsets.fromLTRB(4, spacing.lg, 4, spacing.sm),
      child: Text(
        texto.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.xl),
        children: [
          titulo('Apariencia'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tema', style: theme.textTheme.titleMedium),
                  SizedBox(height: spacing.xs),
                  Text(
                    'Se guarda solo en este dispositivo.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.md - 4),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('Sistema'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Claro'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Oscuro'),
                        ),
                      ],
                      selected: {modo},
                      onSelectionChanged: (s) =>
                          ref.read(themeModeProvider.notifier).set(s.first),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: spacing.sm),
          Card(
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Botón de captura (+)',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    'Se esconde al bajar en una lista y dentro de los '
                    'detalles. "Arriba" lo quita y deja la captura como un '
                    'ícono en la barra superior.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.md - 4),
                  // Chips y no SegmentedButton: 4 opciones no caben en una
                  // fila en un celular angosto.
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in CaptureButtonPosition.values)
                        ChoiceChip(
                          label: Text(p.label),
                          selected: ref.watch(captureButtonProvider) == p,
                          onSelected: (_) =>
                              ref.read(captureButtonProvider.notifier).set(p),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          titulo('Cuenta'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Sesión iniciada como'),
                  subtitle: Text(email ?? '—'),
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.error),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () => _confirmarCerrarSesion(context),
                ),
              ],
            ),
          ),

          titulo('Acerca de'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Licencias'),
              subtitle: const Text('Librerías y fuentes que usa Myce'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  showLicensePage(context: context, applicationName: 'Myce'),
            ),
          ),
        ],
      ),
    );
  }
}
