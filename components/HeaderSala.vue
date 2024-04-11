<template>
    <div class="text-white text-lg flex p-4 justify-between">
        <div class="w-1/3 justify-start items-center">
            <div class="flex gap-2 items-center">
                <div class="text-xs font-bold">Copiar link da sala:</div>
                <div @click="copyToClipboard" class="hover:bg-gray-500 rounded-xl">
                    <Icon class="hover:cursor-pointer" size="34" name="material-symbols-light:content-copy"
                        color="white" />
                </div>
            </div>
        </div>
        <div class="flex w-1/3 justify-center items-center">
            <span class="font-bold">{{ userStore.roomState.name }}</span>
        </div>
        <div class="flex w-1/3 justify-end gap-5 items-center">
            <div class="hover:bg-gray-500 rounded-xl">
                <Icon @click="abrirModalCompartilhar" class="hover:cursor-pointer" size="34" name="material-symbols-light:share"
                    color="white" />
            </div>
            <div @click="modalConfig = true" class="hover:bg-gray-500 rounded-xl">
                <Icon class="hover:cursor-pointer" size="34" name="material-symbols-light:settings" color="white" />
            </div>
            <div class="hover:bg-gray-500 rounded-xl">
                <Icon class="hover:cursor-pointer" @click="emit('endGame')" size="34"
                    name="material-symbols-light:exit-to-app" color="white" />
            </div>
        </div>
        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalShare">
            <div class="relative rounded-lg font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon  @click="modalShare = false"
                        class=" md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out" size="38"
                        name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="flex flex-col gap-6 text-white">
                    <p class="text-2xl">
                        Compartilhe o link da sala
                    </p>
                    <div class="flex gap-4">
                        <input class="border-2 outline outline-blue-500 text-gray-800 h-10 rounded pl-2 w-full"
                            :value="urlToCopy" />
                        <button @click="copyToClipboard"
                            class="outline outline-blue-500 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded">
                            Copiar
                        </button>

                    </div>
                </div>
            </div>
        </UModal>
    </div>
</template>

<script setup>
import { showToast } from '../composables/toast';
const userStore = useUserStore();
const modalShare = ref(false);
const modalConfig = ref(false);
const modal = ref(true);
const emit = defineEmits(['endGame']);
const urlToCopy = ref();
onMounted(() => {
    urlToCopy.value = window.location.href;
})
function abrirModalCompartilhar() {
    modalShare.value = true;
    copyToClipboard();
}
const copyToClipboard = () => {
    showToast({ message: 'O link da sala foi copiado para a área de transferência', position: 'top-center', offsetY: 4 })
    navigator.clipboard.writeText(window.location.href)
        .then(() => {
            console.log('URL copied to clipboard');
        })
        .catch(err => {
            console.error('Failed to copy URL: ', err);
        });
};
</script>