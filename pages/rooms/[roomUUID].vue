<template>
  <div :key="key"
    class="wrapper atkinson-hyperlegible-mono-regular bg-[#f0f0f0] dark:bg-[#3f4146] text-gray-800 dark:text-white flex overflow-hidden">
    <div class="wrapper h-full w-full flex flex-col justify-between">
      <HeaderSala class="h-1/5" ref="headerRef" @endGame="endGame" @toggleRightPanel="toggleRightPanel" />
      <div class="flex justify-around w-full h-2/5">
        <div class="w-1/3 flex flex-col items-center"></div>
        <div class="flex w-1/3 flex-col justify-center items-center">
          <TopContainer :players="playersTop" />
          <div class="flex gap-4 justify-center items-center">
            <LeftContainer :players="playersLeft" />
            <Mesa @toggleMostrarCartas="toggleMostrarCartas" @novaRodada="novaRodada" />
            <RightContainer :players="playersRight" />
          </div>
          <BottomContainer :players="playersBottom" />
        </div>
        <div class="w-1/3 flex justify-center"></div>
      </div>
      <div class="w-full h-2/5 flex flex-col justify-end overflow-clip">
        <Transition name="slide-up">
          <Deck v-if="!userStore.roomState.showCards" :deck="deck" :selectedCard="selectedCard" :votar="votar" />
          <Stats v-else :cards="deck" />
        </Transition>
      </div>
      <EmojiHandler />
    </div>
    <Transition name="rpanel">
      <div v-if="userStore.rightPanel"
        class="rpanel bg-[#f9f9f9] flex flex-col justify-between w-[600px] px-6 py-5 max-h-[100vh] h-[100vh]">
        <div class="flex justify-between">
          <div>
            <div class="text-xl font-semibold">Issues</div>
            <div class="text-sm">{{ issues.length }} issues • {{ issuesTotalPoints }} points</div>
          </div>
        </div>

        <div class="mt-6 flex flex-col gap-4 pr-4 flex-grow overflow-auto">
          <draggable class="dragArea list-group w-full" :list="issues" @change="changeDraggable">
            <div v-for="(issue, i) in issues" :key="issue.id"
              class="bg-[#eeeeee] hover:scale-y-105 rounded-lg flex flex-col justify-between py-2 px-4 mb-2">
              <div class="flex justify-between">
                <div class="text-sm text-primary-500">#{{ i + 1 }}</div>
                <div class="text-sm">Points</div>
              </div>
              <div class="flex justify-between">
                <div class="font-semibold">{{ issue.title }}</div>
                <div class="font-semibold">{{ issue.points }}</div>
              </div>
              <a target="_blank" :href="issue.link" v-if="issue.link" class="text-sm text-blue-500 underline">{{
                issue.link }}</a>
              <div v-if="issue.description" class="text-sm">{{ issue.description }}</div>
            </div>
          </draggable>

          <UAccordion open-icon="i-heroicons-plus" close-icon="i-heroicons-minus"
            :items="[{ label: 'Add issue', defaultOpen: true, variant: 'solid', color: 'primary' }]">
            <template #item="{ item }">
              <div class="bg-[#eeeeee] rounded-md flex flex-col justify-between py-2 px-2">
                <UInput v-model="title" class="rounded-lg mb-2" placeholder="Issue title" />
                <UInput v-model="description" class="rounded-lg"
                  placeholder="Issue description or link" />
                <div class="flex justify-between mt-4">
                  <UButton variant="ghost"
                    class="dark:border-gray-700 text-gray-800 dark:text-white px-4 py-2 rounded-lg">Clean</UButton>
                  <UButton @click="handleAddTask" color="primary" class="text-gray-800 dark:text-white px-4 py-2 rounded-lg">Confirm</UButton>
                </div>
              </div>
            </template>
          </UAccordion>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { VueDraggableNext as draggable } from 'vue-draggable-next'
const { gtag } = useGtag();
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const selectedCard = ref(null);
const route = useRoute();
const headerRef = ref(null);
const userStore = useUserStore();
const deck = ref([]);
const key = ref(0);
const title = ref("");
const description = ref("");
const issueList = ref([]);

const issues = ref([]);

function toggleRightPanel() {
  userStore.rightPanel = !userStore.rightPanel;
}

function changeDraggable() {
  console.log("changeDraggable");
}

onMounted(async () => {
  userStore.userUUID = localStorage.getItem("userUUID");
  userStore.name = localStorage.getItem("userName");
  gtag("event", "join_room", { roomUUID: route.params.roomUUID });
  await userStore.loadGame(route.params.roomUUID);
  if (!userStore.name || userStore.name === "Guest") {
    headerRef.value.modalProfile = true;
  }
  deck.value = userStore.deck;
});

const issuesTotalPoints = computed(() => issues.value.reduce((acc, issue) => acc + issue.points, 0));
const computedPlayers = (condition) => computed(() => userStore.players.filter(condition));
const playersBottom = computedPlayers((_, index) => (index < 4 ? index % 4 === 0 : index % 2 === 0));
const playersTop = computedPlayers((_, index) => (index < 4 ? index % 4 === 1 : index % 2 === 1));
const playersLeft = computedPlayers((_, index) => index === 2);
const playersRight = computedPlayers((_, index) => index === 3);

const votar = (score) => {
  gtag("event", "vote", { score });
  selectedCard.value = selectedCard.value === score ? null : score;
  if (jogadorLogado.value) {
    userStore.ws.send(JSON.stringify({ type: "vote", userUUID: userStore.userUUID, roomUUID: userStore.roomUUID, vote: score }));
  }
};

const novaRodada = () => {
  gtag("event", "nova_rodada");
  fetch(`${apiUrl}/resetVotes`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ roomUUID: userStore.roomUUID }) });
};

const handleAddTask = () => {
  issues.value.push({ title: title.value, description: description.value, points: 0 });
  title.value = "";
  description.value = "";
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

const endGame = () => {
  gtag("event", "leave_room");
  if (userStore.roomUUID) {
    fetch(`${apiUrl}/leaveRoom`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ userUUID: userStore.userUUID, roomUUID: userStore.roomUUID }) });
  }
  sairDaSala();
};

const jogadorLogado = computed(() => userStore.players.find((player) => player.uuid === userStore.userUUID));
const toggleMostrarCartas = () => {
  gtag("event", "show_cards");
  fetch(`${apiUrl}/showCards`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ roomUUID: userStore.roomUUID }) });
};

onUnmounted(() => userStore.closeWsConnection());
</script>

<style>
.wrapper {
  height: 100dvh;
}

.rpanel-enter-active,
.rpanel-leave-active {
  transition: width 0.3s ease-in-out;
}

.rpanel-enter-from,
.rpanel-leave-to {
  width: 0;
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

/* width */
.rpanel ::-webkit-scrollbar {
  width: 10px;
}

/* Track */
.rpanel ::-webkit-scrollbar-track {
  background: #f1f1f1;
}

/* Handle */
.rpanel ::-webkit-scrollbar-thumb {
  background: #d4d4d4;
}

/* Handle on hover */
.rpanel ::-webkit-scrollbar-thumb:hover {
  background: #a1a1a1;
}
</style>
