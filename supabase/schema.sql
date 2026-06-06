-- ============================================================
-- Board Stuff – Schema
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- ============================================================

-- Juegos
CREATE TABLE games (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         TEXT UNIQUE NOT NULL,
  title        TEXT NOT NULL,
  tagline      TEXT NOT NULL DEFAULT '',
  description  TEXT NOT NULL DEFAULT '',
  cover_image  TEXT,
  players      TEXT NOT NULL DEFAULT '',
  duration     TEXT NOT NULL DEFAULT '',
  difficulty   TEXT NOT NULL CHECK (difficulty IN ('Fácil', 'Intermedio', 'Difícil', 'Experto')),
  theme_primary   TEXT NOT NULL DEFAULT '#f59e0b',
  theme_secondary TEXT NOT NULL DEFAULT '#fde68a',
  theme_accent    TEXT NOT NULL DEFAULT '#f59e0b',
  theme_bg        TEXT NOT NULL DEFAULT '#1c1002',
  published_at DATE NOT NULL DEFAULT CURRENT_DATE,
  author       TEXT NOT NULL DEFAULT '',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Reglas (markdown almacenado como texto)
CREATE TABLE game_rules (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id   UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  content   TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (game_id)
);

-- Personajes
CREATE TABLE characters (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id     UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  role        TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  image       TEXT,
  sort_order  INT NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Estadísticas de personajes (clave/valor)
CREATE TABLE character_stats (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  character_id UUID NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  key          TEXT NOT NULL,
  value        TEXT NOT NULL
);

-- Habilidades de personajes
CREATE TABLE character_abilities (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  character_id UUID NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  description  TEXT NOT NULL DEFAULT '',
  passive      BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order   INT NOT NULL DEFAULT 0
);

-- Entradas del historial de cambios
CREATE TABLE changelog_entries (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id   UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  version   TEXT NOT NULL,
  date      DATE NOT NULL DEFAULT CURRENT_DATE,
  author    TEXT NOT NULL DEFAULT '',
  summary   TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Cambios individuales dentro de una entrada
CREATE TABLE changelog_changes (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  changelog_entry_id UUID NOT NULL REFERENCES changelog_entries(id) ON DELETE CASCADE,
  type               TEXT NOT NULL CHECK (type IN ('rule','stat','character','mechanic','balance','clarification')),
  description        TEXT NOT NULL,
  sort_order         INT NOT NULL DEFAULT 0
);

-- ============================================================
-- Trigger: actualiza updated_at automáticamente
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_games_updated_at
  BEFORE UPDATE ON games
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_rules_updated_at
  BEFORE UPDATE ON game_rules
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- RLS: acceso de lectura público (anon key)
-- ============================================================
ALTER TABLE games              ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_rules         ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters         ENABLE ROW LEVEL SECURITY;
ALTER TABLE character_stats    ENABLE ROW LEVEL SECURITY;
ALTER TABLE character_abilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE changelog_entries  ENABLE ROW LEVEL SECURITY;
ALTER TABLE changelog_changes  ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read" ON games              FOR SELECT USING (true);
CREATE POLICY "public read" ON game_rules         FOR SELECT USING (true);
CREATE POLICY "public read" ON characters         FOR SELECT USING (true);
CREATE POLICY "public read" ON character_stats    FOR SELECT USING (true);
CREATE POLICY "public read" ON character_abilities FOR SELECT USING (true);
CREATE POLICY "public read" ON changelog_entries  FOR SELECT USING (true);
CREATE POLICY "public read" ON changelog_changes  FOR SELECT USING (true);

-- ============================================================
-- Datos de ejemplo – Catan
-- ============================================================
WITH g AS (
  INSERT INTO games (slug, title, tagline, description, cover_image, players, duration, difficulty,
    theme_primary, theme_secondary, theme_accent, theme_bg, published_at, author)
  VALUES (
    'catan', 'Catan', 'Colonizá, comerciá y dominá la isla.',
    'El clásico juego de estrategia y negociación donde construís asentamientos, ciudades y caminos.',
    '/images/games/catan-cover.webp', '3–4', '60–120 min', 'Intermedio',
    '#f59e0b', '#fde68a', '#f59e0b', '#1c1002', '2024-01-15', 'Matias'
  )
  RETURNING id
),
r AS (
  INSERT INTO game_rules (game_id, content)
  SELECT id, E'## Objetivo\n\nEl primero en llegar a **10 puntos de victoria** gana la partida.\n\n## Preparación\n\n1. Armá el tablero hexagonal de forma aleatoria.\n2. Colocá los números sobre cada hexágono de recursos.\n3. Cada jugador coloca **2 asentamientos** y **2 caminos** en el tablero.\n4. Cada jugador recibe recursos por los hexágonos adyacentes a su segundo asentamiento.\n\n## Turno de juego\n\n### 1. Tirar los dados\n\nTirás los 2 dados y sumás el resultado. Todos los hexágonos con ese número producen recursos.\n\n> **Si sale 7:** no se producen recursos. Todos los jugadores con más de 7 cartas descartan la mitad. Luego movés el **Ladrón**.\n\n### 2. Comerciar\n\n| Tipo de Puerto | Tasa |\n|---|---|\n| Puerto genérico | 3:1 |\n| Puerto específico | 2:1 |\n| Sin puerto | 4:1 |\n\n### 3. Construir\n\n| Construcción | Costo |\n|---|---|\n| Camino | 1 madera + 1 arcilla |\n| Asentamiento | 1 madera + 1 arcilla + 1 lana + 1 trigo |\n| Ciudad | 2 trigo + 3 mineral |\n| Carta de Desarrollo | 1 mineral + 1 lana + 1 trigo |'
  FROM g
),
cl1 AS (
  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  SELECT id, '1.0', '2024-01-15', 'Matias', 'Versión inicial del reglamento.' FROM g
  RETURNING id
),
cl2 AS (
  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  SELECT id, '1.2', '2024-03-10', 'Matias', 'Ajuste del Ladrón y aclaración del Puerto 3:1.' FROM g
  RETURNING id
)
INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order)
SELECT id, 'rule', 'Reglas base del juego oficial de Catan añadidas.', 0 FROM cl1
UNION ALL
SELECT id, 'rule', 'El Ladrón no puede ser movido al Desierto excepto en el turno inicial.', 0 FROM cl2
UNION ALL
SELECT id, 'clarification', 'El Puerto 3:1 permite cambiar 3 recursos del mismo tipo por 1 cualquiera.', 1 FROM cl2;
