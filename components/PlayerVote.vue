<template>
  <div class="relative atkinson-hyperlegible-mono-regular flex flex-col w-10 gap-2 rounded-md group">
    <div
      class="relative text-white flex items-center rounded-md w-10 h-16 justify-center"
      :class="[
        flipped
          ? 'flip bg-primary-500'
          : 'border-gray-300 dark:border-gray-600',
      ]"
    >
      <div
        v-if="player.voted && flipped"
        class="front rounded-md w-full h-full flex items-center justify-center"
      >
        <span class="text-3xl">
          <span v-if="player.vote != -1">{{ player.vote }}</span>
          <span v-else>☕</span>
        </span>
      </div>
      <div
        v-else
        :class="player.voted ? 'cardPattern bg-primary-500' : 'border-[2px] border-gray-300 dark:border-gray-500'"
        class="rounded-md w-full h-full text-gray-800 flex items-center justify-center"
        v-if="!player.voted || !flipped"
      ></div>
      <div
        class="absolute inset-0 flex items-center justify-center translate-y-[-83%] z-40 group-hover:flex group-hover:opacity-200 transition-opacity duration-300"
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
  background: repeating-linear-gradient(135deg, rgba(0, 0, 0, 0.05) 0px, rgba(0, 0, 0, 0.05) 10px, transparent 10px, transparent 20px);
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
