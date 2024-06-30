<template>
  <div>
    <div class="text-lg flex p-4 items-start justify-between">
      <div class="w-1/3 justify-start items-center">
        <div class="flex gap-2 items-end">
          <UButton @click="abrirModalCompartilhar" class="p-2" color="blue">
            <span class="text-md text-white font-semibold">Convidar</span>
            <Icon size="20" name="material-symbols:person-add-outline" color="#f1f1f1" />
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <span class="invisible md:visible font-bold">{{ userStore.roomState.name }}</span>
      </div>
      <div class="flex w-1/3 justify-end gap-5 items-center">
        <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
          <Icon
            @click="toggleDarkMode"
            size="30"
            :name="
              userStore.isDarkMode
                ? 'material-symbols:dark-mode-outline'
                : 'material-symbols:light-mode-outline'
            "
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
        </div>
        <div @click="modalConfig = true" class="p-1 hover:bg-gray-500 rounded-xl">
          <Icon
            class="hover:cursor-pointer"
            size="30"
            name="material-symbols:settings-outline"
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
        </div>
        <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
          <Icon
            @click="emit('endGame')"
            size="30"
            name="material-symbols:exit-to-app"
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
        </div>
      </div>
    </div>

    <div>
      <span class="md:invisible font-bold w-full flex justify-center">{{
        userStore.roomState.name
      }}</span>
    </div>

    <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalShare">
      <div
        class="dark:text-white relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-12 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer flex top-2 right-2">
          <Icon
            @click="modalShare = false"
            class="md:hover:bg-gray-500 hover:cursor-pointer p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="flex flex-col gap-6">
          <p class="text-2xl dark:text-white">Compartilhe o link da sala</p>
          <div class="flex flex-col gap-6">
            <UInput
              inputClass="dark:text-white text-gray-800"
              disabled
              v-model="urlToCopy"
              color="blue"
              size="lg"
              class="w-full"
            />
            <UButton
              @click="copyToClipboard"
              class="dark:text-white md:hover:bg-blue-500 font-bold py-2 px-4 rounded text-lg"
              color="blue"
            >
              Copiar link de convite
            </UButton>
          </div>
        </div>
      </div>
    </UModal>
    <!-- modal pra trocar nome -->
    <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalConfig">
      <div
        class="dark:text-white text-gray-800 relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-12 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer flex top-2 right-2">
          <Icon
            @click="modalConfig = false"
            class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="mb-4 text-4xl dark:text-white">Configurações</div>
        <div class="text-md flex flex-col">
          <div>Seu nome:</div>
          <div class="flex w-full mt-1">
            <UInput
              v-model="userName"
              size="lg"
              variant="outline"
              color="blue"
              class="w-full"
              :inputClass="userStore.isDarkMode ? 'text-white' : 'text-gray-800'"
              placeholder="Seu nome"
            />
          </div>
          <div class="mt-4">Nome da sala:</div>
          <div class="flex w-full mt-1 mb-4">
            <UInput
              v-model="roomName"
              size="lg"
              variant="outline"
              color="blue"
              class="w-full"
              :inputClass="userStore.isDarkMode ? 'text-white' : 'text-gray-800'"
              placeholder="Nome da sala"
            />
          </div>
          <div class="mt-4">Revelar cartas automaticamente</div>
          <div class="flex w-full mt-1 mb-4">
            <UToggle
              @click="toggleVirarAutomatico"
              v-model="userStore.roomState.autoShowCards"
              color="blue"
            />
          </div>
          <div class="mt-4">Lista de usuários</div>
          <UTable
            :columns="[
              {
                key: 'name',
                label: 'Nome de usuário',
              },
              {
                key: 'admin',
                label: 'Mediador',
              },
              //{
              //  key: 'actions',
              //  label: 'Ações',
              //},
            ]"
            :rows="userStore.roomState.players"
          >
            <template #name-data="{ row }">
              <div>{{ row.name }}</div>
            </template>
            <template #admin-data="{ row }">
              <div>{{ row.admin ? "Sim" : "Não" }}</div>
            </template>
            <!-- <template #actions-data="{ row }">
              <div
                @click="userStore.kickPlayer(row.userUUID)"
                class="hover:bg-red-500 hover:cursor-pointer rounded-xl p-1"
              >
                <Icon size="30" name="material-symbols:delete-outline" color="red" />
              </div>
            </template> -->
          </UTable>
        </div>
        <button
          @click="handleSaveConfig"
          class="bg-blue-500 w-full md:hover:bg-blue-400 font-bold py-2 px-4 rounded"
        >
          Salvar
        </button>
      </div>
    </UModal>
    <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalName">
      <div
        class="dark:text-white text-gray-800 relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-12 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer flex top-2 right-2">
          <Icon
            @click="modalName = false"
            class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="mb-4 text-4xl dark:text-white">Planning {{ userStore.roomState.name }}</div>
        <div class="text-md flex flex-col">
          <div>Seu nome:</div>
          <div class="flex w-full mt-1">
            <UInput
              v-model="userName"
              size="lg"
              variant="outline"
              color="blue"
              class="w-full"
              :inputClass="userStore.isDarkMode ? 'text-white' : 'text-gray-800'"
              placeholder="Seu nome"
            />
          </div>
          <button
            @click="handleSaveName"
            class="bg-blue-500 w-full md:hover:bg-blue-400 font-bold py-2 px-4 rounded mt-6"
          >
            Salvar
          </button>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { showToast } from "../composables/toast";
const userStore = useUserStore();
const modalShare = ref(false);
const modalConfig = ref(false);
const modalName = ref(false);
const emit = defineEmits(["endGame"]);
const urlToCopy = ref();
const userName = ref("");
const roomName = ref("");
const $md = ref(null);

const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;

const isDarkMode = computed(() => userStore.isDarkMode);

onMounted(() => {
  if (localStorage.getItem("userName")) {
    userStore.name = localStorage.getItem("userName");
  }
  userName.value = userStore.name;
  urlToCopy.value = window.location.href;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const toggleVirarAutomatico = () => {
  fetch(`${apiUrl}/autoShowCards`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      roomUUID: userStore.roomUUID,
    }),
  });
};

function handleSaveConfig() {
  if (roomName.value !== userStore.roomState.name) {
    userStore.changeRoomName(roomName.value);
  }
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value);
  }
  modalConfig.value = false;
}

function handleSaveName() {
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value);
  }
  modalName.value = false;
}

watch(modalConfig, (newVal) => {
  if (newVal) {
    userName.value = userStore.name;
    roomName.value = userStore.roomState.name;
  }
});

function toggleDarkMode() {
  document.body.classList.toggle("dark");
  userStore.isDarkMode = !userStore.isDarkMode;
}

function abrirModalCompartilhar() {
  // modalShare.value = true;
  copyToClipboard();
}
const copyToClipboard = () => {
  showToast({
    message: "O link da sala foi copiado para a área de transferência",
    position: "top-center",
    offsetY: 4,
  });
  navigator.clipboard.writeText(window.location.href);
};
defineExpose({
  modalConfig,
  modalShare,
  modalName,
});
</script>
