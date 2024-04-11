<template>
    <div class="text-white text-lg flex p-4 justify-between">
        <div class="w-1/3 justify-start items-center">
            <div class="flex gap-2 items-center">
                <div>Copiar link da sala:</div>
                <div @click="copyToClipboard" class="hover:bg-gray-500 rounded-xl">
                    <Icon class="hover:cursor-pointer" size="34" name="material-symbols-light:content-copy"
                        color="white" />
                </div>
            </div>
        </div>
        <div class="flex w-1/3 justify-center items-center">
            <span class="font-bold">{{ userStore.roomUUID }}</span>
        </div>
        <div class="flex w-1/3 justify-end gap-5 items-center">
            <div class="hover:bg-gray-500 rounded-xl">
                <Icon class="hover:cursor-pointer" size="34" name="material-symbols-light:settings" color="white" />
            </div>
            <div class="hover:bg-gray-500 rounded-xl">
                <Icon class="hover:cursor-pointer" @click="emit('endGame')" size="34"
                    name="material-symbols-light:exit-to-app" color="white" />
            </div>
        </div>
    </div>
</template>

<script setup>
import { showToast } from '../composables/toast';
const userStore = useUserStore();
const modal = ref (true);
const emit = defineEmits(['endGame']);
const copyToClipboard = () => {
    showToast({ message: 'O link da sala foi copiado para a área de transferência' , position: 'top-center'})
    navigator.clipboard.writeText(window.location.href)
        .then(() => {
            console.log('URL copied to clipboard');
        })
        .catch(err => {
            console.error('Failed to copy URL: ', err);
        });
};
</script>