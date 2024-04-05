<template>
    <div class="w-20 h-28 mt-4 md:mt-10 md:w-28 md:h-40 flex-col relative flex rounded-lg justify-center border-8" :class="player.voted
        ? 'border-green-500 bg-green-100'
        : 'border-red-300 bg-red-100'
        "
        style="box-shadow: 0 30px 30px -10px #222222;"
        >
        <span v-if="mostrarCartas && player.voted" class="text-5xl flex justify-center"><span v-if="player.vote != 0">{{
        player.vote }}</span><span v-else>☕</span></span>
        <div class="absolute -bottom-10 md:-bottom-12 left-1/2 transform -translate-x-1/2">
            <span class="text-lg md:text-2xl flex justify-center text-white">{{ player.name || ' ' }}</span>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    player: Object,
    mostrarCartas: Boolean
})
</script>