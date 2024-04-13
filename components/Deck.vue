<template>
    <div class="flex flex-col w-full">
        <div class="flex justify-center mb-4 text-white">Vote abaixo 👇</div>
        <div  class="md:justify-center overflow-x-auto gap-4 items-center pb-4  pt-8 w-full flex">
            <div class="flex gap-4">
                <div v-for="(card, index) in cards" :key="index" @click="votar(card.value)"
                    :class="card.defaultClass, selectedCard === card.value ? card.selectedClass : ''"
                    style="box-shadow: 0 10px 30px -10px #222222;"
                    class="text-3xl oswald-font md:hover:text-black md:hover:scale-[1.1] w-12 h-20 flex items-center rounded-lg justify-center cursor-pointer">
                    <div class="flex justify-center w-24">{{ card.label }}</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    selectedCard: Number,
    votar: Function
})

const cards = ref([
    { value: -1, label: '☕', selectedClass: '-translate-y-6', defaultClass: 'border text-black' },
    { value: 0, label: '0', selectedClass: '-translate-y-6', defaultClass: 'bg-green-50 text-black' },
    { value: 1, label: '1', selectedClass: '-translate-y-6', defaultClass: 'bg-green-100 text-black' },
    { value: 2, label: '2', selectedClass: '-translate-y-6', defaultClass: 'bg-green-200 text-black' },
    { value: 3, label: '3', selectedClass: '-translate-y-6', defaultClass: ' bg-green-300 text-black' },
    { value: 5, label: '5', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-100 text-black' },
    { value: 8, label: '8', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-200 text-black' },
    { value: 13, label: '13', selectedClass: '-translate-y-6', defaultClass: 'bg-yellow-300 text-black' },
    { value: 21, label: '21', selectedClass: '-translate-y-6', defaultClass: 'bg-red-200 text-black' },
    { value: 34, label: '34', selectedClass: '-translate-y-6', defaultClass: 'bg-red-300 text-black' }
])
</script>