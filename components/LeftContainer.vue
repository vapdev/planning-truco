<template>
  <PlayerContainer
    :players="players"
    containerClass="flex flex-col gap-4 pt-7 md:mr-10"
    style="min-width: 40px"
  />
</template>

<script setup>
import PlayerContainer from "./PlayerContainer.vue";

const props = defineProps({
  players: Array,
});
</script>
