<template>
    <div class="w-full pt-4 flex flex-col pb-4">
        <div class="w-full flex flex-col gap-6 text-md justify-center">
            <div class="text-md text-gray-900 md:text-white w-full flex gap-8 justify-center">
                <div class="flex flex-col gap-1 items-center justify-center font-semibold">
                    <div class="text-lg">
                        Vencedor: 
                    </div>
                    <div class="text-3xl">
                        {{ stats.mostVoted.map(card => card == -1 ? '☕' : card).join(', ') }}
                    </div>
                </div>
                <div class="flex flex-col gap-1 items-center justify-center font-semibold">
                    <div class="text-lg">
                        Média: 
                    </div>
                    <div class="text-3xl">
                        {{ stats.average }}
                    </div>
                </div>
                <div class="flex flex-col gap-1 items-center justify-center font-semibold">
                    <div class="text-lg">
                        Assertividade: 
                    </div>
                    <div class="text-3xl">
                        {{ stats.assertiveness }}%
                    </div>
                </div>
            </div>
            <div class="flex justify-center gap-2">
                <div v-for="card in nonRepeatedCardsWithVotes" class="flex flex-col gap-1 items-center" :key="card.value">
                    <div
                        class="w-10 h-16 flex items-center text-gray-900 oswald-font font-bold rounded-md justify-center bg-green-100">
                        <span class="text-3xl flex justify-center"><span>{{ card.value == -1 ? '☕' : card.value
                                }}</span></span>
                    </div>
                    <div class="text-font-semibold md:text-white">{{ card.vote }} {{ card.vote === 1 ? 'voto' : 'votos' }}</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
const cards = ref([
    { value: -1, label: '☕', selectedClass: '-translate-y-6', defaultClass: 'border text-black' },
    { value: 0, label: '0', selectedClass: '-translate-y-6', defaultClass: 'bg-green-50 text-black' },
    { value: 1, label: '1', selectedClass: '-translate-y-6', defaultClass: 'bg-green-100 text-black' },
    { value: 2, label: '2', selectedClass: '-translate-y-6', defaultClass: 'bg-green-200 text-black' },
    { value: 3, label: '3', selectedClass: '-translate-y-6', defaultClass: ' bg-green-300 text-black' },
    { value: 5, label: '5', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-100 text-black' },
    { value: 8, label: '8', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-200 text-black' },
    { value: 13, label: '13', selectedClass: '-translate-y-6', defaultClass: 'bg-yellow-300 text-black' },
    { value: 21, label: '21', selectedClass: '-translate-y-6', defaultClass: 'bg-red-200 text-black' },
    { value: 34, label: '34', selectedClass: '-translate-y-6', defaultClass: 'bg-red-300 text-black' }
])
const userStore = useUserStore();

const notNullVotes = computed(() => userStore.players.filter(player => player.vote !== -1 || player.vote !== 0));

const nonRepeatedCardsWithVotes = computed(() => {
    const notNullVotes = userStore.players.filter(player => player.vote !== null);
    const votes = notNullVotes.map(player => player.vote);
    const voteCounts = votes.reduce((acc, curr) => {
        acc[curr] = (acc[curr] || 0) + 1;
        return acc;
    }, {});

    return cards.value.filter(card => voteCounts[card.value]).map(card => ({
        ...card,
        vote: voteCounts[card.value]
    }));
});

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

        const votesWithoutNull = votes.filter(vote => vote !== null);
        const totalVotes = votesWithoutNull.length;
        const sumOfVotes = votesWithoutNull.reduce((a, b) => a + b, 0);
        const average = totalVotes ? sumOfVotes / totalVotes : 0;

        const assertiveness = (mostVotedSorted[0][1] / votes.length) * 100;

        return {
            mostVoted,
            average,
            assertiveness,
        };
    }
    return null;
});
</script>