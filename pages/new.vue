<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white relative overflow-hidden">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <header class="relative z-10 backdrop-blur-sm bg-white/5 border-b border-white/10 py-6">
      <div class="container mx-auto flex justify-between items-center px-6">
        <a href="/" class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent hover:from-purple-300 hover:to-pink-300 transition-all duration-300">
          Free Planning Poker<span class="text-purple-400">.</span>
        </a>
        <LanguageSelector />
      </div>
    </header>

    <div class="relative z-10 flex-grow flex items-center justify-center py-20 px-6">
      <div class="backdrop-blur-sm bg-white/10 border border-white/20 p-8 pt-6 rounded-2xl shadow-2xl w-full max-w-lg animate-fade-in">
        <form class="space-y-6">
          <div class="text-center mb-8">
            <h2 class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              {{ $t("createRoom") }}
            </h2>
            <p class="text-gray-300 mt-2">Configure sua sala de Planning Poker</p>
          </div>
          
          <div class="space-y-6">
            <div class="space-y-2">
              <label class="text-lg font-semibold text-purple-200">{{ $t("roomName") }}</label>
              <UInput
                v-model="roomName"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-purple-400 focus:ring-purple-400"
                :placeholder="$t('roomName')"
              />
            </div>
            
            <div class="space-y-2">
              <label class="text-lg font-semibold text-purple-200">{{ $t("deck") }}</label>
              <USelectMenu
                v-model="baralho"
                :options="deckOptions"
                size="lg"
                color="gray"
                class="w-full font-light"
                :ui="{
                  trigger: 'bg-white/5 border-white/20 text-white focus:border-purple-400 focus:ring-purple-400',
                  option: { base: 'cursor-pointer select-none relative py-2 pl-3 pr-9 text-gray-900' }
                }"
              ></USelectMenu>
            </div>
            
            <div v-if="baralho.value === 'custom'" class="space-y-2">
              <label class="text-lg font-semibold text-purple-200">{{ $t("customDeck") }}</label>
              <UInput
                v-model="customDeckInput"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-purple-400 focus:ring-purple-400"
                placeholder="Ex: 1, 2, 3, 5, 8"
              />
            </div>
            
            <div class="space-y-3">
              <label class="text-lg font-semibold text-purple-200">{{ $t("preview") }}</label>
              <div class="flex gap-2 flex-wrap">
                <div v-for="card in selectedDeck.slice(0, 8)" :key="card.value" 
                     class="group relative">
                  <div class="w-12 h-16 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center justify-center cursor-pointer shadow-lg transform transition-all duration-300 hover:scale-105 hover:shadow-purple-500/25">
                    <span class="text-white font-bold text-sm">{{ card.label }}</span>
                  </div>
                </div>
                <div v-if="selectedDeck.length > 8" class="w-12 h-16 bg-gradient-to-br from-gray-500 to-gray-600 rounded-lg flex items-center justify-center cursor-pointer shadow-lg">
                  <span class="text-white font-bold text-xs">+{{ selectedDeck.length - 8 }}</span>
                </div>
              </div>
            </div>
            
            <div class="pt-4">
              <button
                type="button"
                @click="mostrarOpcoesAvancadas = !mostrarOpcoesAvancadas"
                class="group flex items-center gap-2 px-4 py-2 bg-white/5 border border-white/20 rounded-xl hover:bg-white/10 transition-all duration-300 text-purple-200 hover:text-white"
              >
                <svg class="w-4 h-4 transform transition-transform duration-300" :class="{ 'rotate-180': mostrarOpcoesAvancadas }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
                {{ mostrarOpcoesAvancadas ? $t("hideAdvancedSettings") : $t("showAdvancedSettings") }}
              </button>
              
              <div v-show="mostrarOpcoesAvancadas" class="mt-4 space-y-4 p-4 bg-white/5 rounded-xl border border-white/10">
                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <div class="font-semibold text-purple-200">{{ $t("revealCardsTitle") }}</div>
                    <div class="text-sm text-gray-400 mt-1">
                      {{ $t("revealCardsDescription") }}
                    </div>
                  </div>
                  <UToggle
                    @click="toggleVirarAutomatico"
                    v-model="virarAutomatico"
                    color="purple"
                    class="ml-4"
                  />
                </div>
              </div>
            </div>
          </div>
          
          <div class="pt-4">
            <button
              type="button"
              @click="userStore.startGame(gameOptions)"
              class="group relative w-full inline-flex items-center justify-center px-8 py-4 text-xl font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl shadow-lg group-hover:shadow-purple-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
              <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
              <span class="relative z-10 flex items-center font-bold">
                {{ $t("createRoom") }}
                <svg class="w-6 h-6 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                </svg>
              </span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import * as decks from "~/utils/decks";
const virarAutomatico = ref(false);
const roomName = ref("");
const baralho = ref({
  value: 'fibonacci',
  label: 'Fibonacci',
});
const customDeckInput = ref("");
const mostrarOpcoesAvancadas = ref(false);
const todosPodemVotar = ref(false);
const emojis = ref(false);
const userStore = useUserStore();

const selectedDeck = ref(decks.fibonacci);

const gameOptions = computed(() => ({
  roomName: roomName.value,
  deck: selectedDeck.value,
  autoShowCards: virarAutomatico.value,
  // todosPodemVotar: todosPodemVotar.value,
  // emojis: emojis.value,
}));

const deckOptions = [
  ...Object.keys(decks).filter(key => key !== 'deckLabels').map(key => ({
    value: key,
    label: decks.deckLabels[key] || key,
  })),
  { value: 'custom', label: 'Deck personalizado' }
];

// Watcher para atualizar o baralho selecionado
watch(baralho, (newValue) => {
  if (newValue === 'custom') {
    selectedDeck.value = customDeckInput.value
      .split(',')
      .map((label, index) => ({ value: index, label: label.trim() }));
  } else {
    selectedDeck.value = decks[newValue.value] || decks.fibonacci;
  }
});

// Watcher para atualizar o deck personalizado
watch(customDeckInput, (newValue) => {
  if (baralho.value.value === 'custom') {
    selectedDeck.value = newValue
      .split(',')
      .map((label) => ({ value: label.trim(), label: label.trim() }));
  }
});

// Funções de toggle
const toggleVirarAutomatico = () => {
  virarAutomatico.value = !virarAutomatico.value;
};

const toggleTodosPodemVotar = () => {
  todosPodemVotar.value = !todosPodemVotar.value;
};

const toggleEmojis = () => {
  emojis.value = !emojis.value;
};
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

.animate-fade-in {
  animation: fade-in 1s ease-out;
}

/* Enhanced glassmorphism effects */
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}

/* Custom gradient animations for background orbs */
@keyframes float {
  0%, 100% {
    transform: translateY(0px) scale(1);
  }
  50% {
    transform: translateY(-20px) scale(1.05);
  }
}

.animate-pulse {
  animation: float 6s ease-in-out infinite;
}

/* Custom focus styles */
button:focus {
  outline: none;
}

/* Input styles */
:deep(.ui-input input) {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.2) !important;
  color: white !important;
}

:deep(.ui-input input:focus) {
  border-color: rgb(168 85 247) !important;
  ring-color: rgb(168 85 247) !important;
}

:deep(.ui-input input::placeholder) {
  color: rgb(156 163 175) !important;
}
</style>
