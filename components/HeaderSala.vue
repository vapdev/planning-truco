<template>
    <div class="text-white text-xl flex p-4 justify-between">
        <div class="w-1/3 justify-start items-center">
            Copiar link da sala:
            <Icon size="36" name="material-symbols-light:content-copy" color="white" />
        </div>
        <div class="flex w-1/3 justify-center items-center">
            <span>Nome da sala: <span class="font-bold">{{ userStore.roomUUID }}</span></span>
        </div>
        <div class="flex w-1/3 justify-end gap-5 items-center">
            <Icon size="36" name="material-symbols-light:settings" color="white" />
            <Icon @click="emit('endGame')" size="36" name="material-symbols-light:exit-to-app" color="white" />
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();
const emit = defineEmits(['endGame']);
</script>