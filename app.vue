<template>
  <div class="h-[100vh] w-[100vw] flex flex-col justify-between p-16 ">
    <div class="w-full grid grid-cols-3">
      <div class="flex text-white gap-2">
        <div @click="virarAutomatico = !virarAutomatico" class="hover:bg-gray-500 w-7 rounded-lg cursor-pointer h-7 border-2 border-white justify-center flex items-center">
          <div v-if="virarAutomatico" class="font-bold text-green-400 text-xl">✓</div>
        </div>
        <div>Virar automaticamente após todos jogadores votarem</div>
      </div>
      <div class="text-4xl text-center text-white">🃏 Planning Truco 🃏</div>
      <div class="flex-grow flex-col flex gap-2">
        <div class="flex justify-end">
          <button
            @click="startGame"
            class="bg-green-500 w-40 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
          >
            Iniciar nova sala
          </button>
        </div>
        <div class="flex justify-end gap-2">
          <input
            v-model="gameId"
            class="border-2 border-green-500 rounded pl-2"
            placeholder="Digite o ID da sala"
          />
          <button
            @click="loadGame"
            class="bg-green-500 w-40 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
          >
            Entrar em sala
          </button>
        </div>
      </div>
    </div>
    <div class="w-full flex justify-center gap-10">
      <div
        v-for="(player, index) in players"
        :key="index"
        class="mt-10 flex-col flex gap-2"
      >
        <div
          class="w-28 h-40 flex-col flex rounded-lg justify-center border-8"
          :class="player.votou ? 'border-green-500 bg-green-100' : 'border-yellow-300 bg-yellow-100'"
        >
          <span v-if="mostrarCartas" class="text-5xl flex justify-center">{{ player.score }}</span>
        </div>
        <div>
          <span class="text-2xl flex justify-center text-white">{{ player.name }}</span>
        </div>
      </div>
    </div>
    <div class="w-full flex justify-center gap-4">
      <div
        v-for="(card, index) in fibonacciCards"
        :key="index"
        class="mt-10 flex-col flex gap-2 text-5xl hover:text-6xl hover:scale-[1.15]"
      >
        <div
          @click="votar(card.number)"
          :class="selectedCard == card.number ?  card.class + ' -translate-y-10' : card.class"
          class="w-24 h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4"
        >
          <span class="flex justify-center">{{ card.number }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
html {
  height: 100vh;
  background-color: #3f4146;
}
</style>

<script setup>
const playerId = 2;
const gameId = ref(null);
const selectedCard = ref(null);
const mostrarCartas = ref(false);
const virarAutomatico = ref(true);

const players = ref([
  { name: "Player 1", score: 0, votou: 1, id: 1},
  { name: "Player 2", score: 0, votou: 0, id: 2 },
  { name: "Player 3", score: 0, votou: 1, id: 3 },
  { name: "Player 4", score: 0, votou: 1, id: 4},
]);

const todosVotaram = computed(() => players.value.every((player) => player.votou));

watchEffect(() => {
  if (todosVotaram.value && virarAutomatico.value) {
    mostrarCartas.value = true;
  } else {
    mostrarCartas.value = false;
  }
});

const votar = (score) => {
  if (score == selectedCard.value) {
    selectedCard.value = null;
    players.value = players.value.map((player) => {
    if (player.id === playerId) {
      player.votou = false;
    }
    return player;
  });
    return;
  }
  selectedCard.value = score;
  players.value = players.value.map((player) => {
    if (player.id === playerId) {
      player.score = score;
      player.votou = true;
    }
    return player;
  });
};

const fibonacciCards = [
  {
    number: 0,
    class: "bg-green-100 border-green-200",
  },
  {
    number: 1,
    class: "bg-green-200 border-green-300",
  },
  {
    number: 2,
    class: "bg-green-300 border-green-400",
  },
  {
    number: 3,
    class: "bg-yellow-100 border-yellow-200",
  },
  {
    number: 5,
    class: "bg-yellow-200 border-yellow-300",
  },
  {
    number: 8,
    class: "bg-yellow-300 border-yellow-400",
  },
  {
    number: 13,
    class: "bg-red-100 border-red-200",
  },
  {
    number: 21,
    class: "bg-red-200 border-red-300",
  },
  {
    number: 34,
    class: "bg-red-300 border-red-400",
  },
];
</script>
