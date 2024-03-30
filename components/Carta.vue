<template>
    <div class="mt-10 text-white flex-col flex gap-2 text-5xl hover:text-black hover:text-6xl hover:scale-[1.15]">
        <div @click="votar(card.number)" :class="selectedCard == card.number ? card.class + ' -translate-y-10' + ` bg-${card.bg} text-black` : card.class
            " class="w-24 h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
            <span class="flex justify-center" v-if="card.number != 'coffee'">{{ card.number }}</span><span
                class="text-7xl" v-else>☕</span>
        </div>
    </div>
</template>

<script setup>

const props = defineProps({
    card: Object,
    selectedCard: Number,
    votar: Function
})
</script>
