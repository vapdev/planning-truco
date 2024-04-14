<template>
    <div>
        <div class="text-white text-lg flex p-4 items-start justify-between">
            <div class="w-1/3 justify-start items-center">
                <div class="flex gap-2 items-center">
                    <div v-if="$md" class="text-sm">Copiar link da sala:</div>
                    <div @click="copyToClipboard" class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
                        <Icon size="30" name="material-symbols:content-copy" color="white" />
                    </div>
                </div>
            </div>
            <div class="flex w-1/3 justify-center items-center">
                <span class="invisible md:visible font-bold">{{ userStore.roomState.name }}</span>
            </div>
            <div class="flex w-1/3 justify-end gap-5 items-center">
                <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
                    <Icon @click="abrirModalCompartilhar" size="30" name="material-symbols:share" color="white" />
                </div>
                <div @click="modalConfig = true" class="p-1 hover:bg-gray-500 rounded-xl">
                    <Icon class="hover:cursor-pointer" size="30" name="material-symbols:settings" color="white" />
                </div>
                <div class="hover:bg-gray-500 hover:cursor-pointer rounded-xl p-1">
                    <Icon @click="emit('endGame')" size="30" name="material-symbols:exit-to-app" color="white" />
                </div>
            </div>
        </div>

        <div><span class="md:invisible font-bold w-full text-white flex justify-center">{{ userStore.roomState.name }}</span></div>

        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalShare">
            <div class="relative rounded-lg font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon @click="modalShare = false"
                        class=" md:hover:bg-gray-500 hover:cursor-pointer p-0.5 rounded-full transition-all duration-250 ease-out"
                        size="38" name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="flex flex-col gap-6 text-white">
                    <p class="text-2xl">
                        Compartilhe o link da sala
                    </p>
                    <div class="flex gap-4">
                        <UInput v-model="urlToCopy" size="lg" color="blue" class="w-full" />
                        <button @click="copyToClipboard"
                            class="outline outline-blue-500 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded">
                            Copiar
                        </button>

                    </div>
                </div>
            </div>
        </UModal>
        <!-- modal pra trocar nome -->
        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalConfig">
            <div class="relative rounded-lg font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon @click="modalConfig = false"
                        class=" md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out" size="38"
                        name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="mb-4 text-white text-4xl">Configurações</div>
                <div class="text-md flex flex-col gap-4 text-white">
                    <div>Seu nome:</div>
                    <div class="flex w-full gap-4">
                        <UInput v-model="userName" size="lg" color="blue" class="w-full" placeholder="Seu nome" />
                    </div>
                </div>
                <button @click="userStore.changeName(userName); modalConfig = false"
                    class=" bg-blue-500 w-full md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded">
                    Salvar
                </button>
            </div>
        </UModal>
    </div>
</template>

<script setup>
import { showToast } from '../composables/toast';
const userStore = useUserStore();
const modalShare = ref(false);
const modalConfig = ref(false);
const emit = defineEmits(['endGame']);
const urlToCopy = ref();
const userName = ref('');
const $md = ref(null)

onMounted(() => {
    if (localStorage.getItem('userName')) {
        userStore.name = localStorage.getItem('userName');
    }
    userName.value = userStore.name;
    urlToCopy.value = window.location.href;
    $md.value = window.matchMedia('(min-width: 768px)').matches
})

function abrirModalCompartilhar() {
    modalShare.value = true;
    copyToClipboard();
}
const copyToClipboard = () => {
    showToast({ message: 'O link da sala foi copiado para a área de transferência', position: 'top-center', offsetY: 4 })
    navigator.clipboard.writeText(window.location.href)
};
defineExpose({
    modalConfig,
    modalShare
})
</script>