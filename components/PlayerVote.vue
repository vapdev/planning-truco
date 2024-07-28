<template>
  <div class="relative flex flex-col w-10 gap-2 rounded-md group">
    <div
      class="relative text-blue-500 dark:text-white dark:bg-blue-100 flex items-center rounded-md w-10 h-16 justify-center"
      :class="[
        flipped
          ? 'flip border-blue-500 dark:border-0 dark:bg-blue-500 border-2 bg-none'
          : 'bg-gray-200 dark:bg-gray-600',
      ]"
    >
      <div
        v-if="player.voted && flipped"
        class="front rounded-md w-full h-full flex items-center justify-center"
      >
        <span class="oswald-font text-3xl">
          <span v-if="player.vote != -1">{{ player.vote }}</span>
          <span v-else>☕</span>
        </span>
      </div>
      <div
        v-else
        :class="player.voted ? 'cardPattern bg-blue-500' : ''"
        class="rounded-md w-full h-full text-gray-800 flex items-center justify-center"
        v-if="!player.voted || !flipped"
      ></div>
      <div
        class="absolute inset-0 flex items-center justify-center translate-y-[-95%] z-40 group-hover:flex group-hover:opacity-100 transition-opacity duration-300"
        :class="{ hidden: !emojiPickerVisible }"
      >
        <EmojiThrower
          :targetUserId="player.id"
          @emoji-picker-visible="setEmojiPickerVisible"
        />
      </div>
    </div>
    <div class="w-full text-center z-10">
      <div class="text-sm flex justify-center text-nowrap font-semibold">
        {{ player.name || " " }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import EmojiThrower from "./EmojiThrower.vue";

const props = defineProps({
  player: {
    type: Object,
    default: () => ({ voted: false, vote: 0, name: "" }),
  },
  mostrarCartas: {
    type: Boolean,
    default: false,
  },
});

const { player, mostrarCartas } = toRefs(props);
const flipped = ref(false);
const emojiPickerVisible = ref(false);

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
);

const setEmojiPickerVisible = (visible) => {
  emojiPickerVisible.value = visible;
};
</script>

<style scoped>
.flip {
  transform-style: preserve-3d;
  animation-duration: 0.6s;
  animation-timing-function: ease-out;
  animation-name: flip-animation;
}
.cardPattern {
  background-image: repeating-linear-gradient(
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
