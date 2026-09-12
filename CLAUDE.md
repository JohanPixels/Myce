# CLAUDE.md — Myce

Contexto de proyecto para Claude Code. Referencia completa del modelo: `docs/fuente_de_verdad.md`. Este archivo es el resumen operativo — si hay conflicto, la fuente de verdad manda.

## Estado actual vs. objetivo — qué falta cerrar

**La migración de schema físico (OctoDash `Nodes` → Myce `Entities/Relations/Activities`) ya está hecha en local.** `lib/core/database/app_database.dart` define las 15 tablas del modelo v1 (`entities` + 7 tablas de tipo, `relations`+`relation_types`, `tasks`+`activity_links`, `inbox_items`, `tags`+`entity_tags`), con repositorios propios por feature (`lib/entities/data/`, `lib/relations/data/`, `lib/activities/data/`, `lib/inbox/data/`, `lib/tags/data/`) y la UI reconectada sobre ellos. `test/entity_migration_test.dart` cubre el flujo capturar→clasificar→consultar y la limpieza de `activity_links` al borrar una Task. El schema espejo ya corrió en Supabase (`supabase/schema.sql`, con RLS por usuario).

**Lo que queda pendiente, en orden de prioridad:**
1. `sync_repository.dart` hoy solo empuja `entities` — falta extenderlo a `relations`/`tasks`/tablas de tipo/`tags`. Ojo: los `id` de `relation_types` sembrados en Supabase son distintos a los sembrados en local (cada lado corre su propio `onCreate`/seed) — sincronizar `relations` va a necesitar resolver `relation_type_id` por `key`, no por `id`.
2. La UI no tiene pantalla propia para Person/Hobby/Goal todavía (se crean desde el Inbox clasificando, pero no aparecen en el bottom nav — decisión consciente para no saturarlo).
3. Los Tags se escriben (`TagRepository.tagEntity`, usado por el flujo de wishlist) pero todavía no se muestran en ninguna pantalla (`category_screen.dart`/`review_screen.dart` no listan tags de cada Entity).
4. Sin probar todavía en Android real (solo verificado en Linux desktop + tests) — Android sigue siendo el target de producción real.

## Qué es Myce

Sistema personal de conocimiento/productividad (evolución de OctoDash → Knowledge Garden → Myce). Modelo central: **Entities + Activities + Relations**, no un PARA plano. El grafo de conocimiento emerge de `Entities + Relations`; PARA, Zettelkasten y Dashboard son *vistas* sobre esos mismos datos, no estructuras propias.

Prioridad del producto: capturar rápido, recuperar sin fricción, organizar después, conectar información entre proyectos. Performance y offline-first son requisitos de primera clase, no un "nice to have" — el usuario desarrolla desde una zona rural de Colombia con conectividad poco confiable.

## Stack

- **Flutter/Dart** (sdk `^3.13.1`) + **Riverpod** (estado) + **Drift** (SQLite local) + **Supabase** (sync, Postgres, Auth, RLS)
- Editor: **Zed** (sin debugger visual — depender de logs/prints y de `flutter analyze` para detectar errores, no asumir breakpoints)
- `dart:ffi` **no funciona en web** — no asumir soporte web sin verificar
- Package id actual heredado: `com.pixelglitch.octo_dash` (confirmar si cambia al renombrar a Myce)

## Comandos

```
flutter pub get                                          # instalar dependencias
dart run build_runner build --delete-conflicting-outputs # regenerar database.g.dart tras tocar el schema de Drift
flutter analyze                                           # linter/type-check (no hay debugger visual, este es el chequeo principal)
flutter run -d linux                                       # loop de desarrollo rápido
flutter run -d <device-id>                                 # Android es el target de producción real; probar ahí antes de dar por buena una feature (`flutter devices` para listar)
flutter test                                                # correr toda la suite
flutter test test/entity_migration_test.dart                # test del flujo Inbox→Entity y de la limpieza de activity_links
```

## Estructura de carpetas (feature-based)

Carpetas por feature (`capture/`, `inbox/`, `entities/`, `relations/`, `activities/`, `tags/`, `review/`, `core/database/`, `core/theme/`), no por tipo de archivo. Nueva feature → nueva carpeta con sus propios widgets/providers/repositorios.

## Modelo de datos — reglas que NO se rompen sin discutirlo antes

1. **`EntityType` es un enum fijo en Dart**, no una tabla dinámica (`project, area, resource, note, person, hobby, goal`). No crear `entity_types` como tabla en v1 — es YAGNI hasta que exista un segundo módulo real.
2. **`relations` es estrictamente Entity ↔ Entity.** Nunca meter ahí referencias a Task/Habit ni columnas polimórficas (`source_type`/`target_type`).
3. **Task/Habit son Activities, no Entities.** Su contexto con el grafo pasa por `activity_links` (`activity_type`, `activity_id`, `entity_id`, `link_type`), nunca por `relations` directamente.
4. **Vocabularios separados a propósito:** `relation_types` (para `relations`) y `link_type` string suelto (para `activity_links`) son cosas distintas. No unificar sin decisión explícita.
5. **Wishlist no es una entidad propia.** Es un `Resource` con `status = "someday"`. El subtipo (juego/libro/película) va como Tag, no como campo.
6. **Habit + HabitOccurrence: diferido a v2.** No implementar en v1 aunque el modelo ya los contemple.

## Deuda técnica conocida — mitigación obligatoria en código

`activity_links.activity_id` **no tiene foreign key real** (SQL no soporta FK condicional hacia `tasks` o `habits` según `activity_type`). Esto significa: **cualquier repositorio que borre una Task (o Habit en v2) debe borrar explícitamente sus filas de `activity_links` en la misma transacción.** No confiar en cascada automática de la base de datos — no existe. Si se toca `TaskRepository.delete()` o similar y no incluye esa limpieza, es un bug.

## Patrones a mantener

- **UI optimista:** en capturas (Inbox, quick-add) no hacer `await` antes de cerrar el modal/bottom sheet — insertar y refrescar en segundo plano.
- **Sync:** patrón outbox con flag `dirty`, UUIDs generados en cliente, `last-write-wins` como estrategia de conflicto inicial, retry en fallos de push. Este patrón se traslada desde OctoDash tal cual; lo que cambia es el schema físico sobre el que opera (ya no es la tabla `nodes`, ahora es `entities` + tablas específicas + `relations` + `activities`).
- **Theming:** `ThemeExtension` + Riverpod para colores/espaciados, no hardcodear valores en widgets.

## Alcance de v1 — no expandir sin confirmar

Entra: Entities (7 tipos), Relations, Task, activity_links, Inbox, Tags, Search local, Wishlist vía Resource.
No entra todavía: Habit, `entity_types` dinámico, módulo Finance (futuro destino de la fusión con Mango), grafo visual avanzado, IA/semántica.

## Al generar código nuevo

- Antes de crear una tabla o campo nuevo, revisar si ya existe algo equivalente en la fuente de verdad — no duplicar semántica (ej. no crear un campo `subtipo` cuando ya existe Tags para eso).
- Si una decisión de esta lista necesita romperse, señalarlo explícitamente en vez de improvisar una solución silenciosa.
