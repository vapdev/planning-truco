<template>
  <div
    class="relative touch-manipulation select-none flex z-10 gap-2 md:gap-1 transition-opacity duration-300"
    id="participants"
  >
    <div
      @click="addEmoji(emojiItem)"
      class="hover:scale-150 text-2xl cursor-pointer"
      v-for="emojiItem in emojis"
    >
      {{ emojiItem }}
    </div>
    <div
      class="hover:scale-150 text-2xl cursor-pointer"
      @click="toggleEmojiPicker"
      ref="emojiButton"
    >
      ➕
    </div>
    <div class="relative z-50">
      <EmojiPicker
        ref="target"
        display-recent
        disable-skin-tones
        theme="auto"
        v-if="emojiPickerVisible"
        class="emoji-picker"
        :native="true"
        @select="onSelectEmoji"
      />
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
