<template>
  <div
    class="absolute top-full p-1 mt-2 w-[9.3rem] bg-white dark:bg-gray-800 rounded-lg shadow-lg z-10"
  >
    <div class="flex flex-wrap gap-2 p-1">
      <div
        v-for="color in colorsCaroussel"
        @click="changeColor(color)"
        :class="[`bg-${color}-400`, 'w-5 h-5 rounded-md cursor-pointer']"
      ></div>
    </div>
  </div>
</template>

<script setup>
import { tailwindColorShades, colorsCaroussel } from '~/utils/colors';
const props = defineProps({
    showColorPickerModal: Boolean,
});

onMounted(() => {
const savedColor = localStorage.getItem("themeColor");
  if (savedColor && tailwindColorShades[savedColor]) {
    changeColor(savedColor);
  }
});

const color = ref("blue");

const changeColor = (color) => {
  const colorHex = tailwindColorShades[color];
  if (colorHex) {
    Object.keys(colorHex).forEach((shade) => {
      document.documentElement.style.setProperty(
        `--color-primary-${shade}`,
        colorHex[shade]
      );
    });
    localStorage.setItem("themeColor", color);
  } else {
    console.error("Color not found:", color);
  }
};
</script>
