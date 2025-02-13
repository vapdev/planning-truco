<template>
  <div
    :key="key"
    class="wrapper atkinson-hyperlegible-mono-regular bg-[#F9F9F9] dark:bg-[#3f4146] text-gray-800 dark:text-white h-full w-full flex flex-col justify-between"
  >
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
      <Transition
        enter-active-class="slide-up-enter-active"
        enter-from-class="slide-up-enter-from"
        enter-to-class="slide-up-enter-to"
        leave-active-class="slide-up-leave-active"
        leave-from-class="slide-up-leave-from"
        leave-to-class="slide-up-leave-to"
      >
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
</template>

<script setup>
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
