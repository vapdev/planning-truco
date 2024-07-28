<template>
  <div class="flex flex-col gap-4 pt-7" style="min-width: 40px">
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
import { useUserStore } from "@/stores/user";

const props = defineProps({
  players: Array,
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
onMounted(updateLocations);
</script>
