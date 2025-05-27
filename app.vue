<template>
  <div class="atkinson-hyperlegible-mono-regular w-full h-[100dvh]">
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
.atkinson-hyperlegible-mono-regular {
  font-family: "Atkinson Hyperlegible Mono", serif;
  font-optical-sizing: auto;
  font-weight: 400;
  font-style: normal;
}
</style>

<script setup>
useSeoMeta({
  title: 'Free Planning Poker',
  ogTitle: 'Free Planning Poker',
  description: 'Free Planning Poker for your team',
  ogDescription: 'Free Planning Poker for your team'
})
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
