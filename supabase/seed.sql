-- ============================================================
-- Board Stuff – Seed Data
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- IMPORTANTE: correr schema.sql primero
-- ============================================================

-- ============================================================
-- CATAN
-- ============================================================
DO $$
DECLARE
  g_id UUID;
  cl_id UUID;
BEGIN
  INSERT INTO games (slug, title, tagline, description, cover_image, players, duration, difficulty,
    theme_primary, theme_secondary, theme_accent, theme_bg, published_at, author)
  VALUES (
    'catan',
    'Catan',
    'Colonizá, comerciá y dominá la isla.',
    'El clásico juego de estrategia y negociación donde construís asentamientos, ciudades y caminos para colonizar la isla de Catan.',
    '/images/games/catan-cover.webp',
    '3–4', '60–120 min', 'Intermedio',
    '#f59e0b', '#fde68a', '#f59e0b', '#1c1002',
    '2024-01-15', 'Matias'
  )
  RETURNING id INTO g_id;

  INSERT INTO game_rules (game_id, content) VALUES (g_id,
$rules$## Objetivo

El primero en llegar a **10 puntos de victoria** gana la partida. Los puntos se obtienen construyendo asentamientos, ciudades y a través de cartas especiales.

## Preparación

1. Armá el tablero hexagonal de forma aleatoria (o usá la configuración recomendada para principiantes).
2. Colocá los números sobre cada hexágono de recursos.
3. Cada jugador coloca **2 asentamientos** y **2 caminos** en el tablero, en orden inverso para el segundo asentamiento.
4. Cada jugador recibe recursos por los hexágonos adyacentes a su segundo asentamiento.

## Turno de juego

Cada turno tiene tres fases:

### 1. Tirar los dados

Tirás los 2 dados y sumás el resultado. Todos los hexágonos con ese número producen 1 recurso por cada asentamiento adyacente (2 si es ciudad).

> **Excepción:** Si sale 7, no se producen recursos. Todos los jugadores con más de 7 cartas deben descartar la mitad. Luego movés el **Ladrón**.

### 2. Comerciar

Podés intercambiar recursos con otros jugadores o con el banco:

| Tipo de Puerto | Tasa |
|---|---|
| Puerto genérico | 3:1 |
| Puerto específico | 2:1 |
| Sin puerto | 4:1 |

### 3. Construir

| Construcción | Costo |
|---|---|
| Camino | 1 madera + 1 arcilla |
| Asentamiento | 1 madera + 1 arcilla + 1 lana + 1 trigo |
| Ciudad | 2 trigo + 3 mineral |
| Carta de Desarrollo | 1 mineral + 1 lana + 1 trigo |

## El Ladrón

Cuando sale un 7 o jugás la carta Caballero:

- Movés el Ladrón a cualquier hexágono (bloquea su producción).
- Robás 1 carta al azar de un jugador con asentamiento/ciudad adyacente.

## Puntos de Victoria

| Logro | Puntos |
|---|---|
| Asentamiento | 1 |
| Ciudad | 2 |
| Ejército más Grande (≥3 caballeros) | 2 |
| Camino más Largo (≥5 caminos) | 2 |
| Carta de Punto de Victoria | 1 |
$rules$
  );

  -- Changelog
  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.0', '2024-01-15', 'Matias', 'Versión inicial del reglamento.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'rule', 'Reglas base del juego oficial de Catan añadidas.', 0);

  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.1', '2024-02-01', 'Matias', 'Regla de la ciudad inicial y puntos de victoria.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'rule',    'Cada jugador empieza con 2 asentamientos y 2 caminos en posiciones fijas.', 0),
    (cl_id, 'balance', 'La Victoria más Larga ahora requiere 6 caminos continuos (antes 5).', 1);

  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.2', '2024-03-10', 'Matias', 'Ajuste del Ladrón y aclaración del Puerto 3:1.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'rule',          'El Ladrón no puede ser movido al Desierto excepto en el turno inicial.', 0),
    (cl_id, 'clarification', 'El Puerto 3:1 permite cambiar 3 recursos del mismo tipo por 1 cualquiera.', 1);
END $$;


-- ============================================================
-- BANG!
-- ============================================================
DO $$
DECLARE
  g_id  UUID;
  c_id  UUID;
  cl_id UUID;
BEGIN
  INSERT INTO games (slug, title, tagline, description, cover_image, players, duration, difficulty,
    theme_primary, theme_secondary, theme_accent, theme_bg, published_at, author)
  VALUES (
    'bang',
    'Bang!',
    'El duelo del Lejano Oeste en tu mesa.',
    'Juego de roles ocultos donde Sheriff, Forajidos, Renegados y Diputados se enfrentan en un salvaje duelo del Oeste.',
    '/images/games/bang-cover.webp',
    '4–7', '30–60 min', 'Fácil',
    '#ef4444', '#fca5a5', '#ef4444', '#1a0202',
    '2024-02-10', 'Matias'
  )
  RETURNING id INTO g_id;

  INSERT INTO game_rules (game_id, content) VALUES (g_id,
$rules$## Roles

Los roles son **secretos** (excepto el Sheriff que lo revela al inicio):

| Rol | Objetivo | Cantidad |
|---|---|---|
| **Sheriff** | Eliminar a todos los Forajidos y al Renegado | 1 |
| **Diputado** | Proteger al Sheriff a toda costa | 1–2 |
| **Forajido** | Matar al Sheriff | 2–3 |
| **Renegado** | Ser el último en pie | 1 |

> El Sheriff tiene +1 punto de vida máximo y revela su rol.

## Cartas Principales

### BANG!
Atacás a un jugador dentro de tu alcance. El objetivo puede esquivar con un **Missed!** o pierde 1 punto de vida.

### Missed!
Usada como respuesta a un BANG!, anula el daño.

### Beer
Recuperás 1 punto de vida (no funciona si queda 1 solo jugador).

### Gatling
Atacás a **todos** los demás jugadores simultáneamente.

### Indians!
Todos los demás jugadores deben jugar un BANG! o perder 1 punto de vida.

## Cartas de Equipamiento

| Carta | Efecto |
|---|---|
| **Mustang** | Tu distancia aumenta en 1 para los demás |
| **Scope** | Alcanzás a los demás a 1 de distancia menos |
| **Barril** | Ante cada BANG!, "sacás" una carta; si es ♥, el disparo falla |
| **Carcel** | El jugador pierde su próximo turno |
| **Dinamita** | Pasa al siguiente jugador; explota con ♠ 2–9 causando 3 de daño |

## Turno de Juego

1. **Robar** 2 cartas del mazo.
2. **Jugar** tantas cartas como quieras (máximo 1 BANG! por turno salvo habilidad especial).
3. **Descartar** hasta el límite de mano (igual a tu vida actual).

## Condiciones de Victoria

- **Sheriff + Diputados** ganan si eliminan a todos los Forajidos y al Renegado.
- **Forajidos** ganan si el Sheriff muere.
- **Renegado** gana si es el último en pie y luego elimina al Sheriff.
$rules$
  );

  -- Personaje: Bart Cassidy
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'Bart Cassidy', 'Forajido', 'Un bandido resiliente que se recupera rápido de los golpes.', 0)
  RETURNING id INTO c_id;
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Resistencia', 'Cada vez que pierde 1 punto de vida, roba inmediatamente 1 carta.', true, 0);

  -- Personaje: El Gringo
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'El Gringo', 'Forajido', 'Un pistolero que sabe robar a sus enemigos en pleno duelo.', 1)
  RETURNING id INTO c_id;
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Robo al Atacante', 'Cada vez que pierde 1 punto de vida por un BANG! de otro jugador, roba 1 carta aleatoria de ese jugador.', true, 0);

  -- Personaje: Jesse Jones
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'Jesse Jones', 'Sheriff', 'Un Sheriff carismático que puede persuadir a otros para que le entreguen sus cartas.', 2)
  RETURNING id INTO c_id;
  INSERT INTO character_stats (character_id, key, value) VALUES (c_id, 'vida', '5');
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Extorsión', 'En la fase de robo, puede robar la primera carta de otro jugador en lugar de del mazo.', false, 0);

  -- Personaje: Jourdonnais
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'Jourdonnais', 'Diputado', 'Un marinero con piel dura que esquiva balas con sorprendente habilidad.', 3)
  RETURNING id INTO c_id;
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Barril Permanente', 'Siempre se considera que tiene un Barril en juego (no necesita la carta).', true, 0);

  -- Personaje: Kit Carlson
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'Kit Carlson', 'Renegado', 'Un pistolero astuto que mira el futuro antes de robar sus cartas.', 4)
  RETURNING id INTO c_id;
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Vista Privilegiada', 'En la fase de robo, mira las 3 primeras cartas del mazo, toma 2 y devuelve 1 al fondo.', false, 0);

  -- Personaje: Lucky Duke
  INSERT INTO characters (game_id, name, role, description, sort_order)
  VALUES (g_id, 'Lucky Duke', 'Forajido', 'Un apostador con una suerte increíble al sacar cartas del mazo.', 5)
  RETURNING id INTO c_id;
  INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
    (c_id, 'Suerte del Apostador', 'Cuando hace un "check" (barril, cárcel, Dinamita), saca 2 cartas y elige cuál aplica.', true, 0);

  -- Changelog
  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.0', '2024-02-10', 'Matias', 'Versión inicial con roles y personajes base.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'rule',      'Reglas base del juego oficial de Bang! añadidas.', 0),
    (cl_id, 'character', '6 personajes iniciales documentados con sus habilidades.', 1);

  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.2', '2024-03-01', 'Matias', 'Habilidades de personajes actualizadas.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'character', 'Lucky Duke: aclarado que saca 2 cartas también para el check de la Cárcel.', 0),
    (cl_id, 'character', 'Kit Carlson: la carta devuelta va al fondo del mazo, no al descarte.', 1);

  INSERT INTO changelog_entries (game_id, version, date, author, summary)
  VALUES (g_id, '1.3', '2024-04-05', 'Matias', 'Regla de la Dinamita y distancias de personajes.')
  RETURNING id INTO cl_id;
  INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
    (cl_id, 'rule',          'La Dinamita explota con ♠ 2–9. Si no explota, pasa al jugador de la izquierda.', 0),
    (cl_id, 'clarification', 'La distancia del Alcance se cuenta en ambas direcciones; se usa la menor.', 1);
END $$;
