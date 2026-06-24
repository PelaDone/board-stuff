import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwind from '@astrojs/tailwind';
import compress from '@playform/compress';

export default defineConfig({
  site: 'https://PelaDone.github.io',
  base: '/board-stuff',
  integrations: [
    react(),
    tailwind({ applyBaseStyles: false }),
    compress(),
  ],
});
