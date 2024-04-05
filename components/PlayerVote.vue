<template>
    <div class="mt-10 flex-col flex gap-2">
        <div class="w-28 h-40 flex-col flex rounded-lg justify-center border-8" :class="player.voted
            ? 'border-green-500 bg-green-100'
            : 'border-red-300 bg-red-100'
            ">
            <span v-if="mostrarCartas && player.voted" class="text-5xl flex justify-center"><span
                    v-if="player.vote != 0">{{ player.vote }}</span><span v-else>☕</span></span>
        </div>
        <div>
            <span class="text-2xl flex justify-center text-white">{{ player.name }}</span>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    player: Object,
    mostrarCartas: Boolean
})
</script>