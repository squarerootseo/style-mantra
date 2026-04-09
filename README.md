# Style Mantra — Astro Static Site

Migrated from WordPress/Elementor to **Astro v5** for blazing-fast performance and zero server dependencies.

## Pages

| Route | Source |
|---|---|
| `/` | Home page |
| `/about/` | About page |
| `/our-course/` | Course details |
| `/contact/` | Contact form |

## Quick Start

```bash
# Install dependencies
npm install

# Development server
npm run dev
# → http://localhost:4321

# Production build
npm run build

# Preview production build
npm run preview
```

## Project Structure

```
├── public/           # Static assets (favicon, robots.txt)
│   └── assets/       # Images
├── src/
│   └── pages/        # Astro pages (1 per route)
│       ├── index.astro
│       ├── about.astro
│       ├── our-course.astro
│       └── contact.astro
├── astro.config.mjs  # Astro configuration
├── package.json
└── tsconfig.json
```

## Tech Stack

- **Framework:** Astro v5 (static output)
- **Fonts:** Jost (Google Fonts) + Clash Display (Fontshare)
- **Build:** Vite 7 with esbuild minification
- **Deployment:** Any static host (Netlify, Vercel, Cloudflare Pages)

## Migration Notes

This site was migrated using the SRS Migration Doctrine — a 100% visual parity pipeline that preserves the exact DOM structure and styling from WordPress while eliminating PHP, database queries, and server-side processing.
