<template>
  <div>
    <div class="text-lg flex p-4  items-start justify-between">
      <div class="w-1/3 justify-start items-center">
        <div class="flex gap-2 items-end">
          <UButton @click="abrirModalCompartilhar" class="p-2" color="primary">
            <span class="text-md text-white font-semibold">Convidar</span>
            <Icon size="20" name="material-symbols:person-add-outline" color="#f1f1f1" />
          </UButton>
        </div>
      </div>
      <div class="flex w-1/3 justify-center items-center">
        <span class="invisible md:visible font-bold">{{ userStore.roomState.name }}</span>
      </div>
      <div class="flex w-1/3 justify-end gap-3 sm:gap-5 items-center">
        <div class="hover:bg-gray-500 rounded-xl p-1 relative">
          <Icon
            @click="toggleColorPickerModal"
            size="30"
            class="hover:cursor-pointer"
            name="material-symbols:palette-outline"
            :color="isDarkMode ? 'white' : '#3f4146'"
          />
          <!-- Modal de Color Picker -->
          <div
            v-if="showColorPickerModal"
            class="absolute top-full p-1 mt-2 w-[9.3rem] bg-white dark:bg-gray-800 rounded-lg shadow-lg z-10"
          >
            <div class="flex flex-wrap gap-2 p-1">
              <div
                v-for="color in colorsCaroussel"
                @click="changeColor(color)"
                :class="[`bg-${color}-400`, 'w-5 h-5 rounded-md cursor-pointer']"
              ></div>
            </div>
          </div>
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
            @click="modalName = true"
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

    <UModal :ui="{ overlay: { background: 'bg-primary-200/40' } }" v-model="modalShare">
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
              color="primary"
              size="lg"
              class="w-full"
            />
            <UButton
              @click="copyToClipboard"
              class="dark:text-white md:hover:bg-primary-500 font-bold py-2 px-4 rounded text-lg"
              color="primary"
            >
              Copiar link de convite
            </UButton>
          </div>
        </div>
      </div>
    </UModal>
    <ModalConfig v-model="modalConfig" />
    <UModal :ui="{ overlay: { background: 'bg-primary-200/40' } }" v-model="modalName">
      <div
        class="dark:text-white text-gray-800 relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-6 flex flex-col gap-6"
      >
        <div class="absolute cursor-pointer flex top-2 right-2">
          <Icon
            @click="modalName = false"
            class="md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out"
            size="38"
            name="material-symbols:close-small-rounded"
          ></Icon>
        </div>
        <div class="mb-2 text-3xl dark:text-white">Perfil</div>
        <div class="text-md flex flex-col">
          <div>Seu nome:</div>
          <div class="flex w-full mt-1">
            <UInput
              v-model="userName"
              size="lg"
              variant="outline"
              color="gray"
              class="w-full"
              :inputClass="userStore.isDarkMode ? 'text-white' : 'text-gray-800'"
              placeholder="Seu nome"
            />
          </div>
          <button
            @click="handleSaveName"
            class="bg-primary-500 w-full md:hover:bg-primary-400 font-bold py-2 px-4 rounded mt-6"
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
const $md = ref(null);


const tailwindColors = {
  red: {
    50: '#fef2f2',
    100: '#fee2e2',
    200: '#fecaca',
    300: '#f87171',
    400: '#ef4444',
    500: '#dc2626',
    600: '#b91c1c',
    700: '#991b1b',
    800: '#7f1d1d',
    900: '#641e16'
  },
  rose: {
    50: '#fff1f2',
    100: '#ffe4e6',
    200: '#fecdd3',
    300: '#fda4af',
    400: '#fb7185',
    500: '#f43f5e',
    600: '#e11d48',
    700: '#be123c',
    800: '#9f1239',
    900: '#721e37'
  },
  orange: {
    50: '#fff7ed',
    100: '#ffedd5',
    200: '#fed7aa',
    300: '#fdba74',
    400: '#fb923c',
    500: '#f97316',
    600: '#ea580c',
    700: '#c2410c',
    800: '#9a3412',
    900: '#7c2d12'
  },
  amber: {
    50: '#fffbeb',
    100: '#fef3c7',
    200: '#fde68a',
    300: '#fcd34d',
    400: '#fbbf24',
    500: '#f59e0b',
    600: '#d97706',
    700: '#b45309',
    800: '#92400e',
    900: '#78350f'
  },
  yellow: {
    50: '#fefce8',
    100: '#fef9c3',
    200: '#fef08a',
    300: '#fde047',
    400: '#facc15',
    500: '#eab308',
    600: '#ca8a04',
    700: '#a16207',
    800: '#854d0e',
    900: '#713f12'
  },
  lime: {
    50: '#f7fee7',
    100: '#ecfccb',
    200: '#d9f99d',
    300: '#bef264',
    400: '#a3e635',
    500: '#84cc16',
    600: '#65a30d',
    700: '#4d7c0f',
    800: '#3f6212',
    900: '#365314'
  },
  green: {
    50: '#f0fdf4',
    100: '#dcfce7',
    200: '#bbf7d0',
    300: '#86efac',
    400: '#4ade80',
    500: '#22c55e',
    600: '#16a34a',
    700: '#15803d',
    800: '#166534',
    900: '#14532d'
  },
  emerald: {
    50: '#ecfdf5',
    100: '#d1fae5',
    200: '#a7f3d0',
    300: '#6ee7b7',
    400: '#34d399',
    500: '#10b981',
    600: '#059669',
    700: '#047857',
    800: '#065f46',
    900: '#064e3b'
  },
  cyan: {
    50: '#ecfeff',
    100: '#cffafe',
    200: '#a5f3fc',
    300: '#67e8f9',
    400: '#22d3ee',
    500: '#06b6d4',
    600: '#0891b2',
    700: '#0e7490',
    800: '#155e75',
    900: '#164e63'
  },
  sky: {
    50: '#f0f9ff',
    100: '#e0f2fe',
    200: '#bae6fd',
    300: '#91d5ff',
    400: '#60a5fa',
    500: '#3b82f6',
    600: '#2563eb',
    700: '#1d4ed8',
    800: '#1e40af',
    900: '#1e3a8a'
  },
  blue: {
    50: '#eff6ff',
    100: '#dbeafe',
    200: '#bfdbfe',
    300: '#93c5fd',
    400: '#60a5fa',
    500: '#3b82f6',
    600: '#2563eb',
    700: '#1d4ed8',
    800: '#1e40af',
    900: '#1e3a8a'
  },
  indigo: {
    50: '#eef2ff',
    100: '#e0e7ff',
    200: '#c7d2fe',
    300: '#a5b4fc',
    400: '#818cf8',
    500: '#6366f1',
    600: '#4f46e5',
    700: '#4338ca',
    800: '#3730a3',
    900: '#312e81'
  },
  violet: {
    50: '#f5f3ff',
    100: '#ede9fe',
    200: '#ddd6fe',
    300: '#c4b5fd',
    400: '#a855f7',
    500: '#9333ea',
    600: '#7e22ce',
    700: '#6b21a8',
    800: '#581c87',
    900: '#4c1d95'
  },
  purple: {
    50: '#faf5ff',
    100: '#f3e8ff',
    200: '#e9d5ff',
    300: '#d8b4fe',
    400: '#c084fc',
    500: '#a855f7',
    600: '#9333ea',
    700: '#7e22ce',
    800: '#6b21a8',
    900: '#581c87'
  },
  fuchsia: {
    50: '#fdf4ff',
    100: '#fae8ff',
    200: '#f5d0fe',
    300: '#f0abfc',
    400: '#e879f9',
    500: '#d946ef',
    600: '#c026d3',
    700: '#a21caf',
    800: '#86198f',
    900: '#701a75'
  },
  pink: {
    50: '#fdf2f8',
    100: '#fce7f3',
    200: '#fbbfce',
    300: '#f9a8d4',
    400: '#f472b6',
    500: '#ec4899',
    600: '#db2777',
    700: '#be185d',
    800: '#9d174d',
    900: '#831843'
  }
};

const colorsCaroussel = [
  "red",
  "rose",
  "orange",
  "amber",
  "yellow",
  "lime",
  "green",
  "emerald",
  "cyan",
  "blue",
  "indigo",
  "violet",
  "purple",
  "fuchsia",
  "pink",
];

const showColorPickerModal = ref(false);

const color = ref("blue");

const changeColor = (color) => {
  const colorHex = tailwindColors[color];
  if (colorHex) {
    Object.keys(colorHex).forEach((shade) => {
      document.documentElement.style.setProperty(`--color-primary-${shade}`, colorHex[shade]);
    });
    localStorage.setItem("themeColor", color); 
  } else {
    console.error('Color not found:', color);
  }
};

const isDarkMode = computed(() => userStore.isDarkMode);

onMounted(() => {
  const savedColor = localStorage.getItem("themeColor");
  if (savedColor && tailwindColors[savedColor]) {
    changeColor(savedColor);
  }
  const darkMode = localStorage.getItem("nuxt-color-mode");
  if (darkMode === "dark") {
    document.body.classList.add("dark");
  }

  if (localStorage.getItem("userName")) {
    userStore.name = localStorage.getItem("userName");
  }
  userName.value = userStore.name;
  urlToCopy.value = window.location.href;
  $md.value = window.matchMedia("(min-width: 768px)").matches;
});

const toggleColorPickerModal = () => {
  showColorPickerModal.value = !showColorPickerModal.value;
};

function handleSaveName() {
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value);
  }
  modalName.value = false;
}

function toggleDarkMode() {
  document.body.classList.toggle("dark");
  const isDark = document.body.classList.contains("dark");
  localStorage.setItem("nuxt-color-mode", isDark ? "dark" : "light");
  userStore.isDarkMode = isDark;
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
  modalName
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
