<template>
  <div :key="key"
    class="wrapper atkinson-hyperlegible-mono-regular h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white relative overflow-hidden">
    
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <!-- Radial spotlight effect for depth -->
    <div class="absolute inset-0 bg-gradient-radial from-transparent via-transparent to-slate-900/50"></div>
    
    <div class="wrapper h-full w-full flex flex-col justify-between relative z-10">
      <HeaderSala class="flex-shrink-0" ref="headerRef" @endGame="endGame" @toggleRightPanel="toggleRightPanel" />
      <div class="flex justify-around w-full flex-1 min-h-0">
        <div class="w-1/4 sm:w-1/3 flex flex-col items-center"></div>
        <div class="flex w-1/2 sm:w-1/3 flex-col justify-center items-center min-h-0">
          <TopContainer :players="playersTop" />
          <div class="flex gap-2 sm:gap-4 justify-center items-center my-2">
            <LeftContainer :players="playersLeft" />
            <Mesa @toggleMostrarCartas="toggleMostrarCartas" />
            <RightContainer :players="playersRight" />
          </div>
          <BottomContainer :players="playersBottom" />
        </div>
        <div class="w-1/4 sm:w-1/3 flex justify-center"></div>
      </div>
      <div class="w-full flex-shrink-0 flex flex-col justify-end overflow-hidden relative" style="height: 30vh; min-height: 200px;">
        <Transition name="deck-appear">
          <Deck 
            :deck="deck" 
            :selectedCard="selectedCard" 
            :votar="votar" 
            :showCards="userStore.roomState.showCards"
            @showStats="showStatsModal = true"
            @newRound="handleNewRound"
          />
        </Transition>
      </div>
      
      <!-- Stats Modal -->
      <StatsModal 
        :isOpen="showStatsModal" 
        :cards="deck" 
        @close="showStatsModal = false"
        @newRound="handleNewRound"
      />
      <EmojiHandler />
    </div>
    <Transition name="rpanel" mode="out-in">
      <RightPanel v-if="userStore.rightPanel" @close="userStore.rightPanel = false" />
    </Transition>
  </div>
</template>

<script setup>
const { gtag } = useGtag();
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const selectedCard = ref(null);
const route = useRoute();
const headerRef = ref(null);
const deck = ref([]);
const key = ref(0);
const userStore = useUserStore();
const showStatsModal = ref(false);


function toggleRightPanel() {
  userStore.rightPanel = !userStore.rightPanel;
}



onMounted(async () => {
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
  gtag("event", "join_room", { roomUUID: route.params.roomUUID });
  await userStore.loadGame(route.params.roomUUID);
  if (!userStore.name || userStore.name === "Guest") {
    headerRef.value.modalProfile = true;
  }
  deck.value = userStore.deck;
});

const computedPlayers = (condition) => computed(() => userStore.players.filter(condition));
const playersBottom = computedPlayers((_, index) => (index < 4 ? index % 4 === 0 : index % 2 === 0));
const playersTop = computedPlayers((_, index) => (index < 4 ? index % 4 === 1 : index % 2 === 1));
const playersLeft = computedPlayers((_, index) => index === 2);
const playersRight = computedPlayers((_, index) => index === 3);

const votar = (score) => {
  gtag("event", "vote", { score });
  selectedCard.value = selectedCard.value === score ? null : score;
  if (jogadorLogado.value) {
    userStore.ws.send(JSON.stringify({ type: "vote", userUUID: userStore.userUUID, roomUUID: userStore.roomUUID, vote: score }));
  }
};

const novaRodada = () => {
  gtag("event", "nova_rodada");
  fetch(`${apiUrl}/resetVotes`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ roomUUID: userStore.roomUUID }) });
};

const closeStats = () => {
  // Just trigger a new round when closing stats
  novaRodada();
};

const handleNewRound = () => {
  showStatsModal.value = false;
  novaRodada();
};

const sairDaSala = () => {
  userStore.roomUUID = null;
  userStore.jogoComecou = false;
  userStore.players = [];
  userStore.roomState.autoShowCards = true;
  userStore.roomState.showCards = false;
  selectedCard.value = null;
  navigateTo("/");
};

const endGame = () => {
  gtag("event", "leave_room");
  if (userStore.roomUUID) {
    fetch(`${apiUrl}/leaveRoom`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ userUUID: userStore.userUUID, roomUUID: userStore.roomUUID }) });
  }
  sairDaSala();
};

const jogadorLogado = computed(() => userStore.players.find((player) => player.uuid === userStore.userUUID));
const toggleMostrarCartas = () => {
  gtag("event", "show_cards");
  fetch(`${apiUrl}/showCards`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ roomUUID: userStore.roomUUID }) });
};

onUnmounted(() => userStore.closeWsConnection());

watch(
  () => jogadorLogado.value,
  (newPlayer, oldPlayer) => {
    if (JSON.stringify(newPlayer) !== JSON.stringify(oldPlayer)) {
      if (newPlayer && !newPlayer.voted) {
        selectedCard.value = null;
      }
    }
  },
  { deep: true }
);
</script>

<style>
.wrapper {
  position: relative;
  height: 100dvh;
  overflow: hidden; /* Prevent any scroll */
}

.rpanel-enter-active,
.rpanel-leave-active {
  transition: width 0.3s ease-in-out;
}

.rpanel-enter-from,
.rpanel-leave-to {
  width: 0;
}

.slide-up-enter-active {
  transition: transform 0.6s ease;
}

.slide-up-enter-from {
  transform: translateY(100%);
}

.slide-up-enter-to {
  transform: translateY(0%);
}

.slide-up-leave-active,
.slide-up-leave-from,
.slide-up-leave-to {
  transition: none;
  transform: translateY(0%);
  display: none;
}

/* New deck appear animation - no scroll issues */
.deck-appear-enter-active {
  transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.deck-appear-leave-active {
  transition: all 0.3s ease-in;
}

.deck-appear-enter-from {
  opacity: 0;
  transform: translateY(30px) scale(0.95);
}

.deck-appear-leave-to {
  opacity: 0;
  transform: translateY(-20px) scale(0.95);
}

/* Modern background effects */
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

/* Radial gradient utility */
.bg-gradient-radial {
  background: radial-gradient(circle at center, var(--tw-gradient-stops));
}

/* Enhanced glassmorphism effects */
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}

/* Responsive adjustments for game room */
@media (max-height: 700px) {
  .wrapper {
    height: 100vh;
  }
  
  .game-area {
    min-height: 0;
  }
  
  .deck-area {
    height: 25vh !important;
    min-height: 150px !important;
  }
}

@media (max-height: 600px) {
  .deck-area {
    height: 20vh !important;
    min-height: 120px !important;
  }
  
  .game-center {
    gap: 0.25rem;
    margin: 0.25rem 0;
  }
}

@media (max-width: 640px) {
  .game-center {
    gap: 0.5rem;
  }
  
  .side-areas {
    width: 20%;
  }
  
  .center-area {
    width: 60%;
  }
}
</style>
