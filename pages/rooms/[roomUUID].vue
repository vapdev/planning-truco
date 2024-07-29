<template>
  <div
    class="wrapper bg-[#F9F9F9] dark:bg-[#3f4146] text-gray-800 dark:text-white rubik-font h-full w-full flex flex-col justify-between"
  >
    <!-- HEADER -->
    <HeaderSala class="h-1/5" ref="headerRef" @endGame="endGame" />

    <div class="flex justify-around w-full h-3/4">
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
    <div class="w-full h-2/5 flex flex-col justify-end overflow-hidden">
      <Transition
        enter-active-class="slide-up-enter-active"
        enter-from-class="slide-up-enter-from"
        enter-to-class="slide-up-enter-to"
      >
        <div v-if="!userStore.roomState.showCards" key="deck">
          <Deck :selectedCard="selectedCard" :votar="votar" />
        </div>
        <div v-else key="stats">
          <Stats />
        </div>
      </Transition>
    </div>

    <div>
      <div
        v-for="emoji in emojiThrowStack"
        :key="emoji.key"
        class="absolute pointer-events-none select-none touch-manipulation text-4xl transition-transform duration-1000 ease-in-out z-50"
        :style="emoji.style"
      >
        {{ emoji.i }}
      </div>
    </div>
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

const animationKey = ref(0);

const computedEmojiStack = computed(() => {
  return [...userStore.emojiStack];
});

// Watcher para detectar mudanças no emojiStack
watch(
  computedEmojiStack,
  (newStack, oldStack) => {
    newStack.forEach((emoji) => {
      if (!oldStack.includes(emoji)) {
        animateEmoji(emoji.originUserId, emoji.targetUserId, emoji.emoji);
      }
    });
  },
  { deep: true }
);

const emojiThrowStack = ref([]);

const animateEmoji = (startId, endId, emoji) => {
  const startLocation = userStore.playerLocations[startId];
  const endLocation = userStore.playerLocations[endId];

  if (startLocation && endLocation) {
    const key = `emoji-${Date.now()}-${animationKey.value++}`;
    emojiThrowStack.value.push({
      i: emoji,
      key: key,
      style: {
        top: `${startLocation.top + 15}px`,
        left: `${startLocation.left - 5}px`,
      },
    });

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        emojiThrowStack.value = emojiThrowStack.value.map((e) => {
          if (e.key === key) {
            return {
              ...e,
              style: {
                ...e.style,
                transform: `translate(${endLocation.left - startLocation.left}px, ${
                  endLocation.top - startLocation.top
                }px)`,
              },
            };
          }
          return e;
        });
      });
    });

    setTimeout(() => {
      emojiThrowStack.value = emojiThrowStack.value.filter((e) => e.key !== key);
    }, 1000);
  }
};

onMounted(async () => {
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
  await userStore.loadGame(route.params.roomUUID);
  if (!userStore.name || userStore.name == "Guest") {
    headerRef.value.modalName = true;
  }
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

.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.6s ease;
  overflow: hidden;
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
}
</style>
