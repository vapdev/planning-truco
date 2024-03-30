<template>
    <!-- Card 0 -->
    <div @click="votar(0)"
        :class="selectedCard == 0 ? 'sm:hover:bg-green-100 border-green-200 sm:-translate-y-10 bg-green-100 text-black' : 'sm:hover:bg-green-100 border-green-200 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">☕</span>
    </div>
    <!-- Card 1 -->
    <div @click="votar(1)"
        :class="selectedCard == 1 ? 'sm:hover:bg-green-200 border-green-300 sm:-translate-y-10 bg-green-200 text-black' : 'sm:hover:bg-green-200 border-green-300 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">1</span>
    </div>
    <!-- Card 2 -->
    <div @click="votar(2)"
        :class="selectedCard == 2 ? 'sm:hover:bg-green-300 border-green-400 sm:-translate-y-10 bg-green-300 text-black' : 'sm:hover:bg-green-300 border-green-400 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">2</span>
    </div>
    <!-- Card 3 -->
    <div @click="votar(3)"
        :class="selectedCard == 3 ? 'sm:hover:bg-yellow-100 border-yellow-200 sm:-translate-y-10 bg-yellow-100 text-black' : 'sm:hover:bg-yellow-100 border-yellow-200 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">3</span>
    </div>
    <!-- Card 5 -->
    <div @click="votar(5)"
        :class="selectedCard == 5 ? 'sm:hover:bg-yellow-200 border-yellow-300 sm:-translate-y-10 bg-yellow-200 text-black' : 'sm:hover:bg-yellow-200 border-yellow-300 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">5</span>
    </div>
    <!-- Card 8 -->
    <div @click="votar(8)"
        :class="selectedCard == 8 ? 'sm:hover:bg-yellow-300 border-yellow-400 sm:-translate-y-10 bg-yellow-300 text-black' : 'sm:hover:bg-yellow-300 border-yellow-400 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">8</span>
    </div>
    <!-- Card 13 -->
    <div @click="votar(13)"
        :class="selectedCard == 13 ? 'sm:hover:bg-red-100 border-red-200 sm:-translate-y-10 bg-red-100 text-black' : 'sm:hover:bg-red-100 border-red-200 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">13</span>
    </div>
    <!-- Card 21 -->
    <div @click="votar(21)"
        :class="selectedCard == 21 ? 'sm:hover:bg-red-200 border-red-300 sm:-translate-y-10 bg-red-200 text-black' : 'sm:hover:bg-red-200 border-red-300 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">21</span>
    </div>
    <!-- Card 34 -->
    <div @click="votar(34)"
        :class="selectedCard == 34 ? 'sm:hover:bg-red-300 border-red-400 sm:-translate-y-10 bg-red-300 text-black' : 'sm:hover:bg-red-300 border-red-400 text-white'"
        class="text-5xl sm:hover:text-black sm:hover:text-6xl sm:sm:hover:scale-[1.15] w-16 h-24 sm:w-24 sm:h-32 flex-col flex rounded-lg justify-center cursor-pointer border-gray-400 border-4">
        <span class="flex justify-center">34</span>
    </div>
</template>

<script setup>
const props = defineProps({
    selectedCard: Number,
    votar: Function
})
</script>