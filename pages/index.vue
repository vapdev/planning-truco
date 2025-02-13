<template>
  <div class="overflow-x-hidden flex flex-col justify-between antialiased atkinson-hyperlegible-mono-regular h-[100vh] bg-gray-100 text-gray-800">
    <header class="relative bg-indigo-500 w-full text-gray-100 h-24">
      <div
        class="container flex items-center justify-center h-full sm:pl-32 sm:justify-between"
      >
        <a
          href="/"
          class="relative flex items-center inline-block h-5 h-full font-black leading-none"
        >
          <span id="home" class="ml-3 text-lg"
            >Free Planning Poker<span class="text-primary-600">.</span></span
          >
        </a>
      </div>
    </header>
    <div
      class="justify-center text-gray-800 bg-gray-100 w-full overflow-hidden w-full flex mt-12"
    >
      <div class="container flex flex-col md:flex-row h-full px-8 w-full justify-around">
        <div class="flex flex-col justify-between w-full max-w-xl">
          <div>
            <div class="text-xl font-black leading-tight sm:text-2xl mb-12">
              Planejamento de sprint online grátis!
            </div>
            <p class="text-lg mb-4 font-light md:text-xl">
              O Planning Poker direto ao ponto.
            </p>
            <p class="text-lg font-light md:text-xl">
              Crie uma sala e compartilhe o link com seus colegas de equipe.
            </p>
            <p class="text-lg font-light md:text-xl">
              Todos podem votar e ver o resultado em tempo real.
            </p>
            <p class="text-lg mt-8 font-semibold md:text-xl">
              Comece agora mesmo!
            </p>
          </div>
          <div
            @click="startGame"
            class="cursor-pointer mt-10 sm:mt-0 text-black hover:bg-indigo-300 bg-indigo-400 w-full text-center inline-block w-auto px-8 py-6 mx-auto mt-0 text-2xl rounded-md sm:mt-1 font-bold"
          >
            Iniciar agora
          </div>
        </div>
        <div class="flex flex-col hidden sm:block">
          <img src="./mesa.png" alt="Planning Poker" class="rounded-lg h-[400px]" />
        </div>
      </div>
    </div>
    <footer class="px-4 md:mt-16 border-gray-200">
      <div class="py-10 text-center border-t border-gray-200">
        © 2024 <span class="text-primary-600">Codestation</span>.
      </div>
    </footer>

    <UModal
      class="z-[52]"
      :ui="{ overlay: { background: 'bg-primary-200/40' } }"
      v-model="modalCriar"
    >
      <div
        class="relative rounded-lg dark: font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-12 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer flex top-2 right-2">
          <Icon
            @click="modalCriar = false"
            class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="mb-4 text-4xl">Iniciar Planning Poker</div>
        <div class="text-sm flex flex-col gap-4">
          <div>Nome da sala:</div>
          <div class="flex w-full gap-4">
            <UInput
              color="primary"
              v-model="roomName"
              size="lg"
              class="w-full"
              placeholder="Nome da sala (Opcional)"
              />
          </div>
        </div>
        <button
          @click="userStore.startGame(roomName)"
          class="bg-[#4F46E5] mt-6 w-full md:hover:bg-primary-400 font-bold py-2 px-4 rounded"
        >
          Iniciar
        </button>
      </div>
    </UModal>
  </div>
</template>

<script setup>
const userStore = useUserStore();
const modalCriar = ref(false);

const router = useRouter();

const deck = ref([
  { value: "☕", label: "☕" },
  { value: "0", label: "0" },
  { value: "1", label: "1" },
  { value: "2", label: "2" },
  { value: "3", label: "3" },
  { value: "5", label: "5" },
  { value: "8", label: "8" },
  { value: "13", label: "13" },
  { value: "21", label: "21" },
  { value: "34", label: "34" },
]);

const roomName = ref("");
const startGame = () => {
  router.push("/new");
};
</script>

<style>
@media (max-width: 1520px) {
  .left-svg {
    display: none;
  }
}

/* small css for the mobile nav close */
#nav-mobile-btn.close span:first-child {
  transform: rotate(45deg);
  top: 4px;
  position: relative;
  background: #a0aec0;
}

#nav-mobile-btn.close span:nth-child(2) {
  transform: rotate(-45deg);
  margin-top: 0px;
  background: #a0aec0;
}
</style>
