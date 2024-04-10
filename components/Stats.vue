<template>
    <div class="flex flex-col gap-2 pb-4 md:pb-0">
        <div class="text-white text-xl md:text-2xl">Votação encerrada</div>
        <div class="flex items-center gap-4 text-white text-xl md:text-2xl">
            <div class="text-green-300">Carta mais votada: </div>
            <div
                class="mt-4 w-10 h-14 text-black font-bold flex-col relative flex rounded-lg justify-center border-4 border-green-500 bg-green-100">
                <span class="text-xl flex justify-center"><span>{{ winnerComputed }}</span></span>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();
const winnerComputed = computed(() => {
    if (userStore.players.length > 0) {
        const votes = userStore.players.map(player => player.vote);
        const mostVoted = votes.reduce((acc, curr) => {
            acc[curr] = (acc[curr] || 0) + 1;
            return acc;
        }, {});
        const mostVotedArray = Object.entries(mostVoted);
        const mostVotedSorted = mostVotedArray.sort((a, b) => b[1] - a[1]);
        return mostVotedSorted[0][0];
    }
    return null;
});
</script>