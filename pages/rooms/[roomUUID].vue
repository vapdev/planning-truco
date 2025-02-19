<template>
  <div :key="key"
    class="wrapper atkinson-hyperlegible-mono-regular bg-[#f0f0f0] dark:bg-[#121212] text-gray-800 dark:text-[#FFFFF0] flex overflow-hidden">
    <div class="wrapper h-full w-full flex flex-col justify-between">
      <HeaderSala class="h-1/5" ref="headerRef" @endGame="endGame" @toggleRightPanel="toggleRightPanel" />
      <div class="flex justify-around w-full h-2/5">
        <div class="w-1/3 flex flex-col items-center"></div>
        <div class="flex w-1/3 flex-col justify-center items-center">
          <TopContainer :players="playersTop" />
          <div class="flex gap-4 justify-center items-center">
            <LeftContainer :players="playersLeft" />
            <Mesa @toggleMostrarCartas="toggleMostrarCartas" @novaRodada="novaRodada" />
            <RightContainer :players="playersRight" />
          </div>
          <BottomContainer :players="playersBottom" />
        </div>
        <div class="w-1/3 flex justify-center"></div>
      </div>
      <div class="w-full h-2/5 flex flex-col justify-end overflow-clip">
        <Transition name="slide-up">
          <Deck v-if="!userStore.roomState.showCards" :deck="deck" :selectedCard="selectedCard" :votar="votar" />
          <Stats class="text-gray-700 dark:text-[#FFFFF0]" v-else :cards="deck" />
        </Transition>
      </div>
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
</style>
