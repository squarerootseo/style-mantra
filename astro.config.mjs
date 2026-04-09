import { defineConfig } from 'astro/config';

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
  },
});
