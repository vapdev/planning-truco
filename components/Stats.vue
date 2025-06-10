<template>
  <!-- Elegant Stats Overlay Modal -->
  <div class="fixed inset-0 z-50 flex items-center justify-center p-4 animate-overlay-appear">
    <!-- Background overlay -->
    <div 
      class="absolute inset-0 bg-black/60 backdrop-blur-sm" 
      @click="$emit('close')"
    ></div>
    
    <!-- Stats Modal -->
    <div class="relative bg-gradient-to-br from-slate-800/95 to-slate-900/95 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl shadow-purple-500/20 p-6 max-w-lg w-full animate-modal-slide-up">
      <!-- Close button -->
      <button 
        @click="$emit('close')"
        class="absolute top-4 right-4 p-2 rounded-full bg-white/10 hover:bg-white/20 transition-all duration-300 group"
      >
        <svg class="w-5 h-5 text-white/70 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>

      <!-- Header -->
      <div class="text-center mb-6">
        <h3 class="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-2">
          {{ $t("roundResults") }}
        </h3>
        <div class="w-16 h-1 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full mx-auto"></div>
      </div>

      <!-- Main Stats Grid -->
      <div class="grid grid-cols-2 gap-4 mb-6">
        <!-- Most Voted -->
        <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-xl p-4 text-center">
          <div class="text-sm text-purple-200 mb-2">{{ $t("mostVoted") }}</div>
          <div class="text-2xl font-bold text-white">
            {{ stats.mostVoted.join(", ") }}
          </div>
        </div>

        <!-- Consensus -->
        <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-xl p-4 text-center">
          <div class="text-sm text-purple-200 mb-2">{{ $t("consensus") }}</div>
          <div class="text-2xl font-bold text-white">{{ stats.assertiveness }}%</div>
        </div>

        <!-- Average (if numeric) -->
        <div v-if="stats.average !== null" class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-xl p-4 text-center col-span-2">
          <div class="text-sm text-purple-200 mb-2">{{ $t("average") }}</div>
          <div class="text-2xl font-bold text-white">{{ stats.average }}</div>
        </div>
      </div>

      <!-- Vote Distribution -->
      <div class="mb-6">
        <h4 class="text-lg font-semibold text-white mb-4 text-center">{{ $t("voteDistribution") }}</h4>
        <div class="flex justify-center gap-3 flex-wrap">
          <div
            v-for="(card, index) in nonRepeatedCardsWithVotes"
            class="group flex flex-col items-center animate-fade-in-card"
            :key="card.value"
            :style="{ animationDelay: `${index * 0.1}s` }"
          >
            <div class="relative">
              <div class="w-12 h-16 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center font-bold justify-center shadow-lg transform transition-all duration-300 group-hover:scale-105">
                <span class="text-lg text-white">
                  {{ card.label }}
                </span>
              </div>
              <!-- Vote count badge -->
              <div class="absolute -top-2 -right-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center shadow-lg">
                {{ card.vote }}
              </div>
            </div>
            <div class="text-xs font-medium text-gray-300 text-center mt-2">
              {{ card.vote }} {{ $t("votes") }}
            </div>
          </div>
        </div>
      </div>

      <!-- Action Button -->
      <div class="text-center">
        <button 
          @click="$emit('newRound')"
          class="group relative inline-flex items-center justify-center px-8 py-3 text-lg font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900"
        >
          <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-emerald-600 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
          <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-emerald-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
          <span class="relative z-10 flex items-center font-bold">
            {{ $t("startNewVoting") }}
            <svg class="w-5 h-5 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
            </svg>
          </span>
        </button>
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
