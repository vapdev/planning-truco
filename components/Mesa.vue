<template>
    <div style="height: 136px" class="justify-center items-center flex flex-wrap w-full mx-4">
        <div
            class="md:w-64 w-52 bg-gradient-to-br from-purple-500/80 via-pink-500/70 to-purple-600/80 backdrop-blur-sm h-28 poker-table flex justify-center items-center border border-white/20 shadow-2xl shadow-purple-500/30">
            <div v-if="!userStore.roomState.showCards" class="animate-pulse-subtle">
                <UButton :disabled="userStore.noVotes" @click="emit('toggleMostrarCartas')" color="primary"
                    class="font-bold button-poker py-3 px-6 rounded-xl w-50 bg-gradient-to-r from-emerald-500 to-blue-500 hover:from-emerald-400 hover:to-blue-400 transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30 border-none">
                    <span class="text-white font-semibold">{{ $t("revealVotes") }}</span>
                </UButton>
            </div>
            <div v-if="userStore.roomState.showCards" class="animate-bounce-subtle">
                <UButton @click="emit('novaRodada')" color="primary"
                    class="button-poker bg-gradient-to-r from-blue-500 to-emerald-500 hover:from-blue-400 hover:to-emerald-400 w-50 font-bold py-3 px-6 rounded-xl transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30 border-none">
                    <span class="text-white font-semibold">{{ $t("startNewVoting") }}</span>
                </UButton>
            </div>
        </div>
    </div>
</template>

<script setup>
const userStore = useUserStore();

const emit = defineEmits(['toggleMostrarCartas', 'novaRodada']);
</script>

<style scoped>
@keyframes pulse-subtle {

    0%,
    100% {
        opacity: 1;
    }

    50% {
        opacity: 0.8;
    }
}

@keyframes bounce-subtle {

    0%,
    100% {
        transform: translateY(0);
    }

    50% {
        transform: translateY(-2px);
    }
}

.animate-pulse-subtle {
    animation: pulse-subtle 2s ease-in-out infinite;
}

.animate-bounce-subtle {
    animation: bounce-subtle 1s ease-in-out infinite;
}

.poker-table {
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    position: relative;
    overflow: hidden;
}

.poker-table::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(45deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
    pointer-events: none;
}

.button-poker {
    border-radius: 12px;
    border: none !important;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.button-poker:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none !important;
}
</style>