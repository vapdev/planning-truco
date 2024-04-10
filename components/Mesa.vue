<template>
    <div class="justify-center flex flex-wrap w-full gap-10 mx-8 mt-4">
        <div class="w-64 h-24 rounded-xl flex justify-center items-center bg-gray-400 m-10 mx-auto">
            <div v-if="!userStore.roomState.autoShowCards && !userStore.roomState.showCards" class="text-red-500">
                <button @click="emit('toggleMostrarCartas')"
                    class="text-white font-bold py-2 px-4 rounded w-50 bg-blue-500 hover:bg-blue-400">
                    <span>Revelar votos</span>
                </button>
            </div>
            <div v-if="userStore.roomState.showCards">
                <button @click="emit('novaRodada')"
                    class="w-50 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded bg-blue-500">
                    <span>Iniciar nova votação</span>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>