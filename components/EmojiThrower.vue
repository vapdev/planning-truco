<template>
  <div
    :class="[
      'relative select-none flex z-10 transition-opacity duration-300',
      {
        'opacity-100': emojiPickerVisible,
        'opacity-0 group-hover:opacity-100': !emojiPickerVisible,
      },
    ]"
    id="participants"
  >
    <div @click="throwEmoji" class="hover:scale-150 text-2xl cursor-pointer" v-for="emojiItem in emojis" :key="emojiItem.id">
      {{ emojiItem.i }}
    </div>
    <div
      class="hover:scale-150 text-2xl cursor-pointer"
      @click="toggleEmojiPicker"
      ref="emojiButton"
    >
      😊
    </div>
    <div class="relative">
      <EmojiPicker
        ref="target"
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

onClickOutside(target, (event) => toggleEmojiPicker());

const emojiPickerVisible = ref(false);
const emoji = ref("");
const emojis = ref([
  { id: 1, i: "🚀" },
  { id: 2, i: "🎉" },
  { id: 3, i: "🔥" },
  { id: 4, i: "👍" },
  { id: 5, i: "👏" },
]);

const toggleEmojiPicker = () => {
  emojiPickerVisible.value = !emojiPickerVisible.value;
};

const onSelectEmoji = (emoji) => {
  throwEmoji(emoji, props.targetUUID);
  toggleEmojiPicker();
};

const connectWebSocket = () => {
  let ws = new WebSocket("ws://localhost:8080");

  ws.onmessage = (event) => {
    const receivedEmoji = event.data;
    emojis.value.push({ id: Date.now(), i: receivedEmoji });
  };
};

const props = defineProps({
  targetUUID: {
    type: String,
    required: true,
  },
});

const throwEmoji = (emoji, targetUUID) => {
  userStore.ws.send(JSON.stringify({
      type: 'emoji',
      userUUID: userStore.userUUID,
      roomUUID: userStore.roomUUID,
      targetUUID: props.targetUUID,
      emoji
  }));
};

onMounted(() => {
  connectWebSocket();
});
</script>

<style scoped>
.emoji-picker {
  position: absolute;
  top: 100%; /* Positioned below the button */
  left: 0;
  z-index: 1000;
}
</style>
