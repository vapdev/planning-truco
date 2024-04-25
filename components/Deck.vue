<template>
    <div class="flex flex-col justify-end w-full">
        <div class="flex justify-center ">Vote abaixo 👇</div>
        <div  class="md:justify-center overflow-x-auto gap-4 items-center pb-4  pt-8 w-full flex">
            <div class="flex gap-4">
                <div v-for="(card, index) in cards" :key="index" @click="votar(card.value)"
                    :class="card.defaultClass, selectedCard === card.value ? card.selectedClass : ''"
                    :style="userStore.isDarkMode ? 'box-shadow: 0 10px 30px -10px #222222;' : 'box-shadow: 0 10px 30px -10px #;'"
                    class="text-3xl border-2 border-[#a1a7b4] oswald-font md:hover:text-black md:hover:scale-[1.1] w-12 h-20 flex items-center rounded-lg justify-center cursor-pointer">
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

const userStore = useUserStore();

const cards = ref([
    { value: -1, label: '☕', selectedClass: '-translate-y-6', defaultClass: '!border-2 text-black' },
    { value: 0, label: '0', selectedClass: '-translate-y-6', defaultClass: 'bg-green-50 dark:border-none text-black' },
    { value: 1, label: '1', selectedClass: '-translate-y-6', defaultClass: 'bg-green-100 dark:border-none text-black' },
    { value: 2, label: '2', selectedClass: '-translate-y-6', defaultClass: 'bg-green-200 dark:border-none text-black' },
    { value: 3, label: '3', selectedClass: '-translate-y-6', defaultClass: ' bg-green-300 dark:border-none text-black' },
    { value: 5, label: '5', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-100 dark:border-none text-black' },
    { value: 8, label: '8', selectedClass: '-translate-y-6', defaultClass: ' bg-yellow-200 dark:border-none text-black' },
    { value: 13, label: '13', selectedClass: '-translate-y-6', defaultClass: 'bg-yellow-300 dark:border-none text-black' },
    { value: 21, label: '21', selectedClass: '-translate-y-6', defaultClass: 'bg-red-200 dark:border-none text-black' },
    { value: 34, label: '34', selectedClass: '-translate-y-6', defaultClass: 'bg-red-300 dark:border-none text-black' }
])
</script>