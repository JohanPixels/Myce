import 'package:flutter/material.dart';

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
  });

  final String path;
  final String titulo;
  final IconData icon;
}

const appSections = [
  AppSection(path: 'ahora', titulo: 'Ahora', icon: Icons.bolt),
  AppSection(path: 'inbox', titulo: 'Inbox', icon: Icons.inbox),
  AppSection(path: 'tasks', titulo: 'Tareas', icon: Icons.check_circle_outline),
  AppSection(path: 'projects', titulo: 'Proyectos', icon: Icons.rocket_launch),
  AppSection(path: 'areas', titulo: 'Áreas', icon: Icons.landscape),
  AppSection(path: 'resources', titulo: 'Recursos', icon: Icons.menu_book),
  AppSection(path: 'notes', titulo: 'Notas', icon: Icons.notes),
  AppSection(path: 'review', titulo: 'Revisión', icon: Icons.fact_check),
  AppSection(path: 'people', titulo: 'Personas', icon: Icons.people_outline),
  AppSection(
    path: 'hobbies',
    titulo: 'Hobbies',
    icon: Icons.sports_esports_outlined,
  ),
  AppSection(path: 'goals', titulo: 'Metas', icon: Icons.flag_outlined),
];
