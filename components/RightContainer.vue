<template>
    <div class="flex flex-col gap-4" style="min-width: 40px;">
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