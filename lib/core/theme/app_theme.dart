import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class OctoDashColors extends ThemeExtension<OctoDashColors> {
  const OctoDashColors({
    required this.proyecto,
    required this.area,
    required this.recurso,
    required this.wishlist,
    required this.estancado,
    required this.enCurso,
  });

  final Color proyecto;
  final Color area;
  final Color recurso;
  final Color wishlist;
  final Color estancado;

  /// Lo que pide atención ya: tareas "En curso", proyecto sin próxima
  /// acción. Naranja eléctrico del logo de Myce.
  final Color enCurso;

  static const light = OctoDashColors(
    proyecto: Color(0xFF2D9CDB),
    area: Color(0xFF27AE60),
    recurso: Color(0xFFF2994A),
    wishlist: Color(0xFF9B51E0),
    estancado: Color(0xFFEB5757),
    enCurso: Color(0xFFD95E00),
  );

  static const dark = OctoDashColors(
    proyecto: Color(0xFF56CCF2),
    area: Color(0xFF6FCF97),
    recurso: Color(0xFFF2C94C),
    wishlist: Color(0xFFBB6BD9),
    estancado: Color(0xFFFF6B6B),
    enCurso: Color(0xFFFF7A1A),
  );

  @override
  OctoDashColors copyWith({
    Color? proyecto,
    Color? area,
    Color? recurso,
    Color? wishlist,
    Color? estancado,
    Color? enCurso,
  }) {
    return OctoDashColors(
      proyecto: proyecto ?? this.proyecto,
      area: area ?? this.area,
      recurso: recurso ?? this.recurso,
      wishlist: wishlist ?? this.wishlist,
      estancado: estancado ?? this.estancado,
      enCurso: enCurso ?? this.enCurso,
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

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF2D9CDB),
    useMaterial3: true,
    extensions: const [OctoDashColors.light, OctoDashSpacing.defaults],
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF56CCF2),
    useMaterial3: true,
    extensions: const [OctoDashColors.dark, OctoDashSpacing.defaults],
  );
}
