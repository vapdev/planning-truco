<template>
  <div
    class="relative touch-manipulation select-none flex z-10 gap-3 transition-opacity duration-300 p-2 backdrop-blur-sm bg-white/10 border border-white/20 rounded-xl"
    id="participants"
  >
    <div
      @click="addEmoji(emojiItem)"
      class="group relative flex items-center justify-center w-10 h-10 rounded-lg backdrop-blur-sm bg-white/5 border border-white/10 hover:bg-white/20 cursor-pointer transform transition-all duration-300 hover:scale-110 hover:shadow-lg hover:shadow-purple-500/25"
      v-for="emojiItem in emojis"
      :key="emojiItem"
    >
      <span class="text-2xl group-hover:scale-110 transition-transform duration-300 filter drop-shadow-lg">
        {{ emojiItem }}
      </span>
    </div>
    
    <div
      class="group relative flex items-center justify-center w-10 h-10 rounded-lg backdrop-blur-sm bg-gradient-to-br from-purple-500/20 to-pink-500/20 border border-purple-400/30 hover:from-purple-500/30 hover:to-pink-500/30 cursor-pointer transform transition-all duration-300 hover:scale-110 hover:shadow-lg hover:shadow-purple-500/25"
      @click="toggleEmojiPicker"
      ref="emojiButton"
    >
      <span class="text-xl group-hover:scale-110 transition-transform duration-300 text-purple-200">
        ➕
      </span>
    </div>
    
    <div class="relative z-50">
      <Transition name="emoji-picker">
        <EmojiPicker
          ref="target"
          display-recent
          disable-skin-tones
          theme="dark"
          v-if="emojiPickerVisible"
          class="emoji-picker backdrop-blur-sm bg-slate-900/90 border border-white/20 rounded-xl shadow-2xl"
          :native="true"
          @select="onSelectEmoji"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { onClickOutside } from "@vueuse/core";
import EmojiPicker from "vue3-emoji-picker";
const userStore = useUserStore();
import "vue3-emoji-picker/css";

const target = ref(null);

const props = defineProps({
  targetUserId: {
    type: Number,
    required: true,
  },
});

const emit = defineEmits(["emoji-picker-visible"]);

onClickOutside(target, (event) => toggleEmojiPicker());

const emojiPickerVisible = ref(false);
const emoji = ref("");
const emojis = ref(["👍", "🎯", "💥", "💣", "🃏", "🤔"]);
const toggleEmojiPicker = () => {
  emojiPickerVisible.value = !emojiPickerVisible.value;
  emit("emoji-picker-visible", emojiPickerVisible.value);
};

const onSelectEmoji = (emoji) => {
  addEmoji(emoji.i);
};

const addEmoji = (emoji) => {
  const originUserId = userStore.jogadorLogado.id;
  const targetUserId = props.targetUserId;
  userStore.addEmoji(emoji, originUserId, targetUserId);
};
</script>

<style>
.emoji-picker {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
}

#participants > div.relative.z-50 > div > div.v3-footer {
  display: none;
}
</style>
