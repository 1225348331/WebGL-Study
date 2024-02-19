import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { resolve } from "path";
import glsl from "vite-plugin-glsl";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), glsl()],
  resolve: {
    alias: {
      "@": resolve(__dirname, "src"), // 路径别名
    },
  },
});
