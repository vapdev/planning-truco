<template>
    <div style="height: 136px" class="justify-center items-center flex flex-wrap w-full mx-4">
        <div class="md:w-64 w-52 h-24 rounded-xl flex justify-center items-center bg-gray-300 dark:bg-gray-500">
            <div v-if="!userStore.roomState.showCards">
                <UButton :disabled="userStore.noVotes" @click="emit('toggleMostrarCartas')" color="primary" 
                    class="font-bold py-2 px-4 rounded w-50 bg-primary-600 hover:bg-primary-500 dark:bg-primary-600">
                    <span class="dark:text-white">{{ $t("revealVotes") }}</span>
                </UButton>
            </div>
            <div v-if="userStore.roomState.showCards">
                <UButton @click="emit('novaRodada')" color="primary" class="bg-primary-600 hover:bg-primary-500 dark:bg-primary-600 w-50 font-bold py-2 px-4 rounded">
                    <span class="dark:text-white">{{ $t("startNewRound") }}</span>
                </UButton>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>
