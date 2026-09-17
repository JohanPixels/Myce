-- Schema Myce v1 — docs/fuente_de_verdad.md
-- Corre esto una sola vez en el SQL editor de Supabase (Project > SQL Editor).
-- Espeja 1:1 el schema local de Drift (lib/core/database/app_database.dart).
--
-- Estado del sync en código (2026-09-16): sync_repository.dart hace push Y
-- pull de las 15 tablas de este schema (entities + 7 tipo, relations,
-- tasks+activity_links, inbox_items, tags+entity_tags) vía syncNow(db).
-- relation_types es la única tabla de solo lectura (vocabulario compartido,
-- sembrado una vez acá abajo).

-- ENTITIES --------------------------------------------------------------
create table if not exists public.entities (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null,
  title text not null,
  description text,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

alter table public.entities enable row level security;
create policy "entities_own" on public.entities
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- TABLAS ESPECÍFICAS POR TIPO ---------------------------------------------
create table if not exists public.projects (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  started_at timestamptz,
  completed_at timestamptz
);
alter table public.projects enable row level security;
create policy "projects_own" on public.projects
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.notes (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  content text
);
alter table public.notes enable row level security;
create policy "notes_own" on public.notes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.areas (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade
);
alter table public.areas enable row level security;
create policy "areas_own" on public.areas
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.resources (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade
);
alter table public.resources enable row level security;
create policy "resources_own" on public.resources
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.people (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade
);
alter table public.people enable row level security;
create policy "people_own" on public.people
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.hobbies (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade
);
alter table public.hobbies enable row level security;
create policy "hobbies_own" on public.hobbies
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.goals (
  entity_id uuid primary key references public.entities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade
);
alter table public.goals enable row level security;
create policy "goals_own" on public.goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- RELATIONS ----------------------------------------------------------------
-- relation_types es vocabulario compartido, no por-usuario: cualquier
-- usuario autenticado puede leerlo, nadie lo escribe desde el cliente.
create table if not exists public.relation_types (
  id uuid primary key,
  key text not null unique,
  label text not null,
  inverse_label text not null,
  directed boolean not null default true,
  description text
);
alter table public.relation_types enable row level security;
create policy "relation_types_read" on public.relation_types
  for select using (auth.role() = 'authenticated');

insert into public.relation_types (id, key, label, inverse_label, directed) values
  (gen_random_uuid(), 'belongs_to', 'Belongs to', 'Contains', true),
  (gen_random_uuid(), 'uses', 'Uses', 'Used by', true),
  (gen_random_uuid(), 'related_to', 'Related to', 'Related to', false),
  (gen_random_uuid(), 'derived_from', 'Derived from', 'Source of', true),
  (gen_random_uuid(), 'inspired_by', 'Inspired by', 'Inspires', true),
  (gen_random_uuid(), 'relevant_to', 'Relevant to', 'Has relevant', true),
  (gen_random_uuid(), 'supports', 'Supports', 'Supported by', true),
  (gen_random_uuid(), 'recommends', 'Recommends', 'Recommended by', true),
  (gen_random_uuid(), 'contributes_to', 'Contributes to', 'Receives contribution from', true)
on conflict (key) do nothing;

create table if not exists public.relations (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  source_entity_id uuid not null references public.entities(id) on delete cascade,
  target_entity_id uuid not null references public.entities(id) on delete cascade,
  relation_type_id uuid not null references public.relation_types(id),
  note text,
  metadata jsonb,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);
alter table public.relations enable row level security;
create policy "relations_own" on public.relations
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- TASKS + ACTIVITY_LINKS -----------------------------------------------------
create table if not exists public.tasks (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  status text not null default 'pending',
  priority text not null default 'none',
  due_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
alter table public.tasks enable row level security;
create policy "tasks_own" on public.tasks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- activity_id sin FK real a propósito (SQL no soporta FK condicional hacia
-- tasks u habits según activity_type) — docs/fuente_de_verdad.md §7.3.
create table if not exists public.activity_links (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  activity_type text not null,
  activity_id uuid not null,
  entity_id uuid not null references public.entities(id) on delete cascade,
  link_type text not null,
  created_at timestamptz not null default now()
);
alter table public.activity_links enable row level security;
create policy "activity_links_own" on public.activity_links
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- INBOX ----------------------------------------------------------------------
create table if not exists public.inbox_items (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  content text not null,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);
alter table public.inbox_items enable row level security;
create policy "inbox_items_own" on public.inbox_items
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- TAGS -------------------------------------------------------------------------
create table if not exists public.tags (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  unique (user_id, name)
);
alter table public.tags enable row level security;
create policy "tags_own" on public.tags
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.entity_tags (
  entity_id uuid not null references public.entities(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (entity_id, tag_id)
);
alter table public.entity_tags enable row level security;
create policy "entity_tags_own" on public.entity_tags
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- MIGRACIÓN INCREMENTAL — sync extendido más allá de `entities` (2026-09).
-- Correr a mano en el SQL editor si el proyecto ya corrió una versión
-- anterior de este archivo; usa IF NOT EXISTS así que también es seguro
-- correrlo en un proyecto nuevo.
alter table public.activity_links add column if not exists deleted_at timestamptz;
alter table public.entity_tags add column if not exists deleted_at timestamptz;
