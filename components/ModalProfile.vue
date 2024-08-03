<template>
  <UModal @close="close" :ui="{ overlay: { background: 'bg-primary-200/40' } }" :model-value="modelValue">
    <div
      class="dark:text-white text-gray-800 relative rounded-lg font-bold dark:bg-[#3f4146] bg-[#F9F9F9] p-6 flex flex-col gap-6"
    >
      <div class="absolute cursor-pointer flex top-2 right-2">
        <Icon
          @click="close"
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
</template>

<script setup>
const userStore = useUserStore();
const userName = ref("");

onMounted(() => {
  if (localStorage.getItem("userName")) {
    userStore.name = localStorage.getItem("userName");
  }
  userName.value = userStore.name;
});

function handleSaveName() {
  if (userName.value !== userStore.name) {
    userStore.changeName(userName.value);
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