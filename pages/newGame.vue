<template>
  <div class="flex flex-col min-h-screen">
    <header class="bg-indigo-100 w-full h-24 rubik-font">
      <div
        class="bg-indigo-100 flex items-center justify-center h-full max-w-6xl px-8 mx-auto sm:justify-between xl:px-0"
      >
        <a
          href="/"
          class="relative flex items-center inline-block h-5 h-full font-black leading-none"
        >
          <span id="home" class="ml-3 text-xl text-gray-800"
            >Free Planning Poker<span class="text-indigo-600">.</span></span
          >
        </a>
      </div>
    </header>
    <div class="flex-grow flex items-center justify-center bg-gray-100">
      <div class="bg-white font-semibold p-8 pt-4 rounded shadow-md w-full max-w-md">
        <form>
          <div class="text-md flex flex-col">
            <div class="mt-4 mb-1">Nome da sala:</div>
            <div class="flex w-full mb-4">
              <UInput
                v-model="roomName"
                size="lg"
                variant="outline"
                color="indigo"
                class="w-full"
                inputClass="border-1"
                placeholder="Nome da sala"
              />
            </div>
            <div class="mb-1">Baralho:</div>
            <div class="flex w-full mb-4">
              <USelectMenu
                v-model="baralho"
                :options="votingSystems"
                size="lg"
                color="indigo"
                class="w-full"
              ></USelectMenu>
            </div>
            <div
              @click="mostrarOpcoesAvancadas = !mostrarOpcoesAvancadas"
              class="cursor-pointer mt-4 p-2 text-sm bg-gray-200 w-fit rounded-xl text-center"
            >
              {{ mostrarOpcoesAvancadas ? "Esconder" : "Mostrar" }} opções avançadas
            </div>
            <div v-show="mostrarOpcoesAvancadas">
              <div class="flex items-center justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div>Revelar cartas automaticamente</div>
                  <div class="font-normal text-sm">
                    dawdawdasdgfa adsfuiasdf adugfasugdyfg
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle
                    @click="toggleVirarAutomatico"
                    v-model="virarAutomatico"
                    color="blue"
                  />
                </div>
              </div>
              <div class="flex items-center justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div>Todos podem revelar os votar</div>
                  <div class="font-normal text-sm">
                    dawdawdasdgfa adsfuiasdf adugfasugdyfg
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle
                    @click="toggleTodosPodemVotar"
                    v-model="todosPodemVotar"
                    color="blue"
                  />
                </div>
              </div>
              <div class="flex items-center justify-between w-full">
                <div class="flex flex-col mt-4">
                  <div>Habilitar emojis</div>
                  <div class="font-normal text-sm">
                    dawdawdasdgfa adsfuiasdf adugfasugdyfg
                  </div>
                </div>
                <div class="pt-5">
                  <UToggle @click="toggleEmojis" v-model="emojis" color="blue" />
                </div>
              </div>
            </div>
          </div>
          <div class="flex text-center mt-8">
            <UButton
              type="submit"
              color="indigo"
              variant="solid"
              size="lg"
              class="w-full text-xl flex justify-center"
            >
              Criar sala
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

const votingSystems = ["Fibonacci", "T-Shirt Sizes", "Standard", "Criar baralho customizado"];

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
