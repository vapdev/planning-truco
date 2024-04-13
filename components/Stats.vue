<template>
    <div class="w-full flex flex-col items-center text-white text-xl justify-center pb-10">
        <div>Rodada encerrada</div>
        <div class="text-xl font-bold mt-1">média: {{ winnerComputed }}</div>
        <div class="text-xl font-bold mt-1">carta mais votada: {{ winnerComputed }}</div>
        <div class="text-xl font-bold mt-1">assertividade: {{ winnerComputed }}%</div>

        <div class="flex flex-col gap-4 mt-4">
            <div class="flex gap-4">
                <div v-for="player in userStore.players" :key="player.id">
                    <div
                        class="w-8 h-14 text-black oswald-font font-bold flex-col relative flex rounded-md justify-center  bg-green-100">
                        <span class="text-xl flex justify-center"><span>{{ player.vote }}</span></span>
                    </div>
                </div>
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