-- ============================================================
-- Forge of Realms – Datos completos
-- Incluye: juego, reglas, 15 personajes (stats post-1.1),
--          changelog v1.0 (lanzamiento) y v1.1 (balance patch)
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- ============================================================

DO $$
DECLARE
  game_id      uuid;
  char_eredin  uuid;
  char_pugo    uuid;
  char_anciano uuid;
  char_ciri    uuid;
  char_geralt  uuid;
  char_jaskier uuid;
  char_triss   uuid;
  char_saskia  uuid;
  char_hemdall uuid;
  char_zoltan  uuid;
  char_dijkstra   uuid;
  char_vilgefortz uuid;
  char_cantarella uuid;
  char_hattori    uuid;
  char_percival   uuid;
  entry_v10    uuid;
  entry_v11    uuid;
BEGIN

-- ── Juego ────────────────────────────────────────────────────
INSERT INTO games (
  slug, title, tagline, description,
  cover_image, players, duration, difficulty,
  theme_primary, theme_secondary, theme_accent, theme_bg,
  published_at, author
) VALUES (
  'forge-of-realms',
  'Forge of Realms',
  'Duelos épicos con dados en un mundo de fantasía oscura.',
  'Juego de duelo 1v1 donde cada jugador elige un personaje con estadísticas y dados únicos. Ambos tiran sus dados al mismo tiempo: el atacante declara primero, luego el defensor. El primero en reducir los PV del oponente a 0 gana.',
  NULL,
  '2',
  '15–30 min',
  'Intermedio',
  '#c8a96e',
  '#a08050',
  '#e8c97e',
  '#120e08',
  CURRENT_DATE,
  'Board Stuff'
)
RETURNING id INTO game_id;

-- ── Reglas ───────────────────────────────────────────────────
INSERT INTO game_rules (game_id, content) VALUES (game_id,
'## Objetivo

Reducir los Puntos de Vida (PV) del oponente a **0 o menos**.

## Preparación

1. Cada jugador elige un **personaje** con sus PV, DEF y dados asignados.
2. Se acuerda quién ataca primero en el primer turno.

## Turno

1. **Ambos jugadores tiran sus dados al mismo tiempo.**
2. El **atacante** selecciona y declara los dados con los que ataca.
3. El **defensor** selecciona y declara los dados con los que defiende.
4. Se aplican habilidades, efectos de estado y palabras clave.
5. **Daño recibido** = suma de dados del atacante − DEF del defensor (mínimo 0).
6. El defensor resta ese daño a sus PV.
7. Los roles se intercambian para el siguiente turno.

## Victoria

El jugador que lleve los PV del oponente a **0 o menos** gana la partida.

## Palabras Clave

| Término | Efecto |
|---|---|
| **Escarcha** | Acumulación que puede usarse para potenciar habilidades. |
| **Divinidad** | Acumulación que, al llegar a 3 por primera vez, se vuelve permanente. |
| **Veneno** | Estado que inflige daño pasivo al portador cada ronda. |
| **Sabotaje** | Reduce en **−4** el valor del dado de mayor valor seleccionado por el oponente. |
');

-- ── Personajes ───────────────────────────────────────────────

-- 1. Eredin
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Eredin', 'Atacante de Escarcha',
  'Rey de la Cacería Salvaje. Cada golpe que recibe alimenta la escarcha que luego libera con devastadora precisión.',
  1)
RETURNING id INTO char_eredin;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_eredin, 'Vida', '50'),
  (char_eredin, 'DEF',  '3');

INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (char_eredin, 'Escarcha Vengadora',
   'Al recibir daño, ambos jugadores obtienen 3 de Escarcha. Al atacar, si todos los dados seleccionados son diferentes entre sí, inflige daño adicional igual a la Escarcha que recibiste durante la ronda anterior.',
   false, 1);

-- 2. Pugo
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Pugo', 'Brawler Resistente',
  'Tanque implacable que puede forzar la suerte a costa de su propia vida.',
  2)
RETURNING id INTO char_pugo;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_pugo, 'Vida', '90');

INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (char_pugo, 'Segunda Oportunidad',
   'Al atacar o defender: puede volver a tirar todos los dados hasta 6 veces. Cada tirada extra consume 2 / 3 / 4 / 5 / 6 / 7 PV respectivamente.',
   false, 1);

-- 3. Anciano Oculto
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Anciano Oculto', 'Mago Misterioso',
  'Sabio de poder desconocido, oculto entre las sombras del mundo. Nadie conoce sus verdaderas capacidades.',
  3)
RETURNING id INTO char_anciano;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_anciano, 'Vida', '50');

-- 4. Ciri
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Ciri', 'Guerrera Ágil',
  'Portadora del Elder Blood. Su agilidad y entrenamiento como brujo la convierten en una combatiente excepcional.',
  4)
RETURNING id INTO char_ciri;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_ciri, 'Vida', '66');

-- 5. Geralt
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Geralt', 'Cazador de Monstruos',
  'El Lobo Blanco. Brujo experimentado, forjado en combate contra criaturas que los demás ni se atreven a enfrentar.',
  5)
RETURNING id INTO char_geralt;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_geralt, 'Vida', '60');

-- 6. Jaskier
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Jaskier', 'Bardo',
  'El eterno compañero de Geralt. Su música y su ingenio pueden cambiar el curso de cualquier batalla.',
  6)
RETURNING id INTO char_jaskier;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_jaskier, 'Vida', '50');

-- 7. Triss
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Triss', 'Hechicera de Fuego',
  'Una de las hechiceras más poderosas de la era, especialista en magia elemental ofensiva.',
  7)
RETURNING id INTO char_triss;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_triss, 'Vida', '50');

-- 8. Saskia
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Saskia', 'Dragona Guerrera',
  'Draconida de sangre Viraxas. Combatiente feroz e imparable tanto en forma humana como en su verdadera naturaleza.',
  8)
RETURNING id INTO char_saskia;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_saskia, 'Vida', '60');

-- 9. Hemdall
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Hemdall', 'Guardián Divino',
  'Centinela de los dioses. Acumula poder divino con cada ataque preciso hasta alcanzar una fuerza permanente.',
  9)
RETURNING id INTO char_hemdall;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_hemdall, 'Vida', '100');

INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (char_hemdall, 'Acumulación Divina',
   'Al atacar: si los valores de los dados seleccionados son consecutivos, gana 1 acumulación de Divinidad; de lo contrario, pierde 1 acumulación de Divinidad. Al llegar a 3 acumulaciones de Divinidad por primera vez, estas se mantienen de forma permanente.',
   false, 1);

-- 10. Zoltan
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Zoltan', 'Guerrero Enano',
  'El enano más leal del mundo. Su fuerza bruta no tiene igual entre la gente pequeña.',
  10)
RETURNING id INTO char_zoltan;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_zoltan, 'Vida', '50');

-- 11. Dijkstra
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Dijkstra', 'Maestro Espía',
  'Ex-jefe de los servicios secretos de Redania. Conoce los secretos de todos y los usa a su favor.',
  11)
RETURNING id INTO char_dijkstra;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_dijkstra, 'Vida', '70');

-- 12. Vilgefortz
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Vilgefortz', 'Mago Traidor',
  'El mago más poderoso de la era. Ocultó sus verdaderas intenciones hasta el final, y su poder lo refleja.',
  12)
RETURNING id INTO char_vilgefortz;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_vilgefortz, 'Vida', '60'),
  (char_vilgefortz, 'DEF',  '3');

-- 13. Cantarella
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Cantarella', 'Envenenadora',
  'Agente de los servicios secretos. Maestra del veneno y el engaño, infecta a sus rivales con cada ataque.',
  13)
RETURNING id INTO char_cantarella;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_cantarella, 'Vida', '60');

INSERT INTO character_abilities (character_id, name, description, passive, sort_order) VALUES
  (char_cantarella, 'Dosis Letal',
   'Al atacar: por cada número par en los dados seleccionados, aplica 2 acumulaciones de Veneno al oponente. Si todos los dados seleccionados son pares, el Veneno del oponente hace efecto 1 vez de inmediato.',
   false, 1);

-- 14. Éibhear Hattori
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Éibhear Hattori', 'Herrero Élfico',
  'Maestro armero elfo. Sus creaciones son únicas en el mundo conocido; sus habilidades de combate tampoco se quedan atrás.',
  14)
RETURNING id INTO char_hattori;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_hattori, 'Vida', '60');

-- 15. Percival
INSERT INTO characters (game_id, name, role, description, sort_order)
VALUES (game_id, 'Percival', 'Gnomo Tramposo',
  'Gnomo de la compañía de Geralt. Sus ilusiones y artimañas confunden al enemigo en el momento menos esperado.',
  15)
RETURNING id INTO char_percival;

INSERT INTO character_stats (character_id, key, value) VALUES
  (char_percival, 'Vida', '70');

-- ── Changelog ────────────────────────────────────────────────

-- v1.0 – Lanzamiento inicial
INSERT INTO changelog_entries (game_id, version, date, author, summary)
VALUES (game_id, '1.0', '2026-01-01', 'Board Stuff',
  'Lanzamiento inicial de Forge of Realms con 15 personajes jugables y mecánicas base.')
RETURNING id INTO entry_v10;

INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
  (entry_v10, 'rule',      'Mecánica base: ambos jugadores tiran dados simultáneamente; el atacante declara primero.', 1),
  (entry_v10, 'mechanic',  'Palabra clave añadida — Sabotaje: convierte el dado de mayor valor del oponente a su valor mínimo.', 2),
  (entry_v10, 'mechanic',  'Palabra clave añadida — Veneno: estado que inflige daño pasivo al portador cada ronda.', 3),
  (entry_v10, 'mechanic',  'Palabra clave añadida — Escarcha: acumulación que potencia ciertas habilidades.', 4),
  (entry_v10, 'mechanic',  'Palabra clave añadida — Divinidad: acumulación que se vuelve permanente al llegar a 3.', 5),
  (entry_v10, 'character', 'Eredin añadido — Vida 25, DEF 2.', 6),
  (entry_v10, 'character', 'Pugo añadido — Vida 49.', 7),
  (entry_v10, 'character', 'Anciano Oculto añadido — Vida 20.', 8),
  (entry_v10, 'character', 'Ciri añadida — Vida 33.', 9),
  (entry_v10, 'character', 'Geralt añadido — Vida 30.', 10),
  (entry_v10, 'character', 'Jaskier añadido — Vida 22.', 11),
  (entry_v10, 'character', 'Triss añadida — Vida 25.', 12),
  (entry_v10, 'character', 'Saskia añadida — Vida 28.', 13),
  (entry_v10, 'character', 'Hemdall añadido — Vida 50.', 14),
  (entry_v10, 'character', 'Zoltan añadido — Vida 25.', 15),
  (entry_v10, 'character', 'Dijkstra añadido — Vida 36.', 16),
  (entry_v10, 'character', 'Vilgefortz añadido — Vida 27, DEF 2.', 17),
  (entry_v10, 'character', 'Cantarella añadida — Vida 28.', 18),
  (entry_v10, 'character', 'Éibhear Hattori añadido — Vida 30.', 19),
  (entry_v10, 'character', 'Percival añadido — Vida 36.', 20);

-- v1.1 – Gran parche de balance
INSERT INTO changelog_entries (game_id, version, date, author, summary)
VALUES (game_id, '1.1', '2026-06-07', 'Board Stuff',
  'Gran parche de balance: duplicación general de vida, reworks de habilidades y cambio a la palabra clave Sabotaje.')
RETURNING id INTO entry_v11;

INSERT INTO changelog_changes (changelog_entry_id, type, description, sort_order) VALUES
  (entry_v11, 'balance',   'Eredin: Vida 25 → 50, DEF 2 → 3.', 1),
  (entry_v11, 'character', 'Eredin — Rework de habilidad: Al recibir daño, ambos jugadores obtienen 3 de Escarcha. Al atacar, si todos los dados seleccionados son diferentes entre sí, inflige daño adicional igual a la Escarcha recibida durante la ronda anterior.', 2),
  (entry_v11, 'balance',   'Pugo: Vida 49 → 90.', 3),
  (entry_v11, 'character', 'Pugo — Rework de habilidad: Al atacar o defender puede volver a tirar los dados hasta 6 veces; cada tirada extra consume 2/3/4/5/6/7 PV respectivamente.', 4),
  (entry_v11, 'balance',   'Anciano Oculto: Vida 20 → 50.', 5),
  (entry_v11, 'balance',   'Ciri: Vida 33 → 66.', 6),
  (entry_v11, 'balance',   'Geralt: Vida 30 → 60.', 7),
  (entry_v11, 'balance',   'Jaskier: Vida 22 → 50.', 8),
  (entry_v11, 'balance',   'Triss: Vida 25 → 50.', 9),
  (entry_v11, 'balance',   'Saskia: Vida 28 → 60.', 10),
  (entry_v11, 'balance',   'Hemdall: Vida 50 → 100.', 11),
  (entry_v11, 'character', 'Hemdall — Rework de habilidad: Al atacar, si los dados seleccionados son consecutivos gana 1 Divinidad; si no, pierde 1. Al llegar a 3 Divinidad por primera vez, se mantienen permanentemente.', 12),
  (entry_v11, 'balance',   'Zoltan: Vida 25 → 50.', 13),
  (entry_v11, 'balance',   'Dijkstra: Vida 36 → 70.', 14),
  (entry_v11, 'balance',   'Vilgefortz: Vida 27 → 60, DEF 2 → 3.', 15),
  (entry_v11, 'balance',   'Cantarella: Vida 28 → 60.', 16),
  (entry_v11, 'character', 'Cantarella — Rework de habilidad: Al atacar, por cada número par en los dados seleccionados aplica 2 acumulaciones de Veneno. Si todos son pares, el Veneno hace efecto 1 vez de inmediato.', 17),
  (entry_v11, 'balance',   'Éibhear Hattori: Vida 30 → 60.', 18),
  (entry_v11, 'balance',   'Percival: Vida 36 → 70.', 19),
  (entry_v11, 'mechanic',  'Sabotaje (cambio): antes convertía el dado de mayor valor al mínimo; ahora reduce su valor en −4.', 20);

END $$;
