<template>
    <div class="h-22 mt-2 flex w-80 justify-around">
        <div v-for="(player, index) in players" :key="player.id">
            <PlayerVote :player="player" :mostrarCartas="userStore.roomState.showCards" />
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    players: Array
})
const userStore = useUserStore();
</script>