# Board Stuff

Sitio informativo de juegos de mesa: reglas, personajes, mecánicas e historial de cambios.

**Stack:** Astro · React · Tailwind CSS · Motion · MDX

---

## Estructura del proyecto

```
src/
├── content/
│   ├── config.ts          ← Schema tipado con Zod
│   └── games/
│       ├── catan.mdx      ← Ejemplo con reglas + changelog
│       └── bang.mdx       ← Ejemplo con personajes + habilidades
├── layouts/
│   ├── BaseLayout.astro   ← Nav + footer
│   └── GameLayout.astro   ← Hero + tabs (Reglas / Personajes / Historial)
├── pages/
│   ├── index.astro        ← Home con grilla de juegos
│   └── games/[slug].astro ← Página dinámica por juego
├── components/
│   ├── GameCard.tsx       ← Card animada con Motion
│   ├── CharacterCard.tsx  ← Accordion animado con expand/collapse
│   └── ChangeHistory.tsx  ← Timeline de cambios
└── styles/global.css
public/
└── images/games/          ← Imágenes en formato .webp
```

---

## Comandos

```bash
npm run dev      # Servidor de desarrollo
npm run build    # Build de producción
npm run preview  # Preview del build
```

---

## Agregar un juego

Creá un archivo `.mdx` en `src/content/games/` con el siguiente frontmatter:

```yaml
---
title: "Nombre del juego"
tagline: "Frase corta"
description: "Descripción larga"
coverImage: "/images/games/nombre-cover.webp"
players: "2–4"
duration: "30–60 min"
difficulty: "Fácil" # Fácil | Intermedio | Difícil | Experto
theme:
  primary: "#color"
  secondary: "#color"
  accent: "#color"
  bg: "#color"
publishedAt: "YYYY-MM-DD"
author: "Nombre"
characters:
  - name: "Personaje"
    role: "Rol"
    description: "Descripción"
    image: "/images/games/personaje.webp"  # opcional
    stats:
      vida: 4
      alcance: 1
    abilities:
      - name: "Habilidad"
        description: "Qué hace"
        passive: true
changelog:
  - date: "YYYY-MM-DD"
    version: "1.0"
    author: "Nombre"
    summary: "Resumen del cambio"
    changes:
      - type: "rule"  # rule | stat | character | mechanic | balance | clarification
        description: "Descripción del cambio"
---
```

El contenido MDX debajo del frontmatter son las reglas del juego (soporta tablas, blockquotes, headings, etc.).

Las imágenes van en `public/images/games/` en formato `.webp`.
