<template>
  <div v-if="modelValue" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in" @click.self="close">
    <div class="w-full max-w-2xl">
      <!-- Header com botão fechar -->
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-extrabold bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
          {{ $t("settings") }}
        </h2>
        <button 
          @click="close"
          class="p-2 rounded-full hover:bg-white/10 transition-all duration-300 group"
        >
          <svg class="w-7 h-7 text-white/70 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
      <div class="backdrop-blur-sm bg-white/10 border border-white/20 rounded-2xl p-6 shadow-2xl animate-slide-up max-h-[90vh] overflow-y-auto flex flex-col gap-6">
        <div class="space-y-3">
          <div class="text-white/90 font-medium">{{  $t("roomName")  }}</div>
          <div class="flex w-full">
            <UInput
              v-model="roomName"
              size="lg"
              variant="outline"
              color="gray"
              class="w-full font-normal rounded-xl modern-input"
              :input-class="'text-white bg-transparent border-white/20 focus:border-blue-400 focus:ring-blue-400/50'"
              :placeholder="$t('roomName')"
            />
          </div>
        </div>
        
        <div class="glass-card p-4 rounded-xl">
          <div class="flex items-center gap-4 justify-between w-full">
            <div class="flex flex-col">
              <div class="font-semibold text-white">{{  $t("revealCardsTitle")  }}</div>
              <div class="font-normal text-sm text-white/70">
                {{  $t("revealCardsDescription")  }}
              </div>
            </div>
            <div>
              <UToggle
                v-model="autoShowCards"
                color="primary"
                class="modern-toggle"
              />
            </div>
          </div>
        </div>

        <div class="space-y-3">
          <div class="text-white/90 font-medium">{{ $t("language") }}</div>
          <USelectMenu
            v-model="language"
            value-attribute="id"
            class="modern-select"
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
            <div class="font-semibold">{{ $t('enableFunFeatures') }}</div>
            <div class="font-normal text-sm">
              {{ $t('enableFunFeaturesDescription') }}
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
            <div>{{ row.admin ? $t("yes") : $t("no") }}</div>
          </template>
          <!-- <template #actions-data="{ row }">
                <div
                  @click="userStore.kickPlayer(row.userUUID)"
                  class="hover:bg-red-500 hover:cursor-pointer rounded-xl p-1"
                >
                  <Icon size="30" name="material-symbols:delete-outline" color="red" />
                </div>
              </template> -->
        </div>
      </div>

        <div class="flex gap-3 justify-center mt-8">
          <button 
            @click="handleSaveConfig"
            class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-500 hover:from-blue-600 hover:to-indigo-600 text-white font-bold rounded-xl transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30"
          >
            {{ $t("save") }}
          </button>
          <button 
            @click="close"
            class="px-6 py-3 bg-white/10 hover:bg-white/20 text-white font-semibold rounded-xl transition-all duration-300 border border-white/20"
          >
            {{ $t("close") }}
          </button>
        </div>
      </div>
    </div>
</template>

<script setup>
const { setLocale, locale, t } = useI18n();
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
    userStore.changeRoomName(roomName.value, {
      error: t("error"),
      success: t("roomNameChangedSuccess")
    });
  }
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value, {
      error: t("error"),
      success: t("nameChangedSuccess")
    });
  }
  if (autoShowCards.value !== userStore.roomState.autoShowCards) {
    changeVirarAutomatico();
  }
  close();
}
</script>

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slide-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 0.3s ease-out;
}

.animate-slide-up {
  animation: slide-up 0.4s ease-out;
}

.glass-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.modern-input input {
  background: rgba(255, 255, 255, 0.05) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  border-radius: 12px !important;
  color: white !important;
  transition: all 0.3s ease !important;
}

.modern-input input:focus {
  border-color: rgb(168, 85, 247) !important;
  box-shadow: 0 0 0 3px rgba(168, 85, 247, 0.1) !important;
  background: rgba(255, 255, 255, 0.08) !important;
}

.modern-input input::placeholder {
  color: rgba(255, 255, 255, 0.5) !important;
}

.modern-select :deep(button) {
  background: rgba(255, 255, 255, 0.05) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  border-radius: 12px !important;
  color: white !important;
  transition: all 0.3s ease !important;
}

.modern-select :deep(button:hover) {
  background: rgba(255, 255, 255, 0.08) !important;
  border-color: rgb(168, 85, 247) !important;
}

.modern-toggle :deep(.bg-primary-500) {
  background-color: rgb(168, 85, 247) !important;
}
</style>
