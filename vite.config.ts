import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  base: '/svs/',
  plugins: [react()],
  server: {
    proxy: {
      '/api': 'http://localhost:5174',
    },
  },
})
