<template>
  <div class="w-full items-center flex flex-col pb-2 md:pb-12">
    <span class="mb-6 text-xl font-semibold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
      {{ $t("roundResults") }}
    </span>
    <div class="w-fit flex flex-col gap-6 text-md justify-center backdrop-blur-sm bg-white/10 border border-white/20 rounded-2xl p-6 px-8 shadow-2xl animate-fade-in">
      <div class="text-md w-full flex gap-8">
        <div class="flex flex-col gap-2 items-center justify-center font-normal">
          <div class="text-lg text-purple-200">{{ $t("mostVoted") }}</div>
          <div class="text-3xl font-bold text-white bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
            {{ stats.mostVoted.join(", ") }}
          </div>
        </div>
        <div class="flex flex-col gap-2 items-center justify-center font-normal">
          <div class="text-lg text-purple-200">{{ $t("consensus") }}</div>
          <div class="text-3xl font-bold text-white">{{ stats.assertiveness }}%</div>
        </div>
      </div>
      
      <div class="flex justify-center gap-4 pt-2">
        <div
          v-for="(card, index) in nonRepeatedCardsWithVotes"
          class="group flex flex-col gap-3 items-center animate-fade-in-card"
          :key="card.value"
          :style="{ animationDelay: `${index * 0.1}s` }"
        >
          <div class="relative">
            <div class="w-12 h-16 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center font-bold justify-center shadow-lg transform transition-all duration-300 group-hover:scale-105 group-hover:shadow-purple-500/25">
              <span class="text-xl flex justify-center text-white">
                {{ card.value }}
              </span>
            </div>
            <!-- Vote count badge -->
            <div class="absolute -top-2 -right-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center shadow-lg">
              {{ card.vote }}
            </div>
          </div>
          <div class="text-sm font-medium text-gray-300 text-center">
            {{ card.vote }} {{ card.vote === 1 ? $t("vote") : $t("votes") }}
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

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fade-in-card {
  from {
    opacity: 0;
    transform: translateY(10px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.animate-fade-in {
  animation: fade-in 0.8s ease-out;
}

.animate-fade-in-card {
  animation: fade-in-card 0.6s ease-out both;
}

.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}
</style>
