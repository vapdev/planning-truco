<template>
  <div>
    <div class="text-lg flex p-4 md:p-6 md:px-12 items-center justify-between">
      <!-- <div class="w-1/3 justify-start items-center">
        <div class="flex gap-2 items-end">
          <UButton @click="copyToClipboard" class="p-2" color="primary">
            <span class="text-md text-white font-semibold">{{ $t("invite") }}</span>
            <Icon size="20" name="material-symbols:person-add-outline" color="#f1f1f1" />
          </UButton>
        </div>
      </div> -->
      <div class="flex w-1/3 justify-start items-center">
        <div class="bg-gray-300 dark:bg-gray-800 rounded-full flex sm:gap-5 px-4 py-2">
          <div class="flex items-center gap-2">
            <div class="hover:bg-gray-400 dark:hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
              <Icon @click="modalProfile = true" size="30" name="material-symbols:person-outline"
                :color="isDarkMode ? '#FFFFF0' : '#3f4146'" />
            </div>
            <div>
              <span class="text-sm md:text-md text-gray-800 dark:text-white font-semibold">{{ userStore.name }}</span>
            </div>
          </div>
          <UButton variant="ghost" @click="copyToClipboard" class="invisible md:visible p-2 ml-8" color="primary">
            <span class="text-md text-gray-800 dark:text-white font-semibold">{{ $t("invite") }}</span>
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <div v-if="userStore.roomState.name" class="invisible md:visible bg-gray-300 dark:bg-gray-800 rounded-full px-4 py-2">
          <span class="font-bold dark:text-white text-gray-800">{{ userStore.roomState.name }}</span>
        </div>
      </div>
      <div class="flex w-1/3 justify-end items-center">
        <div class="bg-gray-300 dark:bg-gray-800 rounded-full flex sm:gap-5 px-4 py-2">
          <div class="hover:bg-gray-400 rounded-xl p-1 relative">
            <Icon @click="toggleColorPickerModal" size="30" ref="refColorPickerIcon" class="hover:cursor-pointer"
              name="material-symbols:palette-outline" :color="isDarkMode ? '#FFFFF0' : '#3f4146'" />
            <ModalColorPicker ref="refColorPickerModal" v-if="showColorPickerModal" />
          </div>
          <div class="hover:bg-gray-400 dark:hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
            <Icon @click="toggleDarkMode" size="30" :name="userStore.isDarkMode
              ? 'material-symbols:light-mode-outline'
              : 'material-symbols:dark-mode-outline'
              " :color="isDarkMode ? '#FFFFF0' : '#3f4146'" />
          </div>
          <div @click="modalConfig = true" class="p-1 hover:bg-gray-400 dark:hover:bg-gray-500 rounded-xl">
            <Icon class="hover:cursor-pointer" size="30" name="material-symbols:settings-outline"
              :color="isDarkMode ? '#FFFFF0' : '#3f4146'" />
          </div>
          <!-- <div class="hover:bg-gray-400 dark:hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
          <Icon @click="emit('endGame')" size="30" name="material-symbols:exit-to-app"
            :color="isDarkMode ? '#FFFFF0' : '#3f4146'" />
        </div> -->
          <div class="hover:bg-gray-400 dark:hover:bg-gray-500  hover:cursor-pointer rounded-xl p-1">
            <Icon @click="emit('toggleRightPanel')" size="30" name="material-symbols:right-panel-close"
              :color="isDarkMode ? '#FFFFF0' : '#3f4146'" v-if="rightPanel" />
            <Icon @click="emit('toggleRightPanel')" size="30" name="material-symbols:right-panel-open"
              :color="isDarkMode ? '#FFFFF0' : '#3f4146'" v-else />
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
const userStore = useUserStore();
const { rightPanel } = storeToRefs(userStore);
const modalShare = ref(false);
const modalConfig = ref(false);
const modalProfile = ref(false);
const emit = defineEmits(["endGame", "toggleDarkMode", "toggleRightPanel"]);
const urlToCopy = ref();
const $md = ref(null);
import { onClickOutside } from "@vueuse/core";

const refColorPickerModal = ref(null);
const refColorPickerIcon = ref(null);
onClickOutside(
  refColorPickerModal,
  (event) => {
    showColorPickerModal.value = !showColorPickerModal.value;
  },
  { ignore: [refColorPickerIcon] }
);

const showColorPickerModal = ref(false);

const isDarkMode = computed(() => userStore.isDarkMode);

onMounted(() => {
  urlToCopy.value = window.location.href;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const toggleColorPickerModal = () => {
  showColorPickerModal.value = !showColorPickerModal.value;
};

function toggleDarkMode() {
  document.body.classList.toggle("dark");
  document.documentElement.classList.toggle("dark");
  userStore.toggleDarkMode();
  emit("toggleDarkMode");
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
