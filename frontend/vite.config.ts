import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
  server: {
    proxy: {
      "/badge": "http://localhost:34567",
      "/admin/": "http://localhost:34567",
    },
  },
});
