<template>
  <!-- Stats Modal Overlay -->
  <div v-if="isOpen" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in" @click.self="$emit('close')">
    <div class="w-full max-w-2xl">
      <!-- Header with close button -->
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          {{ $t("roundResults") }}
        </h2>
        <button 
          @click="$emit('close')"
          class="p-2 rounded-full hover:bg-white/10 transition-all duration-300 group"
        >
          <svg class="w-6 h-6 text-white/70 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Stats Content -->
      <div class="backdrop-blur-sm bg-white/10 border border-white/20 rounded-2xl p-6 shadow-2xl animate-slide-up">
        <!-- Main Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <div class="text-center">
            <div class="text-sm text-purple-200 mb-2">{{ $t("mostVoted") }}</div>
            <div class="text-2xl font-bold text-white bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              {{ stats.mostVoted.join(", ") }}
            </div>
          </div>
          <div class="text-center">
            <div class="text-sm text-purple-200 mb-2">{{ $t("consensus") }}</div>
            <div class="text-2xl font-bold text-white">{{ stats.assertiveness }}%</div>
          </div>
          <div v-if="stats.average !== null" class="text-center">
            <div class="text-sm text-purple-200 mb-2">{{ $t("average") }}</div>
            <div class="text-2xl font-bold text-white">{{ stats.average }}</div>
          </div>
        </div>
        
        <!-- Voting Cards -->
        <div class="flex justify-center gap-3 flex-wrap mb-6">
          <div
            v-for="(card, index) in nonRepeatedCardsWithVotes"
            class="group flex flex-col gap-2 items-center animate-fade-in-card"
            :key="card.value"
            :style="{ animationDelay: `${index * 0.1}s` }"
          >
            <div class="relative">
              <div class="w-10 h-14 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center font-bold justify-center shadow-lg transform transition-all duration-300 group-hover:scale-105 group-hover:shadow-purple-500/25">
                <span class="text-lg text-white">
                  {{ card.value }}
                </span>
              </div>
              <div class="absolute -top-1 -right-1 bg-gradient-to-r from-indigo-500 to-purple-600 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center shadow-lg">
                {{ card.vote }}
              </div>
            </div>
            <div class="text-xs font-medium text-gray-300 text-center">
              {{ card.vote }} {{ card.vote === 1 ? $t("vote") : $t("votes") }}
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex gap-3 justify-center">
          <button 
            @click="$emit('newRound')"
            class="px-6 py-3 bg-gradient-to-r from-blue-500 to-emerald-500 hover:from-blue-400 hover:to-emerald-400 text-white font-semibold rounded-xl transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30"
          >
            {{ $t("startNewVoting") }}
          </button>
          <button 
            @click="$emit('close')"
            class="px-6 py-3 bg-white/10 hover:bg-white/20 text-white font-semibold rounded-xl transition-all duration-300 border border-white/20"
          >
            {{ $t("close") }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  cards: {
    type: Array,
    required: true,
    default: () => [],
  },
});

const emit = defineEmits(['close', 'newRound']);

const userStore = useUserStore();

const nonRepeatedCardsWithVotes = computed(() => {
  const notNullVotes = userStore.players.filter((player) => player.vote !== null);
  const votes = notNullVotes.map((player) => String(player.vote));
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

    const maxVotes = mostVotedSorted[0]?.[1] ?? 0;
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

    const assertiveness = Math.floor((mostVotedSorted[0]?.[1] ?? 0) / votes.length * 100);

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
  }
  to {
    opacity: 1;
  }
}

@keyframes slide-up {
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
  animation: fade-in 0.3s ease-out;
}

.animate-slide-up {
  animation: slide-up 0.4s ease-out;
}

.animate-fade-in-card {
  animation: fade-in-card 0.6s ease-out both;
}
</style>
