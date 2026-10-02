import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

/// Las 11 secciones del carrusel, en el mismo orden en que se declaran las
/// `StatefulShellBranch` en app_router.dart — `navigationShell.currentIndex`
/// es un índice plano sobre esa lista, así que el orden acá DEBE coincidir
/// con el orden de las branches o el título/ícono de la pestaña activa
/// queda desfasado. Single source of truth para el TabBar (home_shell.dart)
/// y el título del AppBar — antes eran dos listas paralelas
/// (`_titulosPorRama`/`_pathsPorRama`) que había que mantener en sync a mano.
class AppSection {
  const AppSection({
    required this.path,
    required this.titulo,
    required this.icon,
    required this.iconoDuo,
  });

  final String path;
  final String titulo;
  final IconData icon;

  /// Versión duotono, para cuando la sección está activa en la barra.
  final IconoDuoData iconoDuo;
}

const appSections = [
  AppSection(
    path: 'ahora',
    titulo: 'Ahora',
    icon: AppIcons.ahora,
    iconoDuo: AppIconsDuo.ahora,
  ),
  AppSection(
    path: 'inbox',
    titulo: 'Inbox',
    icon: AppIcons.inbox,
    iconoDuo: AppIconsDuo.inbox,
  ),
  AppSection(
    path: 'tasks',
    titulo: 'Tareas',
    icon: AppIcons.tarea,
    iconoDuo: AppIconsDuo.tarea,
  ),
  AppSection(
    path: 'projects',
    titulo: 'Proyectos',
    icon: AppIcons.proyecto,
    iconoDuo: AppIconsDuo.proyecto,
  ),
  AppSection(
    path: 'areas',
    titulo: 'Áreas',
    icon: AppIcons.area,
    iconoDuo: AppIconsDuo.area,
  ),
  AppSection(
    path: 'resources',
    titulo: 'Recursos',
    icon: AppIcons.recurso,
    iconoDuo: AppIconsDuo.recurso,
  ),
  AppSection(
    path: 'notes',
    titulo: 'Notas',
    icon: AppIcons.nota,
    iconoDuo: AppIconsDuo.nota,
  ),
  AppSection(
    path: 'review',
    titulo: 'Revisión',
    icon: AppIcons.revision,
    iconoDuo: AppIconsDuo.revision,
  ),
  AppSection(
    path: 'people',
    titulo: 'Personas',
    icon: AppIcons.personas,
    iconoDuo: AppIconsDuo.personas,
  ),
  AppSection(
    path: 'hobbies',
    titulo: 'Hobbies',
    icon: AppIcons.hobby,
    iconoDuo: AppIconsDuo.hobby,
  ),
  AppSection(
    path: 'goals',
    titulo: 'Metas',
    icon: AppIcons.meta,
    iconoDuo: AppIconsDuo.meta,
  ),
];
