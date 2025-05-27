<template>
  <div class="flex flex-col justify-end w-full pb-4">
    <div class="flex justify-center font-semibold text-white/90 mb-4 text-lg">{{ $t("voteBelow") }} </div>
    <div
      class="flex justify-center md:justify-center text-purple-400 overflow-x-auto gap-4 items-center pb-4 pt-8 w-full"
    >
      <div class="flex gap-6">
        <div
          v-for="(card, index) in deck"
          :key="index"
          @click="votar(card.value)"
          :class="getCardClasses(card)"
          :style="{ animationDelay: `${index * 100}ms` }"
          class="text-2xl w-16 h-24 flex items-center rounded-xl justify-center cursor-pointer transition-all duration-300 ease-out card-hover animate-fade-in-up backdrop-blur-sm border border-white/20 shadow-lg"
        >
          <div class="flex justify-center w-24 text-white font-bold">{{ card.label }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useUserStore } from "~/stores/user";

const props = defineProps({
  selectedCard: Number,
  votar: Function,
  deck: Array,
});

const userStore = useUserStore();
const getCardClasses = (card) => {
  const isSelected = props.selectedCard === card.value;
  return [
    isSelected
      ? "bg-gradient-to-br from-purple-600 to-pink-600 -translate-y-6 scale-110 shadow-2xl shadow-purple-500/50"
      : "bg-gradient-to-br from-slate-700/80 to-slate-800/80 hover:-translate-y-3 hover:bg-gradient-to-br hover:from-purple-500/80 hover:to-pink-500/80 hover:shadow-xl hover:shadow-purple-500/30",
    "text-white",
  ];
};

const cardStyle = computed(() => {
});
</script>

<style scoped>
@keyframes fade-in-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fade-in-up 0.4s ease-out both;
}

.card-hover {
  position: relative;
  overflow: hidden;
}

.card-hover::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s;
}

.card-hover:hover::before {
  left: 100%;
}

.card-hover:hover {
  transform: translateY(-12px) scale(1.05);
  box-shadow: 0 10px 25px rgba(168, 85, 247, 0.3);
}

.card-hover:active {
  transform: translateY(-8px) scale(1.02);
}
</style>
