<template>
  <PlayerContainer
    :players="players"
    containerClass="h-22 mt-2 md:mt-12 flex w-80 justify-around"
  />
</template>

<script setup>
import PlayerContainer from "./PlayerContainer.vue";

const props = defineProps({
  players: Array,
});
</script>
