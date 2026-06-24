# Board Stuff

Sitio de referencia para juegos de mesa: reglas, personajes, mecánicas e historial de cambios. Hecho para el grupo.

🌐 **[board-stuff en GitHub Pages](https://PelaDone.github.io/board-stuff)**

---

## Stack

| Capa | Tecnología |
|---|---|
| Framework | Astro 7 (output estático) |
| UI interactiva | React 19 + Motion |
| Estilos | Tailwind CSS v3 |
| Íconos | astro-icon + Iconify (lucide) |
| Base de datos | Supabase (PostgreSQL) |
| Optimización | @playform/compress |
| Hosting | GitHub Pages |

---

## Estructura

```
src/
├── components/
│   ├── GameCard.tsx        ← Card animada (home)
│   ├── CharacterCard.tsx   ← Accordion expand/collapse
│   └── ChangeHistory.tsx   ← Timeline de versiones
├── layouts/
│   ├── BaseLayout.astro    ← Header + footer + View Transitions
│   └── GameLayout.astro    ← Hero + tabs (Reglas / Personajes / Historial)
├── lib/
│   ├── db.ts               ← Queries a Supabase
│   ├── supabase.ts         ← Cliente Supabase
│   └── types.ts            ← Tipos TypeScript
├── pages/
│   ├── index.astro         ← Home con grilla de juegos
│   └── games/[slug].astro  ← Página de juego
└── styles/global.css
supabase/
├── schema.sql              ← Esquema completo de tablas
├── seed.sql                ← Datos de ejemplo
└── templates/
    ├── new-game.sql        ← Template para agregar un juego
    └── update-game.sql     ← Template para editar reglas / changelog
```

---

## Setup local

### 1. Instalar dependencias

```bash
npm install
```

### 2. Variables de entorno

Crear `.env` en la raíz con las claves de Supabase:

```env
PUBLIC_SUPABASE_URL=https://<project>.supabase.co
PUBLIC_SUPABASE_ANON_KEY=<anon-key>
```

Las claves están en **Supabase Dashboard → Project Settings → API**.

### 3. Base de datos

Ejecutar `supabase/schema.sql` en **Supabase Dashboard → SQL Editor** para crear las tablas. Opcionalmente ejecutar `supabase/seed.sql` para cargar datos de ejemplo.

### 4. Comandos

```bash
npm run dev      # Servidor de desarrollo en localhost:4321
npm run build    # Build estático en /dist
npm run preview  # Preview del build
```

---

## Agregar un juego

Usar el template `supabase/templates/new-game.sql`: reemplazar los valores entre `<< >>` y ejecutar en el SQL Editor de Supabase. El build del sitio tomará los datos automáticamente.

El template cubre:
- Datos del juego (título, tema de colores, dificultad, jugadores, duración)
- Reglas en Markdown (soporta tablas, blockquotes, headings, negrita)
- Personajes con estadísticas y habilidades (activas/pasivas)
- Changelog v1.0 inicial

### Colores del tema

Cada juego define su paleta visual con 4 colores hex:

| Campo | Uso |
|---|---|
| `theme_primary` | Títulos y texto principal del hero |
| `theme_secondary` | Subtítulos y tagline |
| `theme_accent` | Badges, bordes activos, dots del timeline |
| `theme_bg` | Fondo del hero y las cards |

### Dificultad

Valores válidos: `'Fácil'` · `'Intermedio'` · `'Difícil'` · `'Experto'`

### Tipos de cambio en changelog

| Tipo | Cuándo usarlo |
|---|---|
| `rule` | Cambio en una regla del reglamento |
| `stat` | Modificación de estadística de personaje |
| `character` | Personaje agregado, removido o renombrado |
| `mechanic` | Cambio en una mecánica del juego |
| `balance` | Ajuste de balance (sin cambio de regla) |
| `clarification` | Aclaración de una regla existente |

---

## Deploy

El sitio se publica automáticamente en GitHub Pages al pushear a `main` (vía GitHub Actions). El build es 100% estático — Supabase se consulta solo en build time.
