<template>
    <div class="relative flex items-center rounded-lg w-12 h-20 justify-center" 
         :class="[
            player.voted ? 'border-green-500 bg-green-100' : 'border-red-300 bg-red-100',
            flipped ? 'flip' : ''
         ]" 
         style="box-shadow: 0 30px 30px -10px #222222;">
        <div v-if="player.voted && flipped" class="front absolute w-full h-full flex items-center justify-center">
            <span class="oswald-font text-black text-4xl">
                <span v-if="player.vote != -1">{{ player.vote }}</span>
                <span v-else>☕</span>
            </span>
        </div>
        <div v-else class="cardPattern absolute w-full h-full text-black  flex items-center justify-center" v-if="!player.voted || !flipped">
        </div>
        <div class="absolute -bottom-8 left-1/2 transform -translate-x-1/2">
            <span class="text-sm flex justify-center text-nowrap text-white">{{ player.name || ' ' }}</span>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    player: {
        type: Object,
        default: () => ({ voted: false, vote: 0, name: '' })
    },
    mostrarCartas: {
        type: Boolean,
        default: false
    },
    horizontal: {
        type: Boolean,
        default: false
    }
})

const { player, mostrarCartas, horizontal } = toRefs(props);
const flipped = ref(false);

watch(
    () => mostrarCartas.value,
    (newVal, oldVal) => {
        if (player.value.voted) {
            flipped.value = true;
        }
        if (oldVal && !newVal) {
            flipped.value = false;
        }
    }
)
</script>

<style scoped>
.flip {
    transform-style: preserve-3d;
    animation-duration: 0.6s;
    animation-timing-function: ease-out;
    animation-name: flip-animation;
}
.cardPattern {
    background-image: 
        repeating-linear-gradient(
            45deg,
            rgba(0, 0, 0, 0.1),
            rgba(0, 0, 0, 0.1) 7px,
            transparent 5px,
            transparent 10px
        ),
        repeating-linear-gradient(
            -45deg,
            rgba(0, 0, 0, 0.1),
            rgba(0, 0, 0, 0.1) 7px,
            transparent 5px,
            transparent 10px
        );
}
.front {
    backface-visibility: hidden;
}
.back {
    transform: rotateY(180deg);
    transform: rotateY(180deg);
    backface-visibility: hidden;
}
@keyframes flip-animation {
    0% {
        transform: rotateY(180deg);
    }

    100% {
        transform: rotateY(0deg);
    }
}
</style>