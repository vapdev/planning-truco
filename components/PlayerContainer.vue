<template>
  <div :class="containerClass">
    <div
      v-for="(player, index) in players"
      :key="player.id"
      :ref="(el) => (playerRefs[index] = el)"
    >
      <PlayerVote :player="player" :mostrarCartas="userStore.roomState.showCards" />
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from "vue";
import { useUserStore } from "~/stores/user";

const props = defineProps({
  players: Array,
  containerClass: String,
});

const userStore = useUserStore();
const playerRefs = ref([]);

const updateLocations = async () => {
  await new Promise((resolve) => setTimeout(resolve, 200));

  playerRefs.value.forEach((el, index) => {
    if (el) {
      const rect = el.getBoundingClientRect();
      userStore.updatePlayerLocation(props.players[index].id, {
        top: rect.top + window.scrollY,
        left: rect.left + window.scrollX,
      });
    }
  });
};

watch(playerRefs, updateLocations);
watch(() => userStore.players, () => {
  updateLocations();
}, { deep: true });

onMounted(() => {
  updateLocations();

  window.addEventListener("resize", updateLocations);

  const handleZoom = () => {
    updateLocations();
  };
  window.addEventListener("zoom", handleZoom);

  onBeforeUnmount(() => {
    window.removeEventListener("resize", updateLocations);
    window.removeEventListener("zoom", handleZoom);
  });
});
</script>
