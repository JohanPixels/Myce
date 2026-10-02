import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_icons.dart';

@immutable
class OctoDashColors extends ThemeExtension<OctoDashColors> {
  const OctoDashColors({
    required this.proyecto,
    required this.area,
    required this.recurso,
    required this.wishlist,
    required this.estancado,
    required this.enCurso,
    required this.onEnCurso,
  });

  final Color proyecto;
  final Color area;
  final Color recurso;
  final Color wishlist;
  final Color estancado;

  /// Lo que pide atención ya: tareas "En curso", proyecto sin próxima
  /// acción. Ámbar de la paleta musgo.
  final Color enCurso;

  /// Texto/ícono sobre un fondo `enCurso` sólido (badges).
  final Color onEnCurso;

  static const light = OctoDashColors(
    proyecto: Color(0xFF2D9CDB),
    area: Color(0xFF27AE60),
    recurso: Color(0xFFF2994A),
    wishlist: Color(0xFF9B51E0),
    estancado: Color(0xFFEB5757),
    enCurso: Color(0xFFAD5A0C),
    onEnCurso: Color(0xFFFFFFFF),
  );

  static const dark = OctoDashColors(
    proyecto: Color(0xFF56CCF2),
    area: Color(0xFF6FCF97),
    recurso: Color(0xFFF2C94C),
    wishlist: Color(0xFFBB6BD9),
    estancado: Color(0xFFFF6B6B),
    enCurso: Color(0xFFF0A75A),
    onEnCurso: Color(0xFF1F1608),
  );

  @override
  OctoDashColors copyWith({
    Color? proyecto,
    Color? area,
    Color? recurso,
    Color? wishlist,
    Color? estancado,
    Color? enCurso,
    Color? onEnCurso,
  }) {
    return OctoDashColors(
      proyecto: proyecto ?? this.proyecto,
      area: area ?? this.area,
      recurso: recurso ?? this.recurso,
      wishlist: wishlist ?? this.wishlist,
      estancado: estancado ?? this.estancado,
      enCurso: enCurso ?? this.enCurso,
      onEnCurso: onEnCurso ?? this.onEnCurso,
    );
  }

  @override
  OctoDashColors lerp(ThemeExtension<OctoDashColors>? other, double t) {
    if (other is! OctoDashColors) return this;
    return OctoDashColors(
      proyecto: Color.lerp(proyecto, other.proyecto, t)!,
      area: Color.lerp(area, other.area, t)!,
      recurso: Color.lerp(recurso, other.recurso, t)!,
      wishlist: Color.lerp(wishlist, other.wishlist, t)!,
      estancado: Color.lerp(estancado, other.estancado, t)!,
      enCurso: Color.lerp(enCurso, other.enCurso, t)!,
      onEnCurso: Color.lerp(onEnCurso, other.onEnCurso, t)!,
    );
  }
}

@immutable
class OctoDashSpacing extends ThemeExtension<OctoDashSpacing> {
  const OctoDashSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
  });

  final double xs, sm, md, lg, xl;

  static const defaults = OctoDashSpacing();

  @override
  OctoDashSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return OctoDashSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  OctoDashSpacing lerp(ThemeExtension<OctoDashSpacing>? other, double t) {
    if (other is! OctoDashSpacing) return this;
    return OctoDashSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
    );
  }
}

extension OctoThemeX on BuildContext {
  OctoDashColors get octoColors => Theme.of(this).extension<OctoDashColors>()!;
  OctoDashSpacing get octoSpacing =>
      Theme.of(this).extension<OctoDashSpacing>()!;
}

/// Paleta de Myce: musgo. Verde lima (marca, acciones, progreso) y ámbar
/// (atención: "Ahora", sin clasificar — `OctoDashColors.enCurso`) sobre un
/// fondo verde casi negro. Es la paleta del primer mockup
/// (https://claude.ai/artifact/Taq2p9VCVkCMScfNeMzVuB); se probó una versión
/// cyan/naranja sacada del logo y el usuario prefirió esta.
/// Los esquemas se arman a mano en vez de `colorSchemeSeed` porque el seed
/// genera grises neutros que no tienen nada que ver con la paleta.
const _oscuro = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFC5E06A),
  onPrimary: Color(0xFF1A1E10),
  primaryContainer: Color(0xFF34401A),
  onPrimaryContainer: Color(0xFFE3F2B4),
  secondary: Color(0xFFA9C25A),
  onSecondary: Color(0xFF1A1E10),
  secondaryContainer: Color(0xFF2A3120),
  onSecondaryContainer: Color(0xFFDDE8BE),
  tertiary: Color(0xFFF0A75A),
  onTertiary: Color(0xFF1F1608),
  tertiaryContainer: Color(0xFF2A2416),
  onTertiaryContainer: Color(0xFFF7D9B4),
  error: Color(0xFFFF8A7A),
  onError: Color(0xFF2A0A06),
  errorContainer: Color(0xFF4A1C16),
  onErrorContainer: Color(0xFFFFD9D3),
  surface: Color(0xFF11140F),
  onSurface: Color(0xFFEEEDE4),
  onSurfaceVariant: Color(0xFFA3A897),
  surfaceContainerLowest: Color(0xFF0B0D09),
  surfaceContainerLow: Color(0xFF151912),
  surfaceContainer: Color(0xFF1A1E17),
  surfaceContainerHigh: Color(0xFF1F241B),
  surfaceContainerHighest: Color(0xFF232820),
  outline: Color(0xFF5A6150),
  outlineVariant: Color(0xFF2E3429),
  inverseSurface: Color(0xFFEEEDE4),
  onInverseSurface: Color(0xFF1A1E17),
  inversePrimary: Color(0xFF5C7A12),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  surfaceTint: Colors.transparent,
);

const _claro = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF55700F),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE2EFB8),
  onPrimaryContainer: Color(0xFF1C2604),
  secondary: Color(0xFF5E6B3A),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE4E9D2),
  onSecondaryContainer: Color(0xFF1E2410),
  tertiary: Color(0xFFAD5A0C),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFBE6CF),
  onTertiaryContainer: Color(0xFF3A1E02),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  surface: Color(0xFFF3F4EC),
  onSurface: Color(0xFF1B1F16),
  onSurfaceVariant: Color(0xFF575E4D),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF8F9F3),
  surfaceContainer: Color(0xFFFFFFFF),
  surfaceContainerHigh: Color(0xFFECEEE3),
  surfaceContainerHighest: Color(0xFFE3E6D8),
  outline: Color(0xFF8C927F),
  outlineVariant: Color(0xFFD9DCCD),
  inverseSurface: Color(0xFF1A1E17),
  onInverseSurface: Color(0xFFEEEDE4),
  inversePrimary: Color(0xFFC5E06A),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  surfaceTint: Colors.transparent,
);

/// Manrope para el texto; Bricolage Grotesque (con más carácter) para
/// títulos grandes. Ambas empaquetadas en assets/fonts.
const _fuenteTexto = 'Manrope';
const _fuenteTitulos = 'BricolageGrotesque';

TextTheme _textTheme(TextTheme base) {
  TextStyle? titulo(TextStyle? s, FontWeight w, {double? spacing}) =>
      s?.copyWith(
        fontFamily: _fuenteTitulos,
        fontWeight: w,
        letterSpacing: spacing,
      );
  return base
      .apply(fontFamily: _fuenteTexto)
      .copyWith(
        displayLarge: titulo(base.displayLarge, FontWeight.w800, spacing: -1),
        displayMedium: titulo(base.displayMedium, FontWeight.w800, spacing: -1),
        displaySmall: titulo(base.displaySmall, FontWeight.w700, spacing: -0.5),
        headlineLarge: titulo(
          base.headlineLarge,
          FontWeight.w700,
          spacing: -0.5,
        ),
        headlineMedium: titulo(
          base.headlineMedium,
          FontWeight.w700,
          spacing: -0.4,
        ),
        headlineSmall: titulo(
          base.headlineSmall,
          FontWeight.w700,
          spacing: -0.3,
        ),
        titleLarge: titulo(base.titleLarge, FontWeight.w700, spacing: -0.2),
        // Texto de tareas, ítems y campos: un punto más chico y más peso que
        // el default de Material (16/400) — en la captura se veía grande y
        // flojo frente al mockup (15/500).
        bodyLarge: base.bodyLarge?.copyWith(
          fontFamily: _fuenteTexto,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
      );
}

ThemeData _buildTheme(ColorScheme scheme, OctoDashColors colores) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: _fuenteTexto,
  );
  final text = _textTheme(base.textTheme);
  const radioTarjeta = 16.0;
  const radioControl = 14.0;

  return base.copyWith(
    textTheme: text,
    scaffoldBackgroundColor: scheme.surface,
    extensions: [colores, OctoDashSpacing.defaults],
    // Flecha de volver y X de cerrar de Flutter, también en Phosphor.
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => const Icon(AppIcons.atras),
      closeButtonIconBuilder: (_) => const Icon(AppIcons.cerrar),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      // Título de sección grande, como en el mockup ("Proyectos" en
      // Bricolage): da jerarquía y hace obvio en qué sección estás.
      titleTextStyle: text.headlineSmall?.copyWith(
        color: scheme.onSurface,
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainer,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radioTarjeta),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radioControl),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHigh,
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radioTarjeta),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radioTarjeta),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radioTarjeta),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioControl),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioControl),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioControl),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: scheme.primary,
        selectedForegroundColor: scheme.onPrimary,
        side: BorderSide(color: scheme.outline),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: scheme.primary,
      secondarySelectedColor: scheme.primary,
      checkmarkColor: scheme.onPrimary,
      showCheckmark: false,
      // El color del label depende de si el chip está elegido (fondo cyan
      // sólido) — un WidgetStateColor, que Chip resuelve por estado.
      labelStyle: text.labelMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: WidgetStateColor.resolveWith(
          (estados) => estados.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.onSurface,
        ),
      ),
      side: BorderSide(color: scheme.outline),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: BorderSide(color: scheme.outline, width: 2),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(4),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: scheme.onSurface,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorColor: scheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: scheme.outlineVariant,
      labelStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      unselectedLabelStyle: text.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainer,
      modalBackgroundColor: scheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: scheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radioControl),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radioControl),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: const Border(),
      collapsedShape: const Border(),
      iconColor: scheme.onSurfaceVariant,
      collapsedIconColor: scheme.onSurfaceVariant,
    ),
  );
}

ThemeData buildLightTheme() => _buildTheme(_claro, OctoDashColors.light);

ThemeData buildDarkTheme() => _buildTheme(_oscuro, OctoDashColors.dark);
