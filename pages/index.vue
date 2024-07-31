<template>
  <div class="overflow-x-hidden antialiased rubik-font bg-gray-800">
    <!-- Header Section -->
    <header class="relative bg-indigo-900 w-full text-white h-24">
      <div
        class="container flex items-center justify-center h-full max-w-6xl px-8 mx-auto sm:justify-between xl:px-0"
      >
        <a
          href="/"
          class="relative flex items-center inline-block h-5 h-full font-black leading-none"
        >
          <span id="home" class="ml-3 text-xl text-white"
            >Free Planning Poker<span class="text-indigo-600">.</span></span
          >
        </a>

        <nav
          id="nav"
          :class="{ hidden: !isNavOpen }"
          class="absolute top-0 left-0 z-[53] flex flex-col items-center justify-between w-full h-64 pt-5 mt-24 text-sm border-t border-gray-600 md:w-auto md:flex-row md:h-24 lg:text-base md:mt-0 md:border-none md:py-0 md:flex md:relative"
        >
          <div
            class="flex flex-col block w-full font-medium border-t border-gray-600 md:hidden"
          >
            <a
              @click="startGame"
              class="relative inline-block w-full px-5 py-3 text-sm leading-none text-center text-white bg-indigo-600 cursor-pointer fold-bold"
            >
              Criar novo jogo
            </a>
          </div>
        </nav>

        <div
          class="flex-col items-center justify-center hidden w-full pb-8 mt-48 border-b border-gray-600 md:relative md:w-auto md:bg-transparent md:border-none md:mt-0 md:flex-row md:p-0 md:items-end md:flex md:justify-between"
        >
          <a
            @click="startGame"
            nav
            class="relative z-40 hover:bg-indigo-700 hover:scale-105 inline-block w-auto h-full px-5 py-3 text-sm font-bold leading-none cursor-pointer transition-all transition duration-100 duration-300 border-indigo-600 border-2 rounded shadow-md fold-bold sm:w-full"
            >Criar novo jogo</a
          >
        </div>

        <div
          @click="toggleNav"
          :class="{ close: isNavOpen }"
          id="nav-mobile-btn"
          class="absolute top-0 right-0 z-50 block w-6 mt-8 mr-10 cursor-pointer select-none md:hidden sm:mt-10"
        >
          <span
            class="block w-full h-1 mt-2 duration-200 transform bg-gray-800 rounded-full sm:mt-1"
          ></span>
          <span
            class="block w-full h-1 mt-1 duration-200 transform bg-gray-800 rounded-full"
          ></span>
        </div>
      </div>
    </header>
    <!-- End Header Section-->

    <!-- BEGIN HERO SECTION -->
    <div
      class="items-center justify-center bg-gray-800 w-full overflow-x-hidden w-full flex"
    >
      <div
        class="container flex flex-col items-center justify-between h-full max-w-6xl px-8 mx-auto xl:px-0"
      >
        <div
          class="flex flex-col items-center w-full max-w-xl pt-10 md:pt-32 text-center"
        >
          <h1
            class="mb-4 text-3xl font-black leading-tight text-gray-200 sm:text-6xl xl:mb-8"
          >
            Comece a planejar sua sprint
          </h1>
          <p class="pr-0 mb-8 text-base text-gray-200 sm:text-lg xl:text-xl">
            O Free Planning Poker é uma ferramenta totalmente gratuita para auxiliar times
            ágeis a estimar o esforço de desenvolvimento de suas tarefas.
          </p>
          <a
            href="#_"
            @click="startGame"
            class="relative hover:scale-105 hover:bg-indigo-500 self-start w-full text-center inline-block w-auto px-8 py-4 mx-auto mt-0 text-3xl font-bold text-white bg-indigo-600 border-t border-gray-600 rounded-md shadow-xl sm:mt-1 fold-bold"
            >Criar novo jogo!</a
          >
          <div class="flex-col hidden mt-12 sm:flex lg:mt-24"></div>
        </div>
      </div>
    </div>
    <!-- HERO SECTION END -->

    <!-- BEGIN FEATURES SECTION -->
    <div id="features" class="relative w-full px-8 pt-10 border-gray-600 bg-gray-800">
      <div
        class="container flex flex-col items-center justify-between h-full max-w-6xl mx-auto"
      >
        <h3
          class="px-5 mt-2 text-3xl font-black leading-tight text-center text-gray-200 sm:mt-0 sm:px-0 sm:text-6xl"
        >
          Como utilizar o Free Planning Poker
        </h3>
        <div class="flex flex-col w-full mt-0 lg:flex-row sm:mt-10">
          <div class="w-full max-w-md p-4 mx-auto mb-0 sm:mb-16 lg:mb-0 lg:w-1/3">
            <div
              class="relative flex flex-col items-center justify-center w-full h-full p-10 md:p-20 mr-5 rounded-lg"
            >
              <svg
                class="absolute w-full h-full text-gray-100 fill-gray-600"
                viewBox="0 0 377 340"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g>
                  <g>
                    <path
                      d="M342.8 3.7c24.7 14 18.1 75 22.1 124s18.6 85.8 8.7 114.2c-9.9 28.4-44.4 48.3-76.4 62.4-32 14.1-61.6 22.4-95.9 28.9-34.3 6.5-73.3 11.1-95.5-6.2-22.2-17.2-27.6-56.5-47.2-96C38.9 191.4 5 151.5.9 108.2-3.1 64.8 22.7 18 61.8 8.7c39.2-9.2 91.7 19 146 16.6 54.2-2.4 110.3-35.6 135-21.6z"
                    />
                  </g>
                </g>
              </svg>
              <!-- FEATURE Icon 1 -->
              <span class="relative text-[4rem] text-white">1</span>
              <h4 class="relative text-lg text-gray-200 font-bold text-[#111827]">
                Crie um novo jogo
              </h4>
              <p class="relative mt-2 text-base text-center text-gray-200">
                Inicie um novo jogo de Planning Poker para sua equipe.
              </p>
            </div>
          </div>

          <div class="w-full max-w-md p-4 mx-auto mb-0 sm:mb-16 lg:mb-0 lg:w-1/3">
            <div
              class="relative flex flex-col items-center justify-center w-full h-full p-10 md:p-20 mr-5 rounded-lg"
            >
              <svg
                class="absolute w-full h-full text-gray-100 fill-gray-600"
                viewBox="0 0 358 372"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g>
                  <g>
                    <path
                      d="M315.7 6.5c30.2 15.1 42.6 61.8 41.5 102.5-1.1 40.6-15.7 75.2-24.3 114.8-8.7 39.7-11.3 84.3-34.3 107.2-23 22.9-66.3 23.9-114.5 30.7-48.2 6.7-101.3 19.1-123.2-4.1-21.8-23.2-12.5-82.1-21.6-130.2C30.2 179.3 2.6 141.9.7 102c-2-39.9 21.7-82.2 57.4-95.6 35.7-13.5 83.3 2.1 131.2 1.7 47.9-.4 96.1-16.8 126.4-1.6z"
                    />
                  </g>
                </g>
              </svg>
              <!-- FEATURE Icon 2 -->
              <span class="relative text-[4rem] text-white">2</span>
              <h4 class="relative mt-2 text-lg font-bold text-gray-200">
                Compartilhe o link
              </h4>
              <p class="relative mt-2 text-base text-center text-gray-200">
                Envie o link do jogo para os membros do seu time para que eles possam
                participar.
              </p>
            </div>
          </div>

          <div class="w-full max-w-md p-4 mx-auto mb-16 lg:mb-0 lg:w-1/3">
            <div
              class="relative flex flex-col items-center justify-center w-full h-full p-10 md:p-20 mr-5 rounded-lg"
            >
              <svg
                class="absolute w-full h-full text-gray-100 fill-gray-600"
                viewBox="0 0 378 410"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g>
                  <g>
                    <path
                      d="M305.9 14.4c23.8 24.6 16.3 84.9 26.6 135.1 10.4 50.2 38.6 90.3 43.7 137.8 5.1 47.5-12.8 102.4-50.7 117.4-37.9 15.1-95.7-9.8-151.7-12.2-56.1-2.5-110.3 17.6-130-3.4-19.7-20.9-4.7-82.9-11.5-131.2C25.5 209.5-3 174.7 1.2 147c4.2-27.7 41-48.3 75-69.6C110.1 56.1 141 34.1 184 17.5c43.1-16.6 98.1-27.7 121.9-3.1z"
                    />
                  </g>
                </g>
              </svg>
              <!-- FEATURE Icon 3 -->
              <span class="relative text-[4rem] text-white">3</span>
              <h4 class="relative mt-2 text-lg font-bold text-gray-200">Planeje</h4>
              <p class="relative mt-2 text-base text-center text-gray-200">
                Utilize o Planning Poker para organizar e estimar as tarefas da sua
                sprint.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="px-4 md:mt-16 text-white border-gray-600 bg-gray-800">
      <div class="py-10 text-center text-gray-200 border-t border-gray-600">
        © 2024 <span class="text-indigo-600">Codestation</span>. Todos os direitos
        reservados.
      </div>
    </footer>

    <!-- a little JS for the mobile nav button -->
    <UModal
      class="z-[52]"
      :ui="{ overlay: { background: 'bg-blue-200/40' } }"
      v-model="modalCriar"
    >
      <div
        class="relative rounded-lg dark:text-white rubik-font font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-12 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer text-white flex top-2 right-2">
          <Icon
            @click="modalCriar = false"
            class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="mb-4 text-4xl">Iniciar Planning Poker</div>
        <div class="text-md flex flex-col gap-4">
          <div>Nome da sala:</div>
          <div class="flex w-full gap-4">
            <UInput
              color="blue"
              v-model="roomName"
              size="lg"
              class="w-full"
              placeholder="Nome da sala (Opcional)"
            />
          </div>
        </div>
        <button
          @click="userStore.startGame(roomName)"
          class="bg-[#4F46E5] mt-6 w-full md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded"
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

const isNavOpen = ref(false);

const toggleNav = () => {
  isNavOpen.value = !isNavOpen.value;
};
onMounted(() => {
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
});

const roomName = ref("");
const startGame = () => {
  modalCriar.value = true;
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
