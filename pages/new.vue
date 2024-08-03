<template>
  <div class="flex flex-col min-h-screen rubik-font">
    <header class="relative bg-primary-800 w-full text-white h-24">
      <div
        class="container flex items-center justify-center h-full max-w-6xl px-8 mx-auto sm:justify-between xl:px-0"
      >
        <a
          href="/"
          class="relative flex items-center inline-block h-5 h-full font-black leading-none"
        >
          <span id="home" class="ml-3 text-xl text-white"
            >Free Planning Poker<span class="text-primary-600">.</span></span
          >
        </a>
      </div>
    </header>
    <div
      class="flex-grow dark:text-white flex items-center justify-center bg-gray-100 dark:bg-gray-800"
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
                :options="votingSystems"
                size="lg"
                color="gray"
                class="w-full font-light"
              ></USelectMenu>
            </div>
            <div
              @click="mostrarOpcoesAvancadas = !mostrarOpcoesAvancadas"
              class="cursor-pointer mt-4 p-2 text-sm bg-gray-200 dark:bg-gray-600 w-fit rounded-xl text-center"
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
                    color="primary"
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
                    color="primary"
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
              color="primary"
              variant="solid"
              size="lg"
              class="w-full text-xl flex justify-center"
              @click="userStore.startGame(roomName)"
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
const virarAutomatico = ref(false);
const roomName = ref("");
const baralho = ref("Fibonacci");
const mostrarOpcoesAvancadas = ref(false);
const todosPodemVotar = ref(false);
const emojis = ref(false);
const userStore = useUserStore();

const votingSystems = [
  "Fibonacci",
  "T-Shirt Sizes",
  "Standard",
  "Criar baralho customizado",
];

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
