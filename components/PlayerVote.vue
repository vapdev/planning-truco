<template>
    <div class="mt-10 flex-col flex gap-2">
        <div class="w-28 h-40 flex-col flex rounded-lg justify-center border-8" :class="player.votou
        ? 'border-green-500 bg-green-100'
        : 'border-yellow-300 bg-yellow-100'
        ">
            <span v-if="mostrarCartas && player.votou" class="text-5xl flex justify-center"><span
                    v-if="player.score != 'coffee'">{{ player.score }}</span><span class="text-7xl"
                    v-else>☕</span></span>
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