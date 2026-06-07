-- ============================================================
-- Board Stuff – Template: Juego Nuevo
-- ============================================================
-- INSTRUCCIONES:
--   1. Reemplazá todos los valores entre << >>.
--   2. Eliminá los bloques que no necesites (ej: sin personajes).
--   3. Ejecutá en: Supabase Dashboard > SQL Editor.
-- ============================================================

DO $$
DECLARE
  game_id   uuid;
  char_1_id uuid;
  char_2_id uuid;
  -- Agregá más variables para más personajes:
  -- char_3_id uuid;
  entry_id  uuid;
BEGIN

-- ── Juego ────────────────────────────────────────────────────
-- difficulty: 'Fácil' | 'Intermedio' | 'Difícil' | 'Experto'
-- cover_image: URL completa de Supabase Storage, o NULL si no tenés imagen aún.
INSERT INTO games (
  slug, title, tagline, description,
  cover_image, players, duration, difficulty,
  theme_primary, theme_secondary, theme_accent, theme_bg,
  published_at, author
) VALUES (
  '<<slug-del-juego>>',       -- ej: 'bang', 'ticket-to-ride'
  '<<Nombre del Juego>>',
  '<<Frase corta descriptiva>>',
  '<<Descripción larga del juego>>',
  NULL,                        -- o: 'https://...supabase.co/storage/v1/object/public/games/<<archivo.webp>>'
  '<<2–4>>',                   -- cantidad de jugadores
  '<<30–60 min>>',
  '<<Intermedio>>',
  '<<#f59e0b>>',               -- color primario (hex) para títulos
  '<<#fde68a>>',               -- color secundario para subtítulos
  '<<#f59e0b>>',               -- color acento para botones/badges
  '<<#1c1002>>',               -- color de fondo del hero
  CURRENT_DATE,
  '<<Autor>>'
)
RETURNING id INTO game_id;

-- ── Reglas (Markdown) ────────────────────────────────────────
-- Usá ## para títulos, **texto** para negrita, | col | col | para tablas.
INSERT INTO game_rules (game_id, content) VALUES (game_id,
'## Objetivo

<<Describí el objetivo del juego.>>

## Preparación

1. <<Paso 1>>
2. <<Paso 2>>

## Turno

<<Describí cómo se juega un turno.>>

## Victoria

<<Condición de victoria.>>

## Palabras Clave

| Término | Efecto |
|---|---|
| **<<Término>>** | <<Descripción del efecto.>> |
');

-- ── Personajes ───────────────────────────────────────────────
-- Repetí este bloque por cada personaje. Eliminalo si el juego no tiene personajes.

-- Personaje 1
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (
  game_id,
  '<<Nombre>>',
  '<<Rol / Clase>>',
  '<<Descripción del personaje.>>',
  1                             -- orden de aparición en la lista
)
RETURNING id INTO char_1_id;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_1_id, '<<Vida>>',  '<<50>>'),
  (char_1_id, '<<DEF>>',   '<<2>>');
  -- Agregá más stats si el personaje las tiene.

-- Habilidad del personaje 1 (eliminá este bloque si no tiene habilidad)
INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (char_1_id,
   '<<Nombre de la Habilidad>>',
   '<<Descripción detallada de la habilidad y sus efectos.>>',
   false,     -- true = habilidad pasiva, false = activa
   1);

-- Personaje 2
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, '<<Nombre>>', '<<Rol>>', '<<Descripción.>>', 2)
RETURNING id INTO char_2_id;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_2_id, '<<Vida>>', '<<40>>');

-- ── Changelog v1.0 ───────────────────────────────────────────
-- type: 'rule' | 'character' | 'mechanic' | 'balance' | 'stat' | 'clarification'

INSERT INTO changelog_entries (game_id, version, date, author, summary)
VALUES (
  game_id,
  '1.0',
  CURRENT_DATE,
  '<<Autor>>',
  '<<Resumen del lanzamiento.>>'
)
RETURNING id INTO entry_id;

INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
  (entry_id, 'rule',      '<<Descripción del cambio de regla.>>', 1),
  (entry_id, 'character', '<<Personaje X añadido — Vida 50, DEF 2.>>', 2),
  (entry_id, 'mechanic',  '<<Palabra clave nueva añadida.>>', 3);
  -- Agregá más filas según los cambios de la versión.

END $$;
