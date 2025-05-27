<template>
  <UModal @close="close" :ui="{ overlay: { background: 'bg-slate-900/60 backdrop-blur-sm' } }" :model-value="modelValue">
    <div
      class="text-white atkinson-hyperlegible-mono-regular relative rounded-xl font-bold bg-slate-900/80 backdrop-blur-sm border border-white/10 p-6 flex flex-col gap-6 animate-fade-in"
    >
      <div class="absolute cursor-pointer flex top-2 right-2">
        <Icon
          @click="close"
          class="hover:bg-white/10 hover:scale-110 p-0.5 rounded-full transition-all duration-300 ease-out text-white/70 hover:text-white"
          size="38"
          name="material-symbols:close-small-rounded"
        ></Icon>
      </div>
      <div class="mb-2 text-3xl bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent font-extrabold">
        {{  $t("profile")  }}
      </div>
      <div class="text-md flex flex-col">
        <div class="text-white/90 mb-3 font-medium">{{  $t("yourName")  }}</div>
        <div class="flex w-full">
          <UInput
            v-model="userName"
            size="lg"
            variant="outline"
            color="gray"
            class="w-full font-normal rounded-xl modern-input"
            :input-class="'text-white bg-transparent border-white/20 focus:border-purple-400 focus:ring-purple-400/50'"
            :placeholder="$t('yourName')"
          />
        </div>
        <button
          @click="handleSaveName"
          class="bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-400 hover:to-pink-400 w-full font-bold py-3 px-6 rounded-xl mt-6 transition-all duration-300 ease-out hover:scale-105 hover:shadow-lg hover:shadow-purple-500/30 text-white"
        >
          {{  $t("save")  }}
        </button>
      </div>
    </div>
  </UModal>
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