<template>
  <div v-if="modelValue" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in" @click.self="close">
    <div class="w-full max-w-lg">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-extrabold bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
          {{ $t("profile") }}
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
      <div class="backdrop-blur-sm bg-white/10 border border-white/20 rounded-2xl p-6 shadow-2xl animate-slide-up max-h-[90vh] overflow-y-auto">
        <div class="text-white/90 mb-3 font-medium">{{  $t("yourName")  }}</div>
        <div class="flex w-full">
          <UInput
            v-model="userName"
            size="lg"
            variant="outline"
            color="gray"
            class="w-full font-normal rounded-xl modern-input"
            :input-class="'text-white bg-transparent border-white/20 focus:border-blue-400 focus:ring-blue-400/50'"
            :placeholder="$t('yourName')"
          />
        </div>
        <div class="flex gap-3 justify-center mt-8">
          <button
            @click="handleSaveName"
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
  </div>
</template>

<script setup>
const { gtag } = useGtag();
const { t } = useI18n();
const userStore = useUserStore();
const userName = ref("");

onMounted(() => {
  if (localStorage.getItem("userName")) {
    userStore.name = localStorage.getItem("userName");
  }
  userName.value = userStore.name;
});

function handleSaveName() {
  gtag("event", "save_name");
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value, {
      error: t("error"),
      success: t("nameChangedSuccess")
    });
  }
  close();
}

const props = defineProps({
  modelValue: Boolean,
});
const emit = defineEmits(["update:modelValue", "close"]);
const close = () => {
  emit("update:modelValue", false);
};
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
</style>