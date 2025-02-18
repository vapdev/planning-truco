<template>
  <UModal
    @close="close"
    :ui="{ overlay: { background: 'bg-primary-200/40' } }"
    :model-value="modelValue"
  >
    <div
      class="dark:text-white text-gray-800 atkinson-hyperlegible-mono-regular relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-6 flex flex-col gap-6"
    >
      <div class="absolute cursor-pointer flex top-2 right-2">
        <Icon
          @click="close"
          class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
          size="38"
          name="material-symbols:close-small-rounded"
        ></Icon>
      </div>
      <div class="mb-2 text-3xl dark:text-white">{{  $t("settings")  }}</div>
      <div class="text-md flex flex-col">
        <div>{{  $t("roomName")  }}</div>
        <div class="flex w-full mt-2 mb-4">
          <UInput
            v-model="roomName"
            size="lg"
            variant="outline"
            color="gray"
            class="w-full font-normal border-2 border-gray-300 rounded-lg"
            :inputClass="userStore.isDarkMode ? 'text-white' : 'text-gray-800'"
            :placeholder="$t('roomName')"
          />
        </div>
        <div class="flex items-center gap-4 mb-2 justify-between w-full">
          <div class="flex flex-col mt-4">
            <div class="font-semibold">{{  $t("revealCardsTitle")  }}</div>
            <div class="font-normal text-sm">
              {{  $t("revealCardsDescription")  }}
            </div>
          </div>
          <div class="pt-5">
            <UToggle
              v-model="autoShowCards"
              color="primary"
              class="dark:border-2 dark:border-gray-600"
            />
          </div>
        </div>
        <div class="mt-4 mb-2">{{ $t("language") }}</div>
        <USelectMenu
          v-model="language"
          value-attribute="id"
          :options="[
            { label: 'English', id: 'en' },
            { label: 'Español', id: 'es' },
            { label: 'Português', id: 'pt' },
            { label: 'Français', id: 'fr' },
            { label: 'Deutsch', id: 'de' },
            { label: 'Italiano', id: 'it' },
            { label: 'Polski', id: 'pl' },
            { label: 'Русский', id: 'ru' },
            { label: 'العربية', id: 'ar' },
            { label: '中文', id: 'zh' },
            { label: '日本語', id: 'ja' },
            { label: '한국어', id: 'ko' },
          ]"
          size="lg"
          color="gray"
          class="w-full font-normal border-2 border-gray-300 rounded-lg"
        ></USelectMenu>
        <!-- <div class="flex items-center gap-4 justify-between w-full">
          <div class="flex flex-col mt-4">
            <div class="font-semibold">Todos podem revelar os votar</div>
            <div class="font-normal text-sm">
              Define se todos jogadores podem revelar os votos ou apenas o facilitador
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
        </div>
        <div class="flex items-center gap-4 justify-between w-full">
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
        <!-- <div class="mt-4">Lista de usuários</div>
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
        <!-- </UTable> -->
      </div>
      <button
        @click="handleSaveConfig"
        class="bg-primary-500 w-full md:hover:bg-primary-400 font-bold py-2 px-4 rounded"
      >
        Salvar
      </button>
    </div>
  </UModal>
</template>

<script setup>
const { setLocale, locale } = useI18n();
const userStore = useUserStore();

const roomName = ref("");
const userName = ref("");
const props = defineProps({
  modelValue: Boolean,
});
const emit = defineEmits(["update:modelValue", "close"]);
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const autoShowCards = ref(false);
const { gtag } = useGtag();

const language = ref(locale.value);

const close = () => {
  emit("update:modelValue", false);
};

onMounted(() => {
  roomName.value = userStore.roomState.name;
  userName.value = userStore.name;
  autoShowCards.value = userStore.roomState.autoShowCards;
});

const changeVirarAutomatico = () => {
  fetch(`${apiUrl}/autoShowCards`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      roomUUID: userStore.roomUUID,
      autoShowCards: autoShowCards.value,
    }),
  });
};

function handleSaveConfig() {
  gtag("event", "save_config");
  if (language.value !== locale.value) {
    setLocale(language.value);
  }
  if (roomName.value !== userStore.roomState.name) {
    userStore.changeRoomName(roomName.value);
  }
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value);
  }
  if (autoShowCards.value !== userStore.roomState.autoShowCards) {
    changeVirarAutomatico();
  }
  close();
}
</script>
