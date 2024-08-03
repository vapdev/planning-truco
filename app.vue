<template>
  <div class="w-full h-[100dvh]">
    <NuxtPage />
    <ToastGlobal />
  </div>
</template>

<style>
html {
  height: 100dvh;
  /* background-color: #3f4146; */
  background-color: #FFFFFF;
}

.oswald-font {
  font-family: "Oswald", sans-serif;
  font-optical-sizing: auto;
  font-weight: 200;
  font-style: normal;
}
.rubik-font {
  font-family: "Rubik", sans-serif;
  font-optical-sizing: auto;
  font-weight: 200;
  font-style: normal;
}
</style>

<script setup>
const DEFAULT_COLOR = "indigo";

import ToastGlobal from './composables/toast';
const userStore = useUserStore();
import { tailwindColorShades } from "~/utils/colors";
const $md = ref(null)
onMounted(() => {
  $md.value = window.matchMedia('(min-width: 768px)').matches
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
  const savedColor = localStorage.getItem("themeColor");
  if (savedColor && tailwindColorShades[savedColor]) {
    changeColor(savedColor);
  } else {
    changeColor(DEFAULT_COLOR);
  }
  const darkMode = localStorage.getItem("nuxt-color-mode");
  if (darkMode === "dark") {
    document.body.classList.add("dark");
  }
});

const changeColor = (color) => {
  const colorHex = tailwindColorShades[color];
  if (colorHex) {
    Object.keys(colorHex).forEach((shade) => {
      document.documentElement.style.setProperty(
        `--color-primary-${shade}`,
        colorHex[shade]
      );
    });
  } else {
    console.error("Color not found:", color);
  }
};

</script>
