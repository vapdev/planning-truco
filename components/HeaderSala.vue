<template>
  <div>
    <div class="text-lg flex p-4 items-start justify-between">
      <div class="w-1/3 justify-start items-center">
        <div class="flex gap-2 items-end">
          <UButton @click="copyToClipboard" class="p-2" color="primary">
            <span class="text-md text-white font-semibold">Convidar</span>
            <Icon size="20" name="material-symbols:person-add-outline" color="#f1f1f1" />
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <span class="invisible md:visible font-bold">{{ userStore.roomState.name }}</span>
      </div>
      <div class="flex w-1/3 justify-end sm:gap-5 items-center">
        <div class="hover:bg-gray-500 rounded-xl p-1 relative">
          <Icon
            @click="toggleColorPickerModal"
            size="30"
            ref="refColorPickerIcon"
            class="hover:cursor-pointer"
            name="material-symbols:palette-outline"
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
          <ModalColorPicker ref="refColorPickerModal" v-if="showColorPickerModal" />
        </div>
        <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
          <Icon
            @click="toggleDarkMode"
            size="30"
            :name="
              userStore.isDarkMode
                ? 'material-symbols:light-mode-outline'
                : 'material-symbols:dark-mode-outline'
            "
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
        </div>
        <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
          <Icon
            @click="modalProfile = true"
            size="30"
            name="material-symbols:person-outline"
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
    <ModalConfig v-model="modalConfig" />
    <ModalProfile v-model="modalProfile" />
  </div>
</template>

<script setup>
import { showToast } from "../composables/toast";
const userStore = useUserStore();
const modalShare = ref(false);
const modalConfig = ref(false);
const modalProfile = ref(false);
const emit = defineEmits(["endGame"]);
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
  const darkMode = localStorage.getItem("nuxt-color-mode");
  if (darkMode === "dark") {
    document.body.classList.add("dark");
  }
  urlToCopy.value = window.location.href;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const toggleColorPickerModal = () => {
  showColorPickerModal.value = !showColorPickerModal.value;
};

function toggleDarkMode() {
  document.body.classList.toggle("dark");
  const isDark = document.body.classList.contains("dark");
  localStorage.setItem("nuxt-color-mode", isDark ? "dark" : "light");
  userStore.isDarkMode = isDark;
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
