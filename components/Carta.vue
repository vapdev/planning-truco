<template>

    <div v-for="(card, index) in cards" :key="index" @click="votar(card.value)"
        :class="selectedCard == card.value ? card.selectedClass : card.defaultClass"
        class="text-5xl md:hover:text-black md:hover:text-6xl md:md:hover:scale-[1.15] w-16 h-24 md:w-24 md:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">{{ card.label }}</span>
    </div>
</template>

<script setup>
const props = defineProps({
    selectedCard: Number,
    votar: Function
})

const cards = ref([
    { value: 0, label: '☕', selectedClass: 'md:hover:bg-green-100 border-green-200 md:-translate-y-10 bg-green-100 text-black', defaultClass: 'md:hover:bg-green-100 border-green-200 text-white' },
    { value: 1, label: '1', selectedClass: 'md:hover:bg-green-200 border-green-300 md:-translate-y-10 bg-green-200 text-black', defaultClass: 'md:hover:bg-green-200 border-green-300 text-white' },
    { value: 2, label: '2', selectedClass: 'md:hover:bg-green-300 border-green-400 md:-translate-y-10 bg-green-300 text-black', defaultClass: 'md:hover:bg-green-300 border-green-400 text-white' },
    { value: 3, label: '3', selectedClass: 'md:hover:bg-yellow-100 border-yellow-200 md:-translate-y-10 bg-yellow-100 text-black', defaultClass: 'md:hover:bg-yellow-100 border-yellow-200 text-white' },
    { value: 5, label: '5', selectedClass: 'md:hover:bg-yellow-200 border-yellow-300 md:-translate-y-10 bg-yellow-200 text-black', defaultClass: 'md:hover:bg-yellow-200 border-yellow-300 text-white' },
    { value: 8, label: '8', selectedClass: 'md:hover:bg-yellow-300 border-yellow-400 md:-translate-y-10 bg-yellow-300 text-black', defaultClass: 'md:hover:bg-yellow-300 border-yellow-400 text-white' },
    { value: 13, label: '13', selectedClass: 'md:hover:bg-red-100 border-red-200 md:-translate-y-10 bg-red-100 text-black', defaultClass: 'md:hover:bg-red-100 border-red-200 text-white' },
    { value: 21, label: '21', selectedClass: 'md:hover:bg-red-200 border-red-300 md:-translate-y-10 bg-red-200 text-black', defaultClass: 'md:hover:bg-red-200 border-red-300 text-white' },
    { value: 34, label: '34', selectedClass: 'md:hover:bg-red-300 border-red-400 md:-translate-y-10 bg-red-300 text-black', defaultClass: 'md:hover:bg-red-300 border-red-400 text-white' }
])
</script>