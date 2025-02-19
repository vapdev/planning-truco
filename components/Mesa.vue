<template>
    <div style="height: 136px" class="justify-center items-center flex flex-wrap w-full mx-4">
        <div class="md:w-64 w-52 bg-primary-200 h-28 poker-table rounded-xl flex justify-center items-center dark:bg-primary-600">
            <div v-if="!userStore.roomState.showCards">
                <UButton :disabled="userStore.noVotes" @click="emit('toggleMostrarCartas')" color="primary" 
                    class="font-bold button-poker py-2 px-4 rounded w-50 bg-primary-600 dark:bg-primary-400 hover:bg-primary-400">
                    <span class="dark:text-white">{{ $t("revealVotes") }}</span>
                </UButton>
            </div>
            <div v-if="userStore.roomState.showCards">
                <UButton @click="emit('novaRodada')" color="primary" class="button-poker bg-primary-600 dark:bg-primary-400 hover:bg-primary-400 w-50 font-bold py-2 px-4 rounded">
                    <span class="dark:text-white">{{ $t("startNewVoting") }}</span>
                </UButton>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>

<style>
.poker-table {
    border-radius: 25px;
}
.button-poker {
    border-radius: 20px;
}
</style>