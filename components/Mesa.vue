<template>
    <div style="height: 136px" class="justify-center items-center flex flex-wrap w-full mx-4">
        <div class="md:w-64 w-52 h-24 rounded-xl flex justify-center items-center bg-gray-300 dark:bg-gray-500">
            <div v-if="!userStore.roomState.autoShowCards && !userStore.roomState.showCards">
                <UButton :disabled="userStore.noVotes" @click="emit('toggleMostrarCartas')" color="blue" 
                    class="font-bold py-2 px-4 rounded w-50 bg-blue-600 hover:bg-blue-500 dark:bg-blue-600">
                    <span class="dark:text-white">Revelar votos</span>
                </UButton>
            </div>
            <div v-if="userStore.roomState.showCards">
                <UButton @click="emit('novaRodada')" color="blue" class="bg-blue-600 hover:bg-blue-500 dark:bg-blue-600 w-50 font-bold py-2 px-4 rounded">
                    <span class="dark:text-white">Iniciar nova votação</span>
                </UButton>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>
