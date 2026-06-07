-- ============================================================
-- Board Stuff – Template: Actualizar Juego Existente
-- ============================================================
-- INSTRUCCIONES:
--   1. Reemplazá '<<slug-del-juego>>' con el slug real.
--   2. Descomentá y completá solo los bloques que necesitás.
--   3. Ejecutá en: Supabase Dashboard > SQL Editor.
-- ============================================================

DO $$
DECLARE
  game_id      uuid;
  new_char_id  uuid;
  entry_id     uuid;
BEGIN

-- Resolvemos el ID del juego por slug
SELECT id INTO game_id FROM games WHERE slug = '<<slug-del-juego>>';
IF game_id IS NULL THEN
  RAISE EXCEPTION 'Juego "%" no encontrado.', '<<slug-del-juego>>';
END IF;

-- ── B.1: Actualizar datos del juego ──────────────────────────
-- Descomentá solo los campos que querés cambiar.
/*
UPDATE games SET
  title       = '<<Nuevo título>>',
  tagline     = '<<Nueva frase>>',
  description = '<<Nueva descripción>>',
  cover_image = '<<https://...supabase.co/storage/v1/object/public/games/archivo.webp>>',
  players     = '<<3–5>>',
  duration    = '<<45–90 min>>',
  difficulty  = '<<Difícil>>',
  theme_primary   = '<<#hex>>',
  theme_secondary = '<<#hex>>',
  theme_accent    = '<<#hex>>',
  theme_bg        = '<<#hex>>'
WHERE id = game_id;
*/

-- ── B.2: Actualizar reglas ────────────────────────────────────
/*
UPDATE game_rules
SET content = '<<Nuevo contenido markdown completo>>'
WHERE game_id = game_id;
*/

-- ── B.3: Agregar personaje nuevo ─────────────────────────────
/*
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, '<<Nombre>>', '<<Rol>>', '<<Descripción.>>', <<10>>)
RETURNING id INTO new_char_id;

INSERT INTO character_stats (character_id, key, value) VALUES
  (new_char_id, '<<Vida>>', '<<45>>'),
  (new_char_id, '<<DEF>>',  '<<1>>');

INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (new_char_id, '<<Habilidad>>', '<<Descripción.>>', false, 1);
*/

-- ── B.4: Cambiar stat de un personaje ────────────────────────
/*
UPDATE character_stats
SET value = '<<Nuevo valor>>'
WHERE key = '<<Vida>>'
  AND character_id = (
    SELECT id FROM characters
    WHERE game_id = game_id AND name = '<<Nombre del personaje>>'
  );
*/

-- ── B.5: Nuevo parche en el historial ────────────────────────
-- type: 'rule' | 'character' | 'mechanic' | 'balance' | 'stat' | 'clarification'

INSERT INTO changelog_entries (game_id, version, date, author, summary)
VALUES (
  game_id,
  '<<1.2>>',
  CURRENT_DATE,
  '<<Autor>>',
  '<<Resumen del parche.>>'
)
RETURNING id INTO entry_id;

INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
  (entry_id, 'balance',   '<<Personaje X: Vida 50 → 60.>>', 1),
  (entry_id, 'mechanic',  '<<Mecánica Y modificada.>>', 2),
  (entry_id, 'character', '<<Nuevo personaje Z añadido.>>', 3);
  -- Agregá más filas según los cambios de la versión.

END $$;
