<template>
  <div class="w-full rubik-font h-[100vh]">
    <NuxtPage />
    <ToastGlobal />
  </div>
</template>

<style>
html {
  height: 100vh;
  background-color: #3f4146;
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
import ToastGlobal from './composables/toast';

const $md = ref(null)
onMounted(() => {
  $md.value = window.matchMedia('(min-width: 768px)').matches
});

const userStore = useUserStore();
</script>
