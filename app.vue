<template>
  <div class="h-[100vh] w-[100vw] flex flex-col">
    <!-- HEADER -->
    <div class="w-full px-4 flex justify-between text-white items-center text-2xl bg-preto h-28">
      <div class="oswald-font text-green-500">Free Planning Poker</div>
      <div class="text-lg font-bold">
        <div class="flex gap-8">
          <div>Sign Up</div>
          <div>Login</div>
          <button @click="startGame"
            class="bg-green-500 w-60 md:hover:bg-green-400 font-bold px-4 rounded">
            Iniciar nova sala
          </button>
        </div>
      </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="flex justify-around h-full px-28 py-32">
      <div class="text-white text-xl">
        <p class="text-4xl mb-8">Bem-vindo ao <span class="underline-offset-4 underline text-green-500">Free Planning Poker</span>!</p>

        <ul class="mb-8 list-disc pl-6">
          <li>Simples</li>
          <li>Em tempo real</li>
          <li>Acesse de qualquer dispositivo</li>
          <li>Jogue como convidado ou crie sua conta</li>
          <li class="mb-8">Sem limite de partidas, votos ou usuários</li>
          <li>Adicione o nome das tasks para votação (PREMIUM)</li>
          <li>Tenha acesso ao histórico das votações (PREMIUM)</li>
          <li>Exporte os resultados para CSV e Excel (PREMIUM)</li>
        </ul>

        <p class="my-32">Tenha acesso aos recursos <span class="text-green-500 cursor-pointer underline">Premium</span>
        </p>
        <div class="flex align-center gap-2">
          <p class="text-xs">Criado por:</p>
          <div class="cursor-pointer flex align-center gap-2">
            <p class="text-xs">vapdev </p>
            <Icon name="uil:github" color="black" />
          </div>
        </div>
      </div>
      <div class="text-white text-2xl">
        <p class="text-3xl mb-4 font-bold">Jogue agora gratuitamente!</p>
        <div class="flex font-bold text-xl py-8 gap-16">
          <template v-if="!jogoComecou">
            <div class="flex flex-col gap-6 text-white">
              <p>Crie uma nova sala</p>
              <button @click="startGame"
                class="w-60 bg-green-500 md:hover:bg-green-400 text-white font-bold py-2 px-4 rounded">
                Iniciar nova sala
              </button>
            </div>
            <div class="flex flex-col gap-6 text-white">
              <div>Ou entre em uma sala existente</div>
              <div>
                <input v-model="roomUUID" class="border-2 h-12 border-green-500 rounded pl-2"
                  placeholder="Insira o link da sala" />
              </div>
            </div>
          </template>
          <!-- <div class="flex h-10">
          <input v-model="nome" class="border-2 w-40 rounded pl-2" placeholder="Seu nome aqui" />
        </div> -->
        </div>
      </div>
    </div>

    <div class="w-full bg-cinza md:grid md:grid-cols-2 flex flex-col mt-16 md:mt-0">
      <div class="w-full">
        <div v-if="jogoComecou" class="flex-col flex gap-4">
          <div class="text-white text-xl w-full md:w-fit mr-6">
            Nome da sala: <span class="font-bold">{{ roomUUID }}</span>
          </div>
          <button @click="endGame"
            class="bg-red-500 w-40 mb-4 md:mb-0 md:hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
            Sair da sala
          </button>
        </div>
      </div>
    </div>
    <template v-if="jogoComecou">
      <div class="relative pb-10">
        <div v-if="jogoComecou && jogadorLogado && jogadorLogado.admin"
          class="absolute md:-top-10 left-1/2 w-full transform -translate-x-1/2">
          <div class="flex flex-col w-full justify-center items-center gap-6">
            <div class="flex flex-col w-full justify-center text-white gap-4">
              <div class="flex justify-center gap-3 w-full yupi">
                <div @click="toggleVirarAutomatico"
                  class="md:hover:bg-gray-500 w-7 rounded-lg justify-center items-center cursor-pointer h-7 border-2 border-white flex">
                  <div v-show="virarAutomatico" class="font-bold text-green-400 text-xl">
                    ✓
                  </div>
                </div>
                <div class="flex">
                  <div>Revelar votos automaticamente</div>
                </div>
              </div>
            </div>
            <div v-if="!virarAutomatico && !roomState.showCards" class="text-red-500">
              <button @click="toggleMostrarCartas"
                class="text-white font-bold py-2 px-4 rounded w-40 bg-green-500 hover:bg-green-700">
                <span>Revelar votos</span>
              </button>
            </div>
            <div v-if="roomState.showCards">
              <button @click="novaRodada"
                class="w-50 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded bg-blue-500">
                <span>Iniciar nova votação</span>
              </button>
            </div>
          </div>
        </div>
        <div class="justify-center pt-32 md:pt-10 flex flex-wrap w-full gap-10">
          <PlayerVote v-for="(player, index) in players" :key="player.id" :player="player"
            :mostrarCartas="mostrarCartas" />
        </div>
      </div>
      <div class="md:justify-center overflow-x-auto pb-6 gap-4 md:h-72 2 items-center w-full flex">
        <Carta v-if="!roomState.showCards" :selectedCard="selectedCard" :votar="votar" />
        <template v-else>
          <div class="flex flex-col gap-2 pb-4 md:pb-0">
            <div class="text-white text-xl md:text-2xl">Votação encerrada</div>
            <div class="flex items-center gap-4 text-white text-xl md:text-2xl">
              <div class="text-green-300">Carta mais votada: </div>
              <div
                class="mt-4 w-10 h-14 text-black font-bold flex-col relative flex rounded-lg justify-center border-4 border-green-500 bg-green-100">
                <span class="text-xl flex justify-center"><span>{{ winnerComputed }}</span></span>
              </div>
            </div>
          </div>
        </template>
      </div>
    </template>
  </div>
</template>

<style>
html {
  height: 100vh;
  background-color: #3f4146;
}

.oswald-font {
  font-family: "Oswald", sans-serif;
  font-optical-sizing: auto;
  font-weight: 200;
  font-style: normal;
}
</style>

<script setup>
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const wsUrl = config.public.wsBase;
import lodash from 'lodash';
const { debounce } = lodash;
const nome = ref("");
const roomUUID = ref(null);
const jogoComecou = ref(false);
const selectedCard = ref(null);
const mostrarCartas = ref(false);
const userUUID = ref(null);
const virarAutomatico = ref(false);
const roomState = ref(null);
const socket = ref(null);
const players = ref([]);

const winnerComputed = computed(() => {
  if (players.value.length > 0) {
    const votes = players.value.map(player => player.vote);
    const mostVoted = votes.reduce((acc, curr) => {
      acc[curr] = (acc[curr] || 0) + 1;
      return acc;
    }, {});
    const mostVotedArray = Object.entries(mostVoted);
    const mostVotedSorted = mostVotedArray.sort((a, b) => b[1] - a[1]);
    return mostVotedSorted[0][0];
  }
  return null;
});

const debouncedUpdate = debounce(() => {
  fetch(`${apiUrl}/changeName`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      userUUID: userUUID.value,
      roomUUID: roomUUID.value,
      name: nome.value,
    }),
  });
}, 1000); // 1000 milliseconds = 1 second

const $md = ref(null)

onMounted(() => {
  $md.value = window.matchMedia('(min-width: 768px)').matches
  const savedUserUUID = localStorage.getItem('userUUID');
  if (savedUserUUID) {
    userUUID.value = savedUserUUID;
  }
});

watch(nome, (newVal, oldVal) => {
  if (newVal) {
    debouncedUpdate();
  }
});

const jogadorLogado = computed(() =>
  players.value.find((player) => player.uuid === userUUID.value)
);

const startGame = async () => {
  const response = await fetch(`${apiUrl}/createRoom`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      userUUID: userUUID.value,
    }),
  });

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  const data = await response.json();

  roomUUID.value = data.roomUUID;
  userUUID.value = data.userUUID;
  localStorage.setItem('userUUID', userUUID.value);
  socket.value = new WebSocket(`${wsUrl}/ws/${roomUUID.value}/${userUUID.value}`);

  socket.value.addEventListener('open', (event) => {
    socket.value.send(JSON.stringify({
      type: 'newAdmin',
      userUUID: userUUID.value,
      name: nome.value,
    }));
  });

  socket.value.addEventListener('message', (event) => {
    const data = JSON.parse(event.data);
    console.log(data);
    roomState.value = data;
    players.value = data.players;
  });

  socket.value.addEventListener('close', (event) => {
    // Connection was closed
  });

  socket.value.addEventListener('error', (event) => {
    // An error occurred
  });

  jogoComecou.value = true;
}

const endGame = () => {
  if (roomUUID.value) {
    fetch(`${apiUrl}/leaveRoom`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userUUID: userUUID.value,
        roomUUID: roomUUID.value,
      }),
    });
  }
  sairDaSala();
};

const toggleMostrarCartas = () => {
  fetch(`${apiUrl}/showCards`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      roomUUID: roomUUID.value,
    }),
  });
};

const toggleVirarAutomatico = () => {
  fetch(`${apiUrl}/autoShowCards`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      roomUUID: roomUUID.value,
    }),
  });
};

watch(players, (newPlayers, oldPlayers) => {
  if (newPlayers.length > 0) {
    newPlayers.forEach(player => {
      if (player.voted && player.vote !== selectedCard.value && player.uuid === userUUID.value) {
        selectedCard.value = player.vote;
      }
      if (selectedCard.value && !player.voted && player.uuid === userUUID.value) {
        selectedCard.value = null;
      }
    });
  }
}, { deep: true });

watch(roomState, (newRoomState, oldRoomState) => {
  if (newRoomState) {
    virarAutomatico.value = newRoomState.autoShowCards;
    mostrarCartas.value = newRoomState.showCards;
  }
}, { deep: true });

const loadGame = async () => {
  if (roomUUID.value) {
    const response = await fetch(`${apiUrl}/joinRoom`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userUUID: userUUID.value,
        roomUUID: roomUUID.value,
      }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    userUUID.value = data.userUUID;
    localStorage.setItem('userUUID', userUUID.value);
    roomUUID.value = data.roomUUID;

    socket.value = new WebSocket(`${wsUrl}/ws/${roomUUID.value}/${userUUID.value}`);

    socket.value.addEventListener('open', (event) => {
      socket.value.send(JSON.stringify({
        type: 'newPlayer',
        userUUID: userUUID.value,
        name: nome.value,
      }));
    });

    socket.value.addEventListener('message', (event) => {
      const data = JSON.parse(event.data);
      roomState.value = data;
      players.value = data.players;
    });

    socket.value.addEventListener('close', (event) => {
      // Connection was closed
    });

    socket.value.addEventListener('error', (event) => {
      // An error occurred
    });
    jogoComecou.value = true;
  }
};

const novaRodada = () => {
  fetch(`${apiUrl}/resetVotes`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      roomUUID: roomUUID.value,
    }),
  });
}

const sairDaSala = () => {
  roomUUID.value = null;
  jogoComecou.value = false;
  players.value = [];
  virarAutomatico.value = true;
  selectedCard.value = null;
  mostrarCartas.value = false;
};

const votar = (score) => {
  if (selectedCard.value === score) {
    selectedCard.value = null;
  } else {
    selectedCard.value = score;
  }

  if (jogadorLogado.value) {
    socket.value.send(JSON.stringify({
      type: 'vote',
      userUUID: userUUID.value,
      roomUUID: roomUUID.value,
      vote: score
    }));
  }
};

</script>
