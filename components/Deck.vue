<template>
    <div class="flex flex-col  justify-end w-full">
        <div class="flex justify-center font-semibold">Vote abaixo 👇</div>
        <div  class="md:justify-center text-primary-500 overflow-x-auto gap-4 items-center pb-4  pt-8 w-full flex">
            <div class="flex gap-4">
                <div v-for="(card, index) in cards" :key="index" @click="votar(card.value)"
                    :class="card.defaultClass, selectedCard === card.value ? card.selectedClass : ' md:hover:-translate-y-1 md:hover:bg-primary-100 md:hover:bg-primary-600 bg-primary-500' "
                    :style="userStore.isDarkMode ? 'box-shadow: 0 10px 30px -10px #222222;' : 'box-shadow: 0 10px 30px -10px #;'"
                    class="text-3xl oswald-font w-12 h-20 flex items-center rounded-lg justify-center cursor-pointer">
                    <div class="flex justify-center w-24 text-white">{{ card.label }}</div>
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
    { value: -1, label: '☕', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 0, label: '0', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 1, label: '1', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 2, label: '2', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 3, label: '3', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 5, label: '5', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 8, label: '8', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 13, label: '13', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 21, label: '21', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' },
    { value: 34, label: '34', selectedClass: '-translate-y-4 bg-primary-500 dark:bg-primary-700 text-white', defaultClass: '' }
])
</script>