<template>
    <div class="relative flex rounded-lg w-12 h-20 justify-center border-4" :class="player.voted
        ? 'border-green-500 bg-green-100'
        : 'border-red-300 bg-red-100'
        "
        style="box-shadow: 0 30px 30px -10px #222222;"
        >
        <span v-if="mostrarCartas && player.voted" class="oswald-font text-5xl flex justify-center"><span v-if="player.vote != 0">{{
        player.vote }}</span><span v-else>☕</span></span>
        <div class="absolute -bottom-8 left-1/2 transform -translate-x-1/2">
            <span class="text-sm flex justify-center text-nowrap text-white">{{ player.name || ' ' }}</span>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    player: Object,
    mostrarCartas: Boolean,
    horizontal: Boolean
})
</script>