<template>
  <div class="h-[100vh] w-[100vw] flex flex-col">
    <LandingPage v-if="!userStore.jogoComecou" />
    <GameRoom v-else />
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
</style>

<script setup>
const $md = ref(null)
onMounted(() => {
  $md.value = window.matchMedia('(min-width: 768px)').matches
});

const userStore = useUserStore();
</script>
