<template>
  <div :key="key"
    class="wrapper atkinson-hyperlegible-mono-regular bg-[#f0f0f0] dark:bg-[#3f4146] text-gray-800 dark:text-white flex">

    <div class="wrapper h-full w-full flex flex-col justify-between">

      <!-- HEADER -->
      <HeaderSala class="h-1/5" ref="headerRef" @endGame="endGame" />

      <div class="flex justify-around w-full h-2/5">
        <!-- MAIN CONTENT -->
        <div class="w-1/3 flex flex-col items-center">
          <!-- <span>Histórico de votações:</span> -->
        </div>
        <div class="flex w-1/3 flex-col justify-center items-center">
          <!-- PLAYERS DE CIMA -->
          <TopContainer :players="playersTop" />
          <div class="flex gap-4 justify-center items-center">
            <!-- PLAYERS DA ESQUERDA -->
            <LeftContainer :players="playersLeft" />
            <!-- MESA -->
            <Mesa @toggleMostrarCartas="toggleMostrarCartas" @novaRodada="novaRodada" />
            <!-- PLAYERS DA DIREITA -->
            <RightContainer :players="playersRight" />
          </div>
          <!-- PLAYERS DE BAIXO -->
          <BottomContainer :players="playersBottom" />
        </div>
        <div class="w-1/3 flex justify-center">
          <!-- teste2 -->
        </div>
      </div>

      <!-- FOOTER -->
      <div class="w-full h-2/5 flex flex-col justify-end overflow-clip">
        <Transition enter-active-class="slide-up-enter-active" enter-from-class="slide-up-enter-from"
          enter-to-class="slide-up-enter-to" leave-active-class="slide-up-leave-active"
          leave-from-class="slide-up-leave-from" leave-to-class="slide-up-leave-to">
          <div v-if="!userStore.roomState.showCards" key="deck">
            <Deck :deck="deck" :selectedCard="selectedCard" :votar="votar" />
          </div>
          <div v-else key="stats">
            <Stats :cards="deck" />
          </div>
        </Transition>
      </div>

      <EmojiHandler />
    </div>

    <!-- <div class="bg-[#f9f9f9] w-[600px] px-6 py-5">
      <div class="flex justify-between">
        <div>
          <div class="text-xl font-semibold">Issues</div>
          <div class="text-sm">4 issues • 32 points</div>
        </div>
        <div>
          <button class="bg-[#f0f0f0] text-gray-800 dark:text-white dark:bg-[#3f4146] px-4 py-2 rounded-lg">Add
            issue</button>
          </div>
      </div>
      <div class="mt-6">
        <div class="bg-[#eeeeee] flex justify-between py-2 px-4">
          <div class="text-sm">Issue</div>
          <div class="text-sm">Points</div>
        </div>
        <div class="flex justify-between py-2 px-4">
          <div class="text-sm">Issue</div>
          <div class="text-sm">Points</div>
        </div>
        <div class="flex justify-between py-2 px-4">
          <div class="text-sm">Issue</div>
          <div class="text-sm">Points</div>
        </div>
      </div>
    </div> -->

  </div>
</template>

<script setup>
const { gtag } = useGtag();
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const selectedCard = ref(null);
const route = useRoute();
const headerRef = ref(null);
const userStore = useUserStore();
const $md = ref(null);
const deck = ref([
  {
    value: 0,
    label: "0",
  },
]);

const key = ref(0);

onMounted(async () => {
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
  gtag("event", "join_room", { roomUUID: route.params.roomUUID });
  await userStore.loadGame(route.params.roomUUID);
  if (!userStore.name || userStore.name == "Guest") {
    headerRef.value.modalProfile = true;
  }
  deck.value = userStore.deck;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const playersBottom = computed(() => {
  return userStore.players.filter((_, index) => {
    if (index < 4) return index % 4 === 0;
    return index % 2 === 0;
  });
});

const playersTop = computed(() => {
  return userStore.players.filter((_, index) => {
    if (index < 4) return index % 4 === 1;
    return index % 2 === 1;
  });
});

const playersLeft = computed(() => {
  return userStore.players.filter((_, index) => index === 2);
});

const playersRight = computed(() => {
  return userStore.players.filter((_, index) => index === 3);
});

watch(
  userStore.players,
  (newPlayers, oldPlayers) => {
    if (newPlayers.length > 0) {
      newPlayers.forEach((player) => {
        if (
          player.voted &&
          player.vote !== selectedCard.value &&
          player.uuid === userUUID.value
        ) {
          selectedCard.value = player.vote;
        }
        if (selectedCard.value && !player.voted && player.uuid === userUUID.value) {
          selectedCard.value = null;
        }
      });
    }
  },
  { deep: true }
);

const novaRodada = () => {
  gtag("event", "nova_rodada");
  fetch(`${apiUrl}/resetVotes`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      roomUUID: userStore.roomUUID,
    }),
  });
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

const votar = (score) => {
  gtag("event", "vote", { score });
  if (selectedCard.value === score) {
    selectedCard.value = null;
  } else {
    selectedCard.value = score;
  }

  if (jogadorLogado.value) {
    userStore.ws.send(
      JSON.stringify({
        type: "vote",
        userUUID: userStore.userUUID,
        roomUUID: userStore.roomUUID,
        vote: score,
      })
    );
  }
};

const endGame = () => {
  gtag("event", "leave_room");
  if (userStore.roomUUID) {
    fetch(`${apiUrl}/leaveRoom`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        userUUID: userStore.userUUID,
        roomUUID: userStore.roomUUID,
      }),
    });
  }
  sairDaSala();
};

const jogadorLogado = computed(() =>
  userStore.players.find((player) => player.uuid === userStore.userUUID)
);

// Reset selected card when round finishes
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

const toggleMostrarCartas = () => {
  gtag("event", "show_cards");
  fetch(`${apiUrl}/showCards`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      roomUUID: userStore.roomUUID,
    }),
  });
};

onUnmounted(() => {
  userStore.closeWsConnection();
});
</script>

<style>
.wrapper {
  height: 100dvh;
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
