<template>
  <div class="flex flex-col justify-end w-full pb-2 sm:pb-4 overflow-hidden">
    <!-- Voting instruction or results buttons -->
    <div v-if="!showCards" class="flex justify-center font-semibold text-white/90 mb-2 sm:mb-4 text-base sm:text-lg">
      {{ $t("voteBelow") }}
    </div>
    
    <!-- Action buttons when cards are revealed -->
    <div v-if="showCards" class="flex justify-center gap-3 mb-4">
      <button 
        @click="$emit('showStats')"
        class="group relative inline-flex items-center justify-center px-4 sm:px-6 py-2 sm:py-3 text-sm sm:text-base font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 focus:outline-none"
      >
        <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
        <span class="relative z-10 flex items-center font-bold">
          <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
          </svg>
          {{ $t("stats") }}
        </span>
      </button>
      
      <button 
        @click="$emit('newRound')"
        class="group relative inline-flex items-center justify-center px-4 sm:px-6 py-2 sm:py-3 text-sm sm:text-base font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 focus:outline-none"
      >
        <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-emerald-500 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-emerald-500 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
        <span class="relative z-10 flex items-center font-bold">
          {{ $t("startNewVoting") }}
          <svg class="w-4 h-4 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
          </svg>
        </span>
      </button>
    </div>
    
    <!-- Deck cards (only show when not revealing cards) -->
    <div
      v-if="!showCards"
      class="flex justify-center overflow-y-hidden md:justify-center text-blue-400 overflow-x-auto gap-2 sm:gap-4 items-center pb-2 sm:pb-4 pt-4 sm:pt-8 w-full"
    >
      <div class="flex gap-3 sm:gap-6">
        <div
          v-for="(card, index) in deck"
          :key="index"
          @click="props.votar(card.value)"
          :class="getCardClasses(card)"
          :style="{ animationDelay: `${index * 100}ms` }"
          class="text-lg sm:text-2xl w-12 h-16 sm:w-16 sm:h-24 deck-card flex items-center rounded-lg sm:rounded-xl justify-center cursor-pointer transition-all duration-300 ease-out card-hover animate-fade-in-up backdrop-blur-sm border border-white/20 shadow-lg"
        >
          <div class="flex justify-center w-16 sm:w-24 text-white font-bold text-sm sm:text-base">{{ card.label }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useUserStore } from "~/stores/user";

const props = defineProps({
  selectedCard: Number,
  votar: {
    type: Function,
    required: true
  },
  deck: Array,
  showCards: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['showStats', 'newRound']);

const userStore = useUserStore();
const getCardClasses = (card) => {
  const isSelected = props.selectedCard === card.value;
  return [
    isSelected
      ? "bg-gradient-to-br from-blue-600 to-indigo-600 -translate-y-6 scale-110 shadow-2xl shadow-blue-500/50"
      : "bg-gradient-to-br from-slate-700/80 to-slate-800/80 hover:-translate-y-3 hover:bg-gradient-to-br hover:from-blue-500/80 hover:to-indigo-500/80 hover:shadow-xl hover:shadow-blue-500/30",
    "text-white",
  ];
};

const cardStyle = computed(() => {
});
</script>

<style scoped>
@keyframes fade-in-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fade-in-up 0.4s ease-out both;
}

.card-hover {
  position: relative;
  overflow: hidden;
}

.card-hover::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s;
}

.card-hover:hover::before {
  left: 100%;
}

.card-hover:hover {
  transform: translateY(-12px) scale(1.05);
  box-shadow: 0 10px 25px rgba(168, 85, 247, 0.3);
}

.card-hover:active {
  transform: translateY(-8px) scale(1.02);
}
</style>
