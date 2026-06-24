# TODO
Algunas ideas agrupadas por área:

## Contenido / Juegos

- Buscador o filtro de juegos por dificultad, jugadores, duración
- Página de búsqueda global (buscar reglas o personajes de todos los juegos a la vez)
- Soporte para imágenes de personajes (el campo ya existe en la DB pero no se usa)
- Cover images para los juegos que no tienen (NULL en todos los actuales)

## Experiencia en partida

- Referencia rápida tipo "cheat sheet" por juego — versión condensada de las reglas para tener abierta durante la partida
- Tracker de dados / probabilidades para Rompetropas (dado que el sistema de dados es complejo)
- Tracker de vida para combates de Forge of Realms y Rompetropas
- Timer de turno

## Navegación / UX

- Tabla de contenidos sticky dentro de la página de juego (para reglas largas como Rompetropas)
- ~~Modo oscuro / claro~~ ✅
- Ancla directa a secciones — compartir link que abra directo a "Personajes" o "Historial"
- Social / Grupo

## Historial de partidas — registrar quién ganó cada sesión

- Comentarios o notas por regla (tipo "aclaración de la última partida")
- Sistema de votación para la próxima sesión / próximo juego a jugar

## Astro 7 — features pendientes

- **Cache API** — cachear queries de Supabase entre builds para que rebuilds parciales no re-fetcheen todo
- **Server Islands** — hidratación lazy de `CharacterCard` y `ChangeHistory` con `server:defer`; requiere migrar el hosting de GitHub Pages a un adapter con servidor (Cloudflare Pages, Vercel, etc.)
- **Astro Actions** — endpoints type-safe para mutations (agregar entradas al historial, editar reglas) sin exponer Supabase al cliente
- **Content Collections** — mover reglas y personajes a archivos `.md`/`.mdx` con frontmatter tipado, usando git como source of truth en vez de Supabase
- @astrojs/sitemap + astro-icon + @playform/compress

## Admin / Gestión

- Panel de administración para editar juegos sin tocar SQL
- Preview de cambios antes de publicar una nueva versión del reglamento
