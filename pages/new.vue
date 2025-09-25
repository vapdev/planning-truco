<template>
  <div class="h-screen bg-gradient-to-br from-slate-900 via-gray-900 to-slate-900 text-white relative overflow-hidden flex flex-col">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-indigo-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-slate-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <header class="relative z-10 backdrop-blur-sm bg-white/5 border-b border-white/10 py-3">
      <div class="container mx-auto flex justify-between items-center px-6">
        <a href="/" class="text-2xl font-bold bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent hover:from-blue-300 hover:to-indigo-300 transition-all duration-300">
          Free Planning Poker<span class="text-blue-400">.</span>
        </a>
        <LanguageSelector />
      </div>
    </header>

    <div class="relative z-10 flex-1 flex items-center justify-center py-4 px-4 overflow-y-auto">
      <div class="backdrop-blur-sm bg-white/10 border border-white/20 p-4 sm:p-6 rounded-2xl shadow-2xl w-full max-w-lg animate-fade-in my-4">
        <form class="space-y-4">
          <div class="text-center mb-4">
            <h2 class="text-2xl sm:text-3xl font-bold bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
              {{ $t("createRoom") }}
            </h2>
            <p class="text-gray-300 mt-1 text-sm">{{ $t("configureYourPokerRoom") }}</p>
          </div>
          
          <div class="space-y-4">
            <div class="space-y-1">
              <label class="text-base font-semibold text-blue-200">{{ $t("roomName") }}</label>
              <UInput
                v-model="roomName"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-blue-400 focus:ring-blue-400"
                :placeholder="$t('roomName')"
              />
            </div>
            
            <div class="space-y-1">
              <label class="text-base font-semibold text-blue-200">{{ $t("deck") }}</label>
              <USelectMenu
                v-model="baralho"
                :options="deckOptions"
                size="lg"
                color="gray"
                class="w-full font-light"
                :ui="{
                  trigger: 'bg-white/5 border-white/20 text-white focus:border-blue-400 focus:ring-blue-400',
                  option: { base: 'cursor-pointer select-none relative py-2 pl-3 pr-9 text-gray-900' }
                }"
              ></USelectMenu>
            </div>
            
            <div v-if="baralho.value === 'custom'" class="space-y-1">
              <label class="text-base font-semibold text-blue-200">{{ $t("customDeck") }}</label>
              <UInput
                v-model="customDeckInput"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-blue-400 focus:ring-blue-400"
                :placeholder="$t('customDeckPlaceholder')"
              />
            </div>
            
            <div class="space-y-2">
              <label class="text-base font-semibold text-blue-200">{{ $t("preview") }}</label>
              <div class="flex gap-1.5 flex-wrap">
                <div v-for="card in selectedDeck.slice(0, 8)" :key="card.value" 
                     class="group relative">
                  <div class="w-10 h-12 sm:w-12 sm:h-14 bg-gradient-to-br from-blue-500 to-indigo-500 rounded-md flex items-center justify-center cursor-pointer shadow-lg transform transition-all duration-300 hover:scale-105 hover:shadow-blue-500/25">
                    <span class="text-white font-bold text-xs">{{ card.label }}</span>
                  </div>
                </div>
                <div v-if="selectedDeck.length > 8" class="w-10 h-12 sm:w-12 sm:h-14 bg-gradient-to-br from-gray-500 to-gray-600 rounded-md flex items-center justify-center cursor-pointer shadow-lg">
                  <span class="text-white font-bold text-xs">+{{ selectedDeck.length - 8 }}</span>
                </div>
              </div>
            </div>
            
            <div class="pt-2">
              <button
                type="button"
                @click="mostrarOpcoesAvancadas = !mostrarOpcoesAvancadas"
                class="group flex items-center gap-2 px-3 py-2 bg-white/5 border border-white/20 rounded-lg hover:bg-white/10 transition-all duration-300 text-blue-200 hover:text-white text-sm"
              >
                <svg class="w-4 h-4 transform transition-transform duration-300" :class="{ 'rotate-180': mostrarOpcoesAvancadas }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
                {{ mostrarOpcoesAvancadas ? $t("hideAdvancedSettings") : $t("showAdvancedSettings") }}
              </button>
              
              <div v-show="mostrarOpcoesAvancadas" class="mt-3 space-y-3 p-3 bg-white/5 rounded-lg border border-white/10">
                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <div class="font-semibold text-blue-200 text-sm">{{ $t("revealCardsTitle") }}</div>
                    <div class="text-xs text-gray-400 mt-1">
                      {{ $t("revealCardsDescription") }}
                    </div>
                  </div>
                  <UToggle
                    @click="toggleVirarAutomatico"
                    v-model="virarAutomatico"
                    color="blue"
                    class="ml-4"
                  />
                </div>
              </div>
            </div>
          </div>
          
          <div class="pt-3">
            <button
              type="button"
              @click="userStore.startGame(gameOptions)"
              class="group relative w-full inline-flex items-center justify-center px-6 py-3 text-lg font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-slate-900"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
              <span class="relative z-10 flex items-center font-bold">
                {{ $t("createRoom") }}
                <svg class="w-5 h-5 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
const { t } = useI18n();
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

const deckOptions = computed(() => [
  ...Object.keys(decks).filter(key => key !== 'deckLabels').map(key => ({
    value: key,
    label: decks.deckLabels[key] || key,
  })),
  { value: 'custom', label: t('customDeckOption') }
]);

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
  --tw-ring-color: rgb(168 85 247) !important;
}

:deep(.ui-input input::placeholder) {
  color: rgb(156 163 175) !important;
}

/* Responsive adjustments for small screens */
@media (max-height: 700px) {
  .form-container {
    padding: 0.75rem;
    margin: 0.5rem;
  }
  
  .form-title {
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
  }
  
  .form-subtitle {
    font-size: 0.875rem;
    margin-top: 0.25rem;
  }
  
  .form-spacing {
    gap: 0.75rem;
  }
  
  .preview-cards {
    gap: 0.375rem;
  }
  
  .card-preview {
    width: 2rem;
    height: 2.5rem;
  }
}
</style>
