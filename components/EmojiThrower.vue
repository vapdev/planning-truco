<template>
  <div
    class="relative select-none flex z-10 transition-opacity duration-300"
    id="participants"
  >
    <div
      @click="addEmoji(emojiItem)"
      class="hover:scale-150 text-2xl cursor-pointer"
      v-for="emojiItem in emojis"
      :key="emojiItem.id"
    >
      {{ emojiItem.i }}
    </div>
    <div
      class="hover:scale-150 text-2xl cursor-pointer"
      @click="toggleEmojiPicker"
      ref="emojiButton"
    >
      😊
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
import { useEmojiStore } from "~/stores/emoji";
import EmojiPicker from "vue3-emoji-picker";
const userStore = useUserStore();
const emojiStore = useEmojiStore();
import "vue3-emoji-picker/css";

const target = ref(null);

onClickOutside(target, (event) => toggleEmojiPicker());

const emojiPickerVisible = ref(false);
const emoji = ref("");
const emojis = ref([
  { id: 1, i: "🚀" },
  { id: 2, i: "🎉" },
  { id: 3, i: "🔥" },
  { id: 4, i: "👍" },
  { id: 5, i: "🤔" },
]);

const toggleEmojiPicker = () => {
  emojiPickerVisible.value = !emojiPickerVisible.value;
};

const onSelectEmoji = (emoji) => {
  addEmoji(emoji, props.targetUserId);
};

const connectWebSocket = () => {
  let ws = new WebSocket("ws://localhost:8080");

  ws.onmessage = (event) => {
    const receivedEmoji = event.data;
    emojis.value.push({ id: Date.now(), i: receivedEmoji });
  };
};

const props = defineProps({
  targetUserId: {
    type: Number,
    required: true,
  },
});

const addEmoji = (emoji) => {
  const originUserId = userStore.jogadorLogado.id;
  const targetUserId = props.targetUserId;
  emojiStore.addEmoji(emoji, originUserId, targetUserId);
};

onMounted(() => {
  connectWebSocket();
});
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
