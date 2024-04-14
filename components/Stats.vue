<template>
    <div class="w-full flex flex-col items-center text-white text-lg md:text-xl justify-center pb-10">
        <div>Rodada encerrada</div>
        <div class="font-bold mt-1">média: {{ stats.average }}</div>
        <div class="font-bold mt-1">carta mais votada: {{ stats.mostVoted }}</div>
        <div class="font-bold mt-1">assertividade: {{ stats.assertiveness }}%</div>

        <div class="flex flex-col gap-4 mt-4">
            <div class="flex gap-4">
                <div v-for="player in userStore.players" :key="player.id">
                    <div
                        class="w-8 h-14 text-black oswald-font font-bold flex-col  flex rounded-md justify-center  bg-green-100">
                        <span class="text-xl flex justify-center"><span>{{ player.vote }}</span></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();
const stats = computed(() => {
    if (userStore.players.length > 0) {
        const votes = userStore.players.map(player => player.vote);
        const voteCounts = votes.reduce((acc, curr) => {
            acc[curr] = (acc[curr] || 0) + 1;
            return acc;
        }, {});

        const mostVotedArray = Object.entries(voteCounts);
        const mostVotedSorted = mostVotedArray.sort((a, b) => b[1] - a[1]);

        const mostVoted = mostVotedSorted.filter(([card, count]) => count === mostVotedSorted[0][1]).map(([card]) => card);

        const totalVotes = votes.length;
        const sumOfVotes = votes.reduce((a, b) => a + b, 0);
        const average = sumOfVotes / totalVotes;

        const assertiveness = (mostVotedSorted[0][1] / totalVotes) * 100;

        return {
            mostVoted,
            average,
            assertiveness,
        };
    }
    return null;
});
</script>