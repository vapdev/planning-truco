<template>
    <div class="w-full items-center flex flex-col pb-2 md:pb-12"> 
        <span class="mb-1 font-semibold">Resultados da rodada</span>
        <div class="w-fit flex flex-col gap-1 text-md justify-center bg-gray-200 dark:bg-gray-500 rounded-xl p-2 px-4">
            <div class="text-md w-full flex gap-6">
                <div class="flex flex-col gap-1 items-center justify-center font-normal">
                    <div class="text-lg">
                        Mais votos:
                    </div>
                    <div class="text-2xl font-bold">
                        {{ stats.mostVoted.map(card => card == -1 ? '☕' : card).join(', ') }}
                    </div>
                </div>
                <div class="flex flex-col gap-1 items-center justify-center font-normal">
                    <div class="text-lg">
                        Média:
                    </div>
                    <div class="text-2xl font-bold">
                        {{ stats.average }}
                    </div>
                </div>
                <div class="flex flex-col gap-1 items-center justify-center font-normal">
                    <div class="text-lg">
                        Assertividade:
                    </div>
                    <div class="text-2xl font-bold">
                        {{ stats.assertiveness }}%
                    </div>
                </div>
            </div>
            <div class="flex justify-center gap-3 pt-2">
                <div v-for="card in nonRepeatedCardsWithVotes" class="flex flex-col gap-1 items-center"
                    :key="card.value">
                    <div
                        class="w-10 h-16 flex items-center border-2 border-blue-500 text-blue-500 dark:border-0 dark:bg-blue-500 oswald-font font-bold rounded-md justify-center">
                        <span class="text-3xl flex justify-center dark:text-white"><span>{{ card.value == -1 ? '☕' : card.value
                                }}</span></span>
                    </div>
                    <div class="text-font-semibold">{{ card.vote }} {{ card.vote === 1 ? 'voto' : 'votos' }}
                    </div>
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

        const mostVoted = mostVotedSorted
            .filter(([card, count]) => count === mostVotedSorted[0][1])
            .map(([card]) => card)
            .filter(card => card !== "null");

        if (mostVoted.length === 0) {
            if (mostVotedArray.length > 1) {
                mostVoted.push(mostVotedArray[1][0]);
            } else {
                mostVoted.push("N/A");
            }
        }


        const votesWithoutNullAndNegativeOne = votes.filter(vote => vote !== null && vote !== -1);
        const totalVotes = votesWithoutNullAndNegativeOne.length;
        const sumOfVotes = votesWithoutNullAndNegativeOne.reduce((a, b) => a + b, 0);
        const rawAverage = totalVotes ? sumOfVotes / totalVotes : 0;
        const average = Number.isInteger(rawAverage) ? Math.floor(rawAverage) : rawAverage.toFixed(1);

        const assertiveness = Math.floor((mostVotedSorted[0][1] / votes.length) * 100);

        return {
            mostVoted,
            average,
            assertiveness,
        };
    }
    return null;
});
</script>