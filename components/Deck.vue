<template>
  <div class="flex flex-col justify-end w-full">
    <div class="flex justify-center font-semibold">Vote abaixo 👇</div>
    <div
      class="flex justify-center md:justify-center text-primary-500 overflow-x-auto gap-4 items-center pb-4 pt-8 w-full"
    >
      <div class="flex gap-4">
        <div
          v-for="(card, index) in cards"
          :key="index"
          @click="votar(card.value)"
          :class="getCardClasses(card)"
          :style="cardStyle"
          class="text-3xl oswald-font w-12 h-20 flex items-center rounded-lg justify-center cursor-pointer"
        >
          <div class="flex justify-center w-24 text-white">{{ card.label }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useUserStore } from "@/stores/user";

const props = defineProps({
  selectedCard: Number,
  votar: Function,
});

const userStore = useUserStore();

const cards = ref([
  { value: -1, label: "☕" },
  { value: 0, label: "0" },
  { value: 1, label: "1" },
  { value: 2, label: "2" },
  { value: 3, label: "3" },
  { value: 5, label: "5" },
  { value: 8, label: "8" },
  { value: 13, label: "13" },
  { value: 21, label: "21" },
  { value: 34, label: "34" },
]);

const getCardClasses = (card) => {
  const isSelected = props.selectedCard === card.value;
  return [
    isSelected
      ? "bg-primary-700 -translate-y-4"
      : "bg-primary-500 hover:-translate-y-1 hover:bg-primary-600",
    "text-white",
  ];
};

const cardStyle = computed(() => {
  return userStore.isDarkMode
    ? "box-shadow: 0 10px 30px -10px #222222;"
    : "box-shadow: 0 10px 30px -10px #000000;";
});
</script>

<style scoped>
.hover\:bg-primary-600:hover {
  background-color: #3b82f6;
}
</style>
