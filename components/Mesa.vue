<template>
    <div class="justify-center flex flex-wrap w-full mx-4">
        <div class="md:w-64 w-44 h-24 rounded-xl flex justify-center items-center bg-gray-400">
            <div v-if="!userStore.roomState.autoShowCards && !userStore.roomState.showCards" class="text-red-500">
                <button @click="emit('toggleMostrarCartas')"
                    class="text-white font-bold py-2 px-4 rounded w-50 bg-blue-500 hover:bg-blue-400">
                    <span>Revelar votos</span>
                </button>
            </div>
            <div v-if="userStore.roomState.showCards">
                <button @click="emit('novaRodada')"
                    class="w-32 md:w-50 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded bg-blue-500">
                    Iniciar nova votação
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>