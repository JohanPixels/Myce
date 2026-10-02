import 'package:flutter/material.dart';

import 'app_sections.dart';

/// Barra de secciones tipo carrusel: la sección activa queda siempre en el
/// centro, más grande y resaltada; las vecinas se achican y se desvanecen
/// según la distancia. Se puede deslizar la barra misma para cambiar de
/// sección, además de tocar.
///
/// No tiene estado de navegación propio: lee y escribe el `TabController`
/// de `DefaultTabController` (el mismo que mueve el `TabBarView` del cuerpo
/// y que `_TabBranchSync` traduce a `go_router`), y sigue su `animation`
/// cuadro a cuadro — así, al deslizar el cuerpo, la barra se mueve a la par.
class CarouselNavBar extends StatefulWidget {
  const CarouselNavBar({super.key, required this.onTapActual});

  /// Tocar la sección que ya está activa (ver "recargar" en home_shell).
  final VoidCallback onTapActual;

  @override
  State<CarouselNavBar> createState() => _CarouselNavBarState();
}

/// Ancho de cada sección en la barra; con eso se calcula `viewportFraction`
/// para que en un celular se vean ~5 a la vez y en pantallas anchas más.
const _anchoItem = 84.0;
const _altoBarra = 68.0;

class _CarouselNavBarState extends State<CarouselNavBar> {
  TabController? _tabs;
  PageController? _pages;
  double _fraccion = 0.2;

  /// true mientras la barra se mueve porque la movió el TabController (y no
  /// el dedo) — en ese caso `onPageChanged` no debe volver a mandar la
  /// orden al TabController, o se pelean.
  bool _siguiendo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabs = DefaultTabController.of(context);
    if (!identical(tabs, _tabs)) {
      _tabs?.animation?.removeListener(_seguirAnimacion);
      _tabs = tabs..animation!.addListener(_seguirAnimacion);
    }
  }

  void _asegurarPageController(double ancho) {
    final fraccion = (_anchoItem / ancho).clamp(0.08, 0.34);
    if (_pages != null && (fraccion - _fraccion).abs() < 0.001) return;
    final pagina = _tabs!.animation!.value;
    _pages?.dispose();
    _fraccion = fraccion;
    _pages = PageController(
      viewportFraction: fraccion,
      initialPage: pagina.round(),
    );
  }

  void _seguirAnimacion() {
    final pages = _pages;
    if (pages == null || !pages.hasClients) return;
    // Si el dedo está moviendo la barra, manda el dedo: seguir al
    // TabController en ese momento haría que se peleen.
    if (pages.position.isScrollingNotifier.value) return;
    final destino = _tabs!.animation!.value;
    final actual = pages.page ?? destino;
    if ((actual - destino).abs() < 0.001) return;
    _siguiendo = true;
    pages.jumpTo(destino * pages.position.viewportDimension * _fraccion);
    _siguiendo = false;
  }

  void _alCambiarPagina(int i) {
    if (_siguiendo) return;
    final tabs = _tabs!;
    if (tabs.index != i) tabs.animateTo(i);
  }

  void _tocar(int i) {
    final tabs = _tabs!;
    if (i == tabs.index) {
      widget.onTapActual();
    } else {
      tabs.animateTo(i);
    }
  }

  @override
  void dispose() {
    _tabs?.animation?.removeListener(_seguirAnimacion);
    _pages?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _altoBarra,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _asegurarPageController(constraints.maxWidth);
          return PageView.builder(
            controller: _pages,
            itemCount: appSections.length,
            onPageChanged: _alCambiarPagina,
            itemBuilder: (context, i) => AnimatedBuilder(
              animation: _pages!,
              builder: (context, _) {
                final pagina =
                    _pages!.hasClients && _pages!.position.haveDimensions
                    ? _pages!.page ?? _tabs!.index.toDouble()
                    : _tabs!.index.toDouble();
                final distancia = (pagina - i).abs().clamp(0.0, 3.0);
                return _ItemSeccion(
                  seccion: appSections[i],
                  // 1 = en el centro, 0 = a una sección o más de distancia
                  cercania: (1 - distancia).clamp(0.0, 1.0),
                  distancia: distancia,
                  onTap: () => _tocar(i),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ItemSeccion extends StatelessWidget {
  const _ItemSeccion({
    required this.seccion,
    required this.cercania,
    required this.distancia,
    required this.onTap,
  });

  final AppSection seccion;
  final double cercania;
  final double distancia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = Color.lerp(
      scheme.onSurfaceVariant,
      scheme.primary,
      cercania,
    )!;
    final escala = 0.82 + 0.18 * cercania;
    final opacidad = (1 - 0.28 * distancia).clamp(0.3, 1.0);

    return Semantics(
      button: true,
      selected: cercania > 0.5,
      label: seccion.titulo,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: opacidad,
          child: Transform.scale(
            scale: escala,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 30,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.16 * cercania),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(seccion.icon, color: color, size: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  seccion.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: cercania > 0.5
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
