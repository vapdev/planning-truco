<template>
  <div class="flex flex-col min-h-screen">
    <header class="relative bg-indigo-500 w-full text-white h-24">
      <div
        class="container flex items-center justify-center h-full max-w-6xl px-8 mx-auto sm:justify-between xl:px-0"
      >
        <a
          href="/"
          class="relative flex items-center h-full font-black leading-none"
        >
          <span id="home" class="ml-3 text-xl text-white"
            >Free Planning Poker<span class="text-indigo-600">.</span></span
          >
        </a>
      </div>
    </header>
    <div
      class="flex-grow flex items-center justify-center bg-gray-100 text-black dark:text-white dark:bg-gray-800"
    >
      <div class="bg-white dark:bg-gray-700 p-8 pt-4 rounded shadow-md w-full max-w-md">
        <form>
          <div class="text-md flex flex-col">
            <div class="mt-4 mb-1 font-semibold">Nome da sala:</div>
            <div class="flex w-full mb-4">
              <UInput
                v-model="roomName"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light"
                placeholder="Nome da sala"
              />
            </div>
            <div class="mb-1 font-semibold">Baralho:</div>
            <div class="flex w-full mb-4">
              <USelectMenu
                v-model="baralho"
                :options="deckOptions"
                size="lg"
                color="gray"
                class="w-full font-light"
              ></USelectMenu>
            </div>
            <div v-if="baralho.value === 'custom'" class="mb-1 font-semibold">Deck personalizado:</div>
            <div v-if="baralho.value === 'custom'" class="flex w-full mb-4">
              <UInput
                v-model="customDeckInput"
                size="lg"
                variant="outline"
                color="gray"
                class="w-full"
                inputClass="font-light"
                placeholder="Ex: 1, 2, 3, 5, 8"
              />
            </div>
            <div class="mb-1 font-semibold">Preview:</div>
            <div class="flex w-full mb-4 gap-2">
              <div v-for="card in selectedDeck" :key="card.value">
                <div
                  class="text-md bg-indigo-500 hover:bg-indigo-600 w-6 h-10 flex items-center rounded-md justify-center cursor-pointer"
                >
                  <div class="flex justify-center w-24 text-white">{{ card.label }}</div>
                </div>
              </div>
            </div>
            <div
              @click="mostrarOpcoesAvancadas = !mostrarOpcoesAvancadas"
              class="cursor-pointer mt-4 p-2 text-sm bg-gray-200 dark:bg-gray-600  w-fit rounded-xl text-center"
            >
              {{ mostrarOpcoesAvancadas ? "Esconder" : "Mostrar" }} opções avançadas
            </div>
            <div v-show="mostrarOpcoesAvancadas">
              <div class="flex items-center gap-4 justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div class="font-semibold">Revelar cartas automaticamente</div>
                  <div class="font-normal text-sm">
                    As cartas serão reveladas automaticamente após todos os jogadores
                    votarem
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle
                    @click="toggleVirarAutomatico"
                    v-model="virarAutomatico"
                    color="indigo"
                    class="dark:border-2 dark:border-gray-600"
                  />
                </div>
              </div>
              <!-- <div class="flex items-center gap-4 justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div class="font-semibold">Todos podem revelar os votar</div>
                  <div class="font-normal text-sm">
                    Define se todos jogadores podem revelar os votos ou apenas o
                    facilitador
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle
                    @click="toggleTodosPodemVotar"
                    v-model="todosPodemVotar"
                    color="indigo"
                    class="dark:border-2 dark:border-gray-600"
                  />
                </div>
              </div> -->
              <!-- <div class="flex items-center gap-4 justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div class="font-semibold">Habilitar recursor divertidos</div>
                  <div class="font-normal text-sm">
                    Habilita emojis e outros recursos divertidos
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle
                    class="dark:border-2 dark:border-gray-600"
                    @click="toggleEmojis"
                    v-model="emojis"
                  />
                </div>
              </div> -->
            </div>
          </div>
          <div class="flex text-center mt-8">
            <UButton
              color="indigo"
              variant="solid"
              size="lg"
              class="w-full text-xl flex justify-center"
              @click="userStore.startGame(gameOptions)"
            >
              <span class="dark:text-white font-bold text-2xl">Criar sala</span>
            </UButton>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import * as decks from "@/utils/decks";
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
