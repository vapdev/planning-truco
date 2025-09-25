<template>
  <div>
    <div class="text-base sm:text-lg flex p-2 sm:p-4 md:p-6 md:px-12 items-center justify-between">
      <div class="flex w-1/3 justify-start items-center">
        <div class="bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-lg sm:rounded-xl flex gap-2 sm:gap-5 px-2 sm:px-4 py-2 sm:py-3 shadow-lg">
          <div class="flex items-center gap-1 sm:gap-3">
            <div class="hover:bg-white/10 hover:scale-110 hover:cursor-pointer rounded-lg sm:rounded-xl p-1 sm:p-2 transition-all duration-300">
              <Icon @click="modalProfile = true" size="20" name="material-symbols:person-outline"
                class="text-white/80 hover:text-white sm:w-7 sm:h-7" />
            </div>
            <div class="hidden sm:block">
              <span class="text-xs sm:text-sm md:text-md text-white font-semibold">{{ userStore.name }}</span>
            </div>
          </div>
          <UButton variant="ghost" @click="copyToClipboard" class="hidden sm:flex px-2 sm:px-4 py-1 sm:py-2 ml-2 sm:ml-4 bg-gradient-to-r from-purple-500/20 to-pink-500/20 hover:from-purple-500/30 hover:to-pink-500/30 rounded-lg sm:rounded-xl border border-white/10 transition-all duration-300 hover:scale-105" color="primary">
            <span class="text-xs sm:text-sm text-white font-semibold">{{ $t("invite") }}</span>
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <div v-if="userStore.roomState.name" class="hidden md:block bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-xl px-3 sm:px-6 py-2 sm:py-3 shadow-lg">
          <span class="font-bold text-sm sm:text-base text-white bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">{{ userStore.roomState.name }}</span>
        </div>
      </div>
      <div class="flex w-1/3 justify-end items-center relative z-[1000]">
        <div class="bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-lg sm:rounded-xl flex gap-1 sm:gap-3 px-2 sm:px-4 py-2 sm:py-3 shadow-lg relative z-[1001]">
            <LanguageSelector />
          <div @click="modalConfig = true" class="p-1 sm:p-2 hover:bg-white/10 hover:scale-110 rounded-lg sm:rounded-xl transition-all duration-300">
            <Icon class="hover:cursor-pointer text-white/80 hover:text-white" size="20" name="material-symbols:settings-outline" />
          </div>
          <div @click="exitRoom" class="p-1 sm:p-2 hover:bg-red-500/20 hover:scale-110 rounded-lg sm:rounded-xl transition-all duration-300 group">
            <Icon class="hover:cursor-pointer text-white/80 group-hover:text-red-300" size="20" name="material-symbols:logout" />
          </div>
        </div>
      </div>
    </div>
    <ModalConfig v-if="modalConfig" v-model="modalConfig" />
    <ModalProfile v-if="modalProfile" v-model="modalProfile" />
  </div>
</template>

<script setup>
import { showToast } from "../composables/toast";
const { t } = useI18n();
const userStore = useUserStore();
const { rightPanel } = storeToRefs(userStore);
const modalShare = ref(false);
const modalConfig = ref(false);
const modalProfile = ref(false);
const emit = defineEmits(["endGame", "toggleRightPanel"]);
const urlToCopy = ref();
const $md = ref(null);

onMounted(() => {
  urlToCopy.value = window.location.href;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const copyToClipboard = () => {
  showToast({
    message: t("linkCopied"),
    position: "top-center",
    offsetY: 4,
  });
  navigator.clipboard.writeText(window.location.href);
};

const exitRoom = () => {
  emit("endGame");
};

defineExpose({
  modalProfile,
});
</script>

<style scoped>
.hover\:bg-gray-500:hover {
  background-color: #6b7280;
}

.hover\:cursor-pointer:hover {
  cursor: pointer;
}
</style>
