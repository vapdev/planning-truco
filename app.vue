<template>
  <div class="h-[100vh] w-[100vw] flex flex-col justify-between p-16">
    <div class="w-full grid grid-cols-3">
      <div>
        <template v-if="jogoComecou && jogadorLogado && jogadorLogado.admin">
          <div class="flex flex-col text-white gap-4">
            <div class="flex gap-2">
              <div @click="virarAutomatico = !virarAutomatico"
                class="hover:bg-gray-500 w-7 rounded-lg cursor-pointer h-7 border-2 border-white justify-center flex items-center">
                <div v-if="virarAutomatico" class="font-bold text-green-400 text-xl">
                  ✓
                </div>
              </div>
              <div>Virar automaticamente após todos jogadores votarem</div>
            </div>
            <div v-if="!virarAutomatico" class="text-red-500">
              <button @click="mostrarCartas = !mostrarCartas" class="text-white font-bold py-2 px-4 rounded w-40"
                :class="mostrarCartas
          ? 'bg-red-500 hover:bg-red-700'
          : 'bg-green-500 hover:bg-green-700'
          ">
                <span v-if="mostrarCartas">Esconder cartas</span>
                <span v-else>Mostrar cartas</span>
              </button>
            </div>
            <div>
              <button @click="novaRodada" class="w-40 text-white font-bold py-2 px-4 rounded bg-blue-500">
                <span>Nova rodada</span>
              </button>
            </div>
          </div>
        </template>
      </div>
      <div class="text-4xl text-center text-white">🃏 Planning Truco 🃏</div>
      <div class="flex-grow flex-col flex gap-2">
        <template v-if="!jogoComecou">
          <div class="flex justify-end">
            <button @click="startGame"
              class="bg-green-500 w-40 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
              Iniciar nova sala
            </button>
          </div>
          <div class="flex justify-end gap-2">
            <input v-model="roomID" class="border-2 border-green-500 rounded pl-2" placeholder="Digite o ID da sala" />
            <button @click="loadGame"
              class="bg-green-500 w-40 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
              Entrar em sala
            </button>
          </div>
        </template>
        <div v-if="jogoComecou" class="flex justify-end">
          <div class="text-white text-xl mr-6">
            ID da sala: <span class="font-bold">{{ roomID }}</span>
          </div>
          <button @click="endGame" class="bg-red-500 w-40 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
            Sair da sala
          </button>
        </div>
        <div class="flex justify-end h-10">
          <input v-model="nome" class="border-2 w-40 rounded pl-2" placeholder="Seu nome aqui" />
        </div>
      </div>
    </div>
    <template v-if="jogoComecou">
      <div class="w-full flex justify-center gap-10">
        <PlayerVote v-for="(player, index) in players" :key="index" :player="player" :mostrarCartas="mostrarCartas" />
      </div>
      <div class="w-full flex justify-center gap-4">
        <Carta v-for="(card, index) in fibonacciCards" :key="card.number" :card="card" :selectedCard="selectedCard"
          :votar="votar" />
      </div>
    </template>
  </div>
</template>

<style>
html {
  height: 100vh;
  background-color: #3f4146;
}
</style>

<script setup>
import { fibonacciCards } from './fibonacciCards.js';
const nome = ref("");
const roomID = ref(null);
const jogoComecou = ref(false);
const selectedCard = ref(null);
const mostrarCartas = ref(false);
const userID = ref(null);
const virarAutomatico = ref(true);

const socket = ref(null);

const players = ref([]);

const todosVotaram = computed(() => players.value.every((player) => player.votou));

onMounted(() => {
  const savedUserID = localStorage.getItem('userID'); // Retrieve from local storage
  if (savedUserID) {
    userID.value = Number(savedUserID);
  }
});

watchEffect(() => {
  if (todosVotaram.value && virarAutomatico.value) {
    mostrarCartas.value = true;
  } else {
    mostrarCartas.value = false;
  }
  if (nome.value) {
    players.value = players.value.map((player) => {
      if (player.id === userID.value) {
        player.name = nome.value;
      }
      return player;
    });
  }
});

const jogadorLogado = computed(() =>
  players.value.find((player) => player.id === userID.value)
);

const startGame = async () => {
  const response = await fetch('http://localhost:8080/createRoom', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      userID: userID.value,
    }),
  });

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  const data = await response.json();
  console.log(data);

  roomID.value = data.roomID;
  userID.value = data.userID;
  localStorage.setItem('userID', userID.value);
  // // start WebSocket connection
  socket.value = new WebSocket(`ws://localhost:8080/ws/${roomID.value}/${userID.value}`);

  socket.value.addEventListener('open', (event) => {
    // Connection was opened
    // Send a "newPlayer" message to the server
    socket.value.send(JSON.stringify({
      type: 'newAdmin',
      userID: userID.value,
      name: nome.value,
    }));
  });

  socket.value.addEventListener('message', (event) => {
    // Received a message from the server
    const data = JSON.parse(event.data);

    // Log the message
    console.log('Received message:', data);
    players.value = data.players;

    // Update the game state based on the message
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
  if (roomID.value) {
    fetch(`http://localhost:8080/leaveRoom`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userID: userID.value,
        roomID: Number(roomID.value),
      }),
    });
  }
  sairDaSala();
};

watch(players, (newPlayers, oldPlayers) => {
  if (newPlayers.length > 0) {
    newPlayers.forEach(player => {
      if (player.voted && player.vote !== selectedCard.value && player.id === userID.value) {
        selectedCard.value = player.vote;
      }
    });
  }
}, { deep: true });

const loadGame = async () => {
  if (roomID.value) {
    // make http request to join a game
    const response = await fetch(`http://localhost:8080/joinRoom`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userID: userID.value,
        roomID: Number(roomID.value),
      }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    userID.value = data.userID;
    localStorage.setItem('userID', userID.value);
    roomID.value = data.roomID;

    // // start WebSocket connection
    socket.value = new WebSocket(`ws://localhost:8080/ws/${roomID.value}/${userID.value}`);

    socket.value.addEventListener('open', (event) => {
      // Connection was opened
      // Send a "newPlayer" message to the server
      socket.value.send(JSON.stringify({
        type: 'newPlayer',
        userID: userID.value,
        name: nome.value,
      }));
    });

    socket.value.addEventListener('message', (event) => {
      // Received a message from the server
      const data = JSON.parse(event.data);

      // Log the message
      console.log('Received message:', data);
      players.value = data.players;

      // Update the game state based on the message
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
  players.value = players.value.map((player) => {
    player.votou = false;
    player.score = null;
    return player;
  });
  mostrarCartas.value = false;
  selectedCard.value = null;
}

const sairDaSala = () => {
  roomID.value = null;
  jogoComecou.value = false;
  players.value = [];
  virarAutomatico.value = true;
  selectedCard.value = null;
  mostrarCartas.value = false;
};

const votar = (score) => {
  console.log('Votando', score);
  // if selectedCard is already the same as the score, unselect it
  if (selectedCard.value === score) {
    selectedCard.value = null;
  } else {
    selectedCard.value = score;
  }

  if (jogadorLogado.value) {
    socket.value.send(JSON.stringify({
      type: 'vote',
      userID: userID.value,
      roomID: roomID.value,
      vote: score
    }));
  }
};

</script>
