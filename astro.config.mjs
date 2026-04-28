import { defineConfig } from 'astro/config';

import cloudflare from "@astrojs/cloudflare";

export default defineConfig({
  site: 'https://stylemantra.co.in',
  output: 'static',

  build: {
    assets: '_assets',
    inlineStylesheets: 'auto',
  },

  vite: {
    build: {
      cssMinify: true,
      minify: 'esbuild',
    },
    server: {
      hmr: {
        overlay: false,
      },
    },
  },

  adapter: cloudflare()
});