<template>
    <div v-for="(card, index) in cards" :key="index" @click="votar(card.value)"
        :class="selectedCard == card.value ? card.selectedClass : card.defaultClass"
        style="box-shadow: 0 10px 30px -10px #222222;"
        class="text-3xl md:hover:text-black md:hover:text-6xl md:hover:scale-[1.15] w-24 h-32 flex items-center rounded-lg justify-center cursor-pointer border-gray-400 border-4" >
        <div class="flex justify-center w-24">{{ card.label }}</div>
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