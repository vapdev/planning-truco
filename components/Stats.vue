<template>
  <div class="w-full items-center flex flex-col pb-2 md:pb-12">
    <span class="mb-1 font-semibold">Resultados da rodada</span>
    <div
      class="w-fit flex flex-col gap-1 text-md justify-center bg-gray-200 dark:bg-gray-500 rounded-xl p-2 px-4"
    >
      <div class="text-md w-full flex gap-6">
        <div class="flex flex-col gap-1 items-center justify-center font-normal">
          <div class="text-lg">Mais votos:</div>
          <div class="text-2xl font-bold">
            {{ stats.mostVoted.join(", ") }}
          </div>
        </div>
        <!-- Média removida -->
        <div class="flex flex-col gap-1 items-center justify-center font-normal">
          <div class="text-lg">Consenso:</div>
          <div class="text-2xl font-bold">{{ stats.assertiveness }}%</div>
        </div>
      </div>
      <div class="flex justify-center gap-3 pt-2">
        <div
          v-for="card in nonRepeatedCardsWithVotes"
          class="flex flex-col gap-1 items-center"
          :key="card.value"
        >
          <div
            :class="[
              'w-8 h-12 flex items-center font-bold rounded-md justify-center',
              card.selectedClass || 'bg-primary-500',
            ]"
          >
            <span class="text-2xl flex justify-center text-white">
              {{ card.value === -1 ? "☕" : card.value }}
            </span>
          </div>
          <div class="text-font-semibold">
            {{ card.vote }} {{ card.vote === 1 ? "voto" : "votos" }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  cards: {
    type: Array,
    required: true,
    default: () => [],
  },
});
const userStore = useUserStore();

const nonRepeatedCardsWithVotes = computed(() => {
  const notNullVotes = userStore.players.filter((player) => player.vote !== null);
  const votes = notNullVotes.map((player) => String(player.vote)); // Ensure votes are strings
  const voteCounts = votes.reduce((acc, curr) => {
    acc[curr] = (acc[curr] || 0) + 1;
    return acc;
  }, {});

  return props.cards
    .filter((card) => voteCounts[String(card.value)])
    .map((card) => ({
      ...card,
      vote: voteCounts[String(card.value)],
    }));
});

const stats = computed(() => {
  if (userStore.players.length > 0) {
    const votes = userStore.players.map((player) => String(player.vote));

    const votesWithoutNull = votes.filter((vote) => vote !== "null" && vote !== "NaN");

    const voteCounts = votesWithoutNull.reduce((acc, curr) => {
      acc[curr] = (acc[curr] || 0) + 1;
      return acc;
    }, {});

    const mostVotedArray = Object.entries(voteCounts);
    const mostVotedSorted = mostVotedArray.sort((a, b) => b[1] - a[1]);

    const maxVotes = mostVotedSorted[0][1];
    const mostVoted = mostVotedSorted
      .filter(([card, count]) => count === maxVotes)
      .map(([card]) => {
        const cardObj = props.cards.find((c) => String(c.value) === card);
        return cardObj ? cardObj.label : card;
      });

    let average = null;
    if (props.cards.every((card) => Number.isInteger(Number(card.value)))) {
      const totalVotes = votesWithoutNull.length;
      const sumOfVotes = votesWithoutNull
        .map((vote) => Number(vote))
        .reduce((a, b) => a + b, 0);
      const rawAverage = totalVotes ? sumOfVotes / totalVotes : 0;

      average = Number.isInteger(rawAverage)
        ? Math.floor(rawAverage)
        : rawAverage.toFixed(1);
    }

    const assertiveness = Math.floor((mostVotedSorted[0][1] / votes.length) * 100);

    return {
      mostVoted,
      average,
      assertiveness,
    };
  }
  return {
    mostVoted: [],
    average: null,
    assertiveness: 0,
  };
});
</script>
