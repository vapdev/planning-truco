<template>
  <div class="relative atkinson-hyperlegible-mono-regular flex flex-col w-8 sm:w-10 gap-1 sm:gap-2 rounded-lg sm:rounded-xl group">
    <div
      class="relative text-white flex items-center rounded-lg sm:rounded-xl w-8 h-12 sm:w-10 sm:h-16 justify-center backdrop-blur-sm border border-white/20 shadow-lg"
      :class="[
        flipped
          ? 'flip bg-gradient-to-br from-purple-500 to-pink-500 shadow-purple-500/30'
          : player.voted 
            ? 'bg-gradient-to-br from-slate-600/80 to-slate-700/80 shadow-slate-500/20'
            : 'bg-slate-800/50 border-white/10',
      ]"
    >
      <div
        v-if="player.voted && flipped"
        class="front rounded-lg sm:rounded-xl w-full h-full flex items-center justify-center animate-vote-reveal"
      >
        <span class="text-lg sm:text-2xl font-bold text-white drop-shadow-lg">
          <span v-if="player.vote != -1">{{ player.vote }}</span>
          <span v-else>☕</span>
        </span>
      </div>
      <div
        v-else
        :class="player.voted ? 'cardPattern bg-gradient-to-br from-purple-600/80 to-pink-600/80' : 'border-[2px] border-white/20'"
        class="rounded-lg sm:rounded-xl w-full h-full text-white flex items-center justify-center transition-all duration-300"
        v-if="!player.voted || !flipped"
      ></div>
      <div
        class="absolute -top-14 left-1/2 transform -translate-x-1/2 z-40 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
        :class="{ '!opacity-100': emojiPickerVisible }"
      >
        <EmojiThrower
          :targetUserId="player.id"
          @emoji-picker-visible="setEmojiPickerVisible"
        />
      </div>
    </div>
    <div class="w-full text-center z-10">
      <div class="text-xs sm:text-sm flex justify-center text-nowrap font-semibold text-white/90">
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
@keyframes flip-animation {
  0% {
    transform: rotateY(180deg);
  }
  100% {
    transform: rotateY(0deg);
  }
}

@keyframes vote-reveal {
  0% {
    opacity: 0;
    transform: scale(0.5);
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.flip {
  transform-style: preserve-3d;
  animation-duration: 0.6s;
  animation-timing-function: ease-out;
  animation-name: flip-animation;
  box-shadow: 0 8px 25px rgba(168, 85, 247, 0.4);
}

.animate-vote-reveal {
  animation: vote-reveal 0.4s ease-out;
}

.cardPattern {
  background: repeating-linear-gradient(
    135deg, 
    rgba(255, 255, 255, 0.1) 0px, 
    rgba(255, 255, 255, 0.1) 8px, 
    transparent 8px, 
    transparent 16px
  );
  position: relative;
}

.cardPattern::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.1));
  border-radius: inherit;
}

.front {
  backface-visibility: hidden;
}

.back {
  transform: rotateY(180deg);
  backface-visibility: hidden;
}

.group:hover div:first-child {
  transition: all 0.2s ease-out;
}
</style>
