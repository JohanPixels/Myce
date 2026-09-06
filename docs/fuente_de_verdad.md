# 🍄 Myce — Fuente de la Verdad del Proyecto

> **Versión:** v0.1
> **Estado:** Modelo conceptual congelado, pendiente de bajar a schema físico definitivo
> **Origen:** Evolución de OctoDash (`com.pixelglitch.octo_dash`), previamente llamado Knowledge Garden

Este documento consolida todas las decisiones tomadas sobre la arquitectura de Myce hasta este punto. Es el punto de referencia único: si algo no está aquí, no está decidido.

---

## 1. Identidad del proyecto

**Nombre:** Myce (de *Mycelium*)

**Por qué el nombre:** el micelio es una red de conexiones que crece orgánicamente, sin jerarquía fija, donde el valor está en las relaciones entre nodos y no en los nodos aislados. Es una metáfora más precisa que "Garden" para lo que el sistema realmente es: un grafo de conocimiento personal, no un jardín de notas aisladas.

**Historial de nombres:** OctoDash → Knowledge Garden → Myce.

**Problema que resuelve** (sin cambios desde el documento de contexto original): la fricción de **capturar, recuperar, organizar y conectar** información personal — no la falta de curiosidad o de información.

---

## 2. Concepto central

Myce **no es PARA**. Myce puede *implementar* PARA como una vista sobre los datos, pero su modelo fundamental es otro:

```
                     MYCE
                       │
             ┌─────────┼─────────┐
             ↓         ↓         ↓
         ENTITIES  ACTIVITIES  RELATIONS
             │         │         │
             └─────────┼─────────┘
                       ↓
                PERSONAL SYSTEM
```

La misma información debe poder verse desde distintas perspectivas (PARA, Zettelkasten, Dashboard, Grafo) sin que esas perspectivas dupliquen datos — son **vistas**, no estructuras propias.

---

## 3. Principios arquitectónicos (congelados)

| # | Principio | Significado |
|---|---|---|
| 01 | **Local-first** | La app debe funcionar sin internet. |
| 02 | **Entity-oriented** | La información importante tiene identidad propia. |
| 03 | **Relation-oriented** | Las conexiones son datos de primera clase. |
| 04 | **Modular** | El Core no debe absorber todos los dominios (Finance, Fitness, etc. van aparte). |
| 05 | **Method-agnostic** | Myce puede soportar PARA, Zettelkasten, GTD, Bullet Journal, sin depender de ninguno. |
| 06 | **Views over data** | Las vistas organizativas no duplican información, consultan la misma fuente. |
| 07 | **Capture first** | Capturar debe ser instantáneo; organizar viene después. |
| 08 | **Archive, don't destroy** | Nada se borra al "cerrarse", solo cambia de estado. |

---

## 4. Modelo de Entities

Una **Entity** es algo con identidad propia dentro del sistema: puede tener relaciones propias, historial propio, y merece ser encontrado por búsqueda/grafo.

### 4.1 Campos comunes (core)

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | UUID | Identificador único |
| `type` | enum | Tipo de entidad (ver 4.2) |
| `title` | string | Nombre/título |
| `description` | text | Descripción opcional |
| `status` | string | `active` / `paused` / `someday` / `archived` |
| `created_at` | datetime | Creación |
| `updated_at` | datetime | Última modificación |

### 4.2 Tipos de entidad — v1

**Decisión:** para v1 se usa un **enum fijo en Dart**, no una tabla dinámica `entity_types`.

```dart
enum EntityType { project, area, resource, note, person, hobby, goal }
```

**Por qué (YAGNI):** una tabla dinámica de tipos resuelve el problema de "un módulo externo registra sus propios tipos sin tocar el Core" — un problema que hoy no existe, porque el mismo desarrollador construye tanto el Core como los módulos. El enum da seguridad de tipos y autocompletado en Zed; la tabla dinámica se implementa el día que exista un segundo módulo real (ej. cuando Finance nazca de verdad).

### 4.3 Detalle por tipo de Entity

| Tipo | Representa | Tabla específica | Campos propios |
|---|---|---|---|
| **Project** | Resultado concreto a conseguir | `projects` | `started_at`, `completed_at` |
| **Area** | Responsabilidad permanente de la vida (no "termina") | `areas` | — |
| **Resource** | Fuente externa de conocimiento (libro, curso, video, repo) | `resources` | — |
| **Note** | Conocimiento/pensamiento propio, Markdown, soporta backlinks (`[[Otra nota]]`) | `notes` | `content` (Markdown) |
| **Person** | Persona relevante (mentor, autor, colaborador, admirado) — la semántica va en las relaciones, no en flags | `people` | — |
| **Hobby** | Actividad/interés continuo (no tiene "resultado final") | `hobbies` | — |
| **Goal** | Dirección o resultado deseado, apoyado por Projects/Notes/Areas | `goals` | — |

**Distinción Hobby vs Project:** "Fotografía" (Hobby, continúa indefinidamente) vs. "Crear mi portafolio fotográfico" (Project, tiene resultado concreto).

---

## 5. Wishlist — decisión de diseño

**Decisión:** Wishlist **no es una entidad nueva**. Un ítem de wishlist es un **Resource con `status = "someday"`**.

- Videojuego, película, libro, disco → encajan en la definición de Resource ("fuente externa que puede producir conocimiento").
- Empezar a consumirlo = cambiar `status` de `someday` a `active`. No hay "conversión" de un tipo a otro, siempre fue el mismo Resource.
- El subtipo (`#juego`, `#música`, `#película`, `#libro`) deja de ser un campo rígido (como en OctoDash) y pasa a ser un **Tag** — permite combinaciones (`#libro` + `#trabajo`) que un campo único no permitía.
- **Hobby no aplica aquí**: Hobby es una actividad continua, no un ítem puntual de consumo.
- **Caso sin resolver todavía:** cosas que se quieren *comprar* (ej. audífonos) no son fuente de conocimiento — forzarlas en Resource estira la definición. Para v1: viven como Nota corta con tag `#comprar`, o sin procesar en el Inbox. No se crea entidad nueva solo para esto por ahora.

---

## 6. Modelo de Relations

Las relaciones son el tejido conectivo de Myce. **Decisión:** `relations` es estrictamente **Entity ↔ Entity** — no polimórfica, no mezclada con Activities (ver sección 7).

### 6.1 Tabla `relations`

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | UUID | — |
| `source_entity_id` | UUID → `entities.id` | — |
| `target_entity_id` | UUID → `entities.id` | — |
| `relation_type_id` | UUID → `relation_types.id` | — |
| `note` | text (opcional) | — |
| `metadata` | JSON (opcional) | Solo para datos que no necesitan query/índice propio |
| `created_at` | datetime | — |

### 6.2 Tabla `relation_types`

| Campo | Descripción |
|---|---|
| `key` | ej. `inspired_by` |
| `label` | ej. "Inspired by" |
| `inverse_label` | ej. "Inspires" |
| `directed` | bool — si es direccional |
| `description` | opcional |

**Importante:** no se guarda la relación inversa como fila duplicada. `A —INSPIRED_BY→ B` se puede mostrar como `B —INSPIRES→ A` calculando la inversa en la app.

**Vocabulario inicial:** `BELONGS_TO`, `USES`, `RELATED_TO`, `DERIVED_FROM`, `INSPIRED_BY`, `RELEVANT_TO`, `SUPPORTS`, `RECOMMENDS`, `CONTRIBUTES_TO`. Extensible sin migración (es tabla de datos, no enum).

**Regla sobre metadata:** si algo necesita consultas frecuentes, restricciones o índices, merece ser campo/entidad real — no esconderse dentro de `metadata` JSON.

---

## 7. Modelo de Activities

**Decisión:** Activity (Task, Habit) **no es Entity**. Representa acción/comportamiento, no identidad dentro del grafo de conocimiento. Esto evita que el grafo termine lleno de tareas completadas (ruido en vez de señal).

### 7.1 Task — v1

| Campo | Tipo |
|---|---|
| `id` | UUID |
| `title` | string |
| `description` | text |
| `status` | `pending` / `in_progress` / `completed` / `cancelled` |
| `priority` | `none` / `low` / `medium` / `high` |
| `due_at` | datetime opcional |
| `completed_at` | datetime opcional |
| `created_at`, `updated_at` | datetime |

### 7.2 Habit — diferido a v2

**Decisión:** Habit y HabitOccurrence **no se construyen en v1**. El modelo los soporta cuando llegue el momento (regla de recurrencia como JSON, no 365 filas pregeneradas; occurrences generadas solo dentro de la ventana visible), pero no son prioritarios porque el problema central de v1 es captura/recuperación/organización/conexión, no seguimiento de hábitos.

### 7.3 `activity_links` — cómo Activities tocan el grafo

Las Activities pueden tener contexto (una Task puede relacionarse con un Project, un Area, una Nota) sin ser parte del Knowledge Graph principal.

| Campo | Descripción |
|---|---|
| `id` | UUID |
| `activity_type` | `"task"` / `"habit"` |
| `activity_id` | id de la Task o Habit |
| `entity_id` | → `entities.id` |
| `link_type` | string (vocabulario separado del de `relation_types`) |
| `created_at` | datetime |

**Vocabulario de relación duplicado — decisión consciente:** `relation_types` (para Entities) y `link_type` (para Activities, string suelto) son vocabularios **separados**, no comparten tabla. Se acepta el riesgo de que términos como "PART_OF" se escriban de forma inconsistente entre ambos mundos; se resuelve con disciplina/documentación, no con una tabla unificada, para no complicar el modelo antes de tiempo.

**Deuda técnica aceptada — integridad referencial:**
`entity_id` sí tiene foreign key real hacia `entities.id`. `activity_id` **no puede** tener foreign key real porque SQL no soporta una FK condicional ("apunta a `tasks` o a `habits` según lo que diga `activity_type`"). Consecuencia: si se borra una Task sin borrar también sus filas en `activity_links`, quedan registros huérfanos sin que SQLite avise — falla silenciosa, no un error visible.

*Mitigación para v1:* al borrar una Task (o Habit en v2), borrar explícitamente sus filas de `activity_links` en la misma transacción, desde el código del repositorio — no confiar en que la base de datos lo haga sola. Riesgo bajo con un solo usuario y volumen bajo de datos; revisar si se vuelve problema real cuando el sync con Supabase esté activo sobre este nuevo schema (mayor probabilidad de huérfanos por escritura concurrente en dos dispositivos).

---

## 8. Tags

Tags = clasificación, no conocimiento. Regla: si algo necesita identidad, contenido, relaciones o historial → Entity. Si solo se quiere agrupar → Tag. (Ej: `#flutter`, `#comprar`, `#libro`.)

---

## 9. Inbox

Sistema universal de captura. Puede contener cualquier cosa (idea, link, tarea, recordatorio). Flujo: `CAPTURE → PROCESS → ORGANIZE`, y el procesamiento puede producir una o varias Entities/Activities.

## 10. Archive / ciclo de vida

Archive no es una colección aparte, es un valor de `status`: `active / paused / someday / archived`. Una entidad archivada conserva contenido, relaciones e historial — solo sale de los flujos activos.

## 11. Search (transversal)

No es una entidad. Es una capacidad que consulta sobre entidades, contenido de notas, títulos, descripciones, tags y relaciones. Objetivo: no tener que recordar dónde se guardó algo.

## 12. Knowledge Graph (emergente)

El grafo **no es una estructura independiente** — emerge de `Entities + Relations`. Es la característica que más diferencia a Myce de una implementación tradicional de PARA, y estaba pedida desde el documento de visión original (Knowledge Garden).

## 13. Views

Las vistas son consultas sobre la misma fuente de datos, no estructuras propias: PARA (Projects/Areas/Resources/Archive), Zettelkasten (Notes/Backlinks/Related), Gestión (Today/Tasks/Habits/Goals), Grafo, Dashboard.

## 14. Módulos futuros

El Core se mantiene pequeño (Entities, Relations, Notes, Projects, Areas, Resources, People, Hobbies, Goals, Tasks, Inbox, Tags). Módulos futuros se conectan sin modificar el Core:

- **Finance** — destino identificado para fusionar la app de gestión financiera personal (Mango). Ej: `FinancialGoal SUPPORTS→ Goal`, `Transaction RELATED_TO→ Project`.
- Fitness, Learning, Journal, Business — mencionados como posibles, sin diseño aún.

## 15. Alcance de v1 (MVP)

**Sí entra en v1:**
- Entities: Project, Area, Resource, Note, Person, Hobby, Goal (enum fijo)
- Relations + relation_types (vocabulario inicial)
- Task + activity_links
- Inbox, Tags, Search local
- Wishlist = Resource + `status=someday`
- Sync local-first con Supabase (patrón ya validado en OctoDash)

**Explícitamente diferido:**
- Habit + HabitOccurrence
- `entity_types` como tabla dinámica (se queda en enum hasta que exista un segundo módulo real)
- Módulo Finance (Mango) y cualquier otro módulo
- Grafo visual avanzado / IA / semántica

## 16. Migración desde OctoDash

**Qué se traslada:** el patrón de sync completo (outbox con `dirty` flag, UUIDs locales, `last-write-wins`, retry en fallo de push) — es arquitectura de sincronización, independiente del schema de `Nodes`.

**Qué se reescribe:** el schema físico completo. La tabla única `Nodes` (tipo/subtipo/título/cuerpo/estado/áreaRelacionadaId) se reemplaza por `entities` + tablas específicas por tipo + `relations` + `tasks` + `activity_links`. Esto implica reescribir `sync_repository.dart` sobre el nuevo schema, aunque la lógica aprendida se mantenga.

## 17. Decisiones congeladas — resumen

| Tema | Decisión |
|---|---|
| Tipos de entidad | Enum fijo en Dart para v1, no tabla dinámica |
| Wishlist | Resource con `status = someday`; subtipo como Tag |
| Compras (no-conocimiento) | Nota con `#comprar` o Inbox sin procesar, sin entidad nueva |
| Task | Activity, no Entity; contexto vía `activity_links` |
| Habit | Diferido a v2 |
| `relations` | Estrictamente Entity ↔ Entity, nunca polimórfica |
| Vocabulario de relación | `relation_types` (Entities) y `link_type` (Activities) separados, a propósito |
| Integridad referencial de `activity_id` | Aceptada como deuda técnica; mitigada a nivel de código, no de schema |
| Grafo | No incluye Activities automáticamente |
| Módulo Finance | Destino planeado para fusión con Mango, sin diseñar aún |

## 18. Preguntas abiertas

- ¿Cómo se representa exactamente `fechaUltimoToque`/detección de estancamiento (feature ya construida en OctoDash Fase 3) sobre el nuevo `updated_at` genérico?
- ¿El caso "quiero comprar X" necesita eventualmente algo más que una Nota con tag, si el volumen crece?
- ¿En qué punto se decide migrar `entity_types` de enum a tabla dinámica (criterio: "cuando exista un segundo módulo real")?

## 19. Próximos pasos sugeridos

1. Bajar este modelo a schema físico definitivo (tablas Drift + migración).
2. Decidir estrategia de migración de datos reales existentes en OctoDash (¿se migran o se empieza limpio?).
3. Reescribir `sync_repository.dart` sobre el nuevo schema, conservando el patrón outbox.
4. Definir vocabulario inicial completo de `relation_types` y `link_type` antes de escribir código, para evitar inconsistencias desde el día uno.
