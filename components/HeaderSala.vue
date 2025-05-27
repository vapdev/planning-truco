<template>
  <div>
    <div class="text-lg flex p-4 md:p-6 md:px-12 items-center justify-between">
      <div class="flex w-1/3 justify-start items-center">
        <div class="bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-xl flex sm:gap-5 px-4 py-3 shadow-lg">
          <div class="flex items-center gap-3">
            <div class="hover:bg-white/10 hover:scale-110 hover:cursor-pointer rounded-xl p-2 transition-all duration-300">
              <Icon @click="modalProfile = true" size="28" name="material-symbols:person-outline"
                class="text-white/80 hover:text-white" />
            </div>
            <div>
              <span class="text-sm md:text-md text-white font-semibold">{{ userStore.name }}</span>
            </div>
          </div>
          <UButton variant="ghost" @click="copyToClipboard" class="invisible md:visible px-4 py-2 ml-4 bg-gradient-to-r from-purple-500/20 to-pink-500/20 hover:from-purple-500/30 hover:to-pink-500/30 rounded-xl border border-white/10 transition-all duration-300 hover:scale-105" color="primary">
            <span class="text-sm text-white font-semibold">{{ $t("invite") }}</span>
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <div v-if="userStore.roomState.name" class="invisible md:visible bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-xl px-6 py-3 shadow-lg">
          <span class="font-bold text-white bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">{{ userStore.roomState.name }}</span>
        </div>
      </div>
      <div class="flex w-1/3 justify-end items-center">
        <div class="bg-slate-800/50 backdrop-blur-sm border border-white/10 rounded-xl flex sm:gap-3 px-4 py-3 shadow-lg">
            <LanguageSelector />
          <div @click="modalConfig = true" class="p-2 hover:bg-white/10 hover:scale-110 rounded-xl transition-all duration-300">
            <Icon class="hover:cursor-pointer text-white/80 hover:text-white" size="28" name="material-symbols:settings-outline" />
          </div>
          <!-- <div class="hover:bg-white/10 hover:scale-110 hover:cursor-pointer rounded-xl p-2 transition-all duration-300">
            <Icon @click="emit('toggleRightPanel')" size="28" name="material-symbols:right-panel-close"
              class="text-white/80 hover:text-white" v-if="rightPanel" />
            <Icon @click="emit('toggleRightPanel')" size="28" name="material-symbols:right-panel-open"
              class="text-white/80 hover:text-white" v-else />
          </div> -->
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
