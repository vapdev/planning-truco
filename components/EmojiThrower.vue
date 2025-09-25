<template>
  <div
    class="relative touch-manipulation select-none flex flex-col z-10 gap-2 transition-opacity duration-300 p-2 backdrop-blur-sm bg-white/10 border border-white/20 rounded-xl emoji-container"
    id="participants"
  >
    <!-- Primeira linha: Emojis padrão -->
    <div class="flex gap-3 justify-center">
      <div
        @click="addEmoji(emojiItem)"
        class="group relative flex items-center justify-center w-10 h-10 rounded-lg backdrop-blur-sm bg-white/5 border border-white/10 hover:bg-white/20 cursor-pointer transition-all duration-200 hover:shadow-md hover:shadow-blue-500/20"
        v-for="emojiItem in defaultEmojis"
        :key="emojiItem"
      >
        <span class="text-2xl transition-transform duration-200 filter drop-shadow-lg">
          {{ emojiItem }}
        </span>
      </div>
    </div>
    
    <!-- Segunda linha: Seletor + Emojis recentes -->
    <div class="flex gap-3 justify-center items-center">
      <!-- Seletor de emoji -->
      <div class="relative">
        <div
          class="group relative flex items-center justify-center w-10 h-10 rounded-lg backdrop-blur-sm bg-gradient-to-br from-blue-500/20 to-indigo-500/20 border border-blue-400/30 hover:from-blue-500/30 hover:to-indigo-500/30 cursor-pointer transition-all duration-200 hover:shadow-md hover:shadow-blue-500/20"
          @click="toggleEmojiPicker"
          ref="emojiButton"
        >
          <span class="text-xl transition-transform duration-200 text-blue-200">
            ➕
          </span>
        </div>
        
        <Transition name="emoji-picker">
          <div
            v-if="emojiPickerVisible"
            class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50 backdrop-blur-sm"
            @click="toggleEmojiPicker"
          >
            <div
              class="relative max-w-sm w-full mx-4"
              @click.stop
            >
              <EmojiPicker
                ref="target"
                display-recent
                disable-skin-tones
                theme="dark"
                class="emoji-picker w-full backdrop-blur-sm bg-slate-900/95 border border-white/20 rounded-xl shadow-2xl"
                :native="true"
                @select="onSelectEmoji"
              />
              
              <!-- Botão fechar -->
              <button
                @click="toggleEmojiPicker"
                class="absolute -top-2 -right-2 w-8 h-8 bg-red-500 hover:bg-red-600 text-white rounded-full flex items-center justify-center text-sm font-bold transition-colors z-10"
              >
                ×
              </button>
            </div>
          </div>
        </Transition>
      </div>
      
      <!-- Emojis recentes -->
      <div
        v-for="recentEmoji in recentEmojis"
        :key="recentEmoji"
        @click="addEmoji(recentEmoji)"
        class="group relative flex items-center justify-center w-10 h-10 rounded-lg backdrop-blur-sm bg-white/5 border border-white/10 hover:bg-white/20 cursor-pointer transition-all duration-200 hover:shadow-md hover:shadow-blue-500/20"
      >
        <span class="text-2xl transition-transform duration-200 filter drop-shadow-lg">
          {{ recentEmoji }}
        </span>
      </div>
      
      <!-- Placeholder para manter layout quando não há recentes -->
      <div
        v-for="n in Math.max(0, 5 - recentEmojis.length)"
        :key="`placeholder-${n}`"
        class="w-10 h-10 rounded-lg border border-dashed border-white/10 flex items-center justify-center opacity-30"
      >
        <span class="text-white/20 text-xs">•</span>
      </div>
    </div>
  </div>
</template>
<script setup>
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

const emojiPickerVisible = ref(false);
const emoji = ref("");
const defaultEmojis = ref(["👍", "🎯", "💥", "💣", "🃏", "🤔"]);
const recentEmojis = ref(JSON.parse(localStorage.getItem('recentEmojis') || '[]'));

const toggleEmojiPicker = () => {
  emojiPickerVisible.value = !emojiPickerVisible.value;
  emit("emoji-picker-visible", emojiPickerVisible.value);
};

const onSelectEmoji = (emoji) => {
  addEmojiToRecents(emoji.i);
  addEmoji(emoji.i);
  toggleEmojiPicker(); // Fechar modal após selecionar emoji
};

const addEmojiToRecents = (emojiChar) => {
  // Remove se já existe
  const filtered = recentEmojis.value.filter(e => e !== emojiChar);
  // Adiciona no início
  recentEmojis.value = [emojiChar, ...filtered].slice(0, 5);
  // Salva no localStorage
  localStorage.setItem('recentEmojis', JSON.stringify(recentEmojis.value));
};

const addEmoji = (emoji) => {
  const originUserId = userStore.jogadorLogado.id;
  const targetUserId = props.targetUserId;
  userStore.addEmoji(emoji, originUserId, targetUserId);
};
</script>

<style>
/* Container fixo para evitar mudanças de tamanho */
.emoji-container {
  min-height: 120px; /* altura ajustada para duas linhas */
  align-items: center;
}

/* Garantir que os botões não afetem o layout */
.emoji-container > div {
  flex-shrink: 0;
}

/* Transições do emoji picker */
.emoji-picker-enter-active,
.emoji-picker-leave-active {
  transition: all 0.3s ease;
}

.emoji-picker-enter-from,
.emoji-picker-leave-to {
  opacity: 0;
  transform: scale(0.9);
}

.emoji-picker-enter-to,
.emoji-picker-leave-from {
  opacity: 1;
  transform: scale(1);
}

/* Esconder footer do emoji picker */
.emoji-picker :deep(.v3-footer) {
  display: none !important;
}

/* Ajustar estilo do emoji picker */
.emoji-picker :deep(.v3-container) {
  border-radius: 12px !important;
  overflow: hidden;
}
</style>
