<template>
  <div>
    <div
      v-for="emoji in emojiThrowStack"
      :key="emoji.key"
      class="absolute pointer-events-none select-none touch-manipulation text-4xl transition-transform duration-1000 ease-in-out z-50"
      :style="emoji.style"
    >
      {{ emoji.i }}
    </div>
  </div>
</template>

<script setup>
const userStore = useUserStore();
const emojiThrowStack = ref([]);

const computedEmojiStack = computed(() => {
  return [...userStore.emojiStack];
});

const animationKey = ref(0);

const explodeEmojis = (location, emoji) => {
  const explosionCount = 5; // Número de emojis na explosão
  const explosionDuration = 1000; // Duração da explosão em ms

  for (let i = 0; i < explosionCount; i++) {
    const angle = (Math.PI * 2 * i) / explosionCount;
    const distance = 50 + Math.random() * 50; // Distância da explosão com variação aleatória

    const key = `explosion-${Date.now()}-${animationKey.value++}`;
    const initialStyle = {
      top: `${location.top + 15}px`,
      left: `${location.left - 5}px`,
      transform: "translate(0, 0) rotate(0deg)",
      opacity: "1",
    };
    const finalStyle = {
      ...initialStyle,
      transform: `translate(${Math.cos(angle) * distance}px, ${
        Math.sin(angle) * distance
      }px) rotate(${Math.random() * 360}deg)`,
    };

    emojiThrowStack.value.push({
      i: emoji,
      key: key,
      style: initialStyle,
    });

    // Animate explosion
    requestAnimationFrame(() => {
      emojiThrowStack.value = emojiThrowStack.value.map((e) => {
        if (e.key === key) {
          return {
            ...e,
            style: finalStyle,
          };
        }
        return e;
      });
    });

    // Remover os emojis após a explosão
    setTimeout(() => {
      emojiThrowStack.value = emojiThrowStack.value.filter((e) => e.key !== key);
    }, explosionDuration);
  }
};

const animateEmoji = (startId, endId, emoji) => {
  const startLocation = userStore.playerLocations[startId];
  const endLocation = userStore.playerLocations[endId];

  if (startLocation && endLocation) {
    if (startId === endId) {
      explodeEmojis(startLocation, emoji);
    } else {
      const key = `emoji-${Date.now()}-${animationKey.value++}`;
      const initialStyle = {
        top: `${startLocation.top + 15}px`,
        left: `${startLocation.left - 5}px`,
        transform: "translate(0, 0)",
      };
      const finalStyle = {
        ...initialStyle,
        transform: `translate(${endLocation.left - startLocation.left}px, ${
          endLocation.top - startLocation.top
        }px) rotate(360deg)`,
      };

      emojiThrowStack.value.push({
        i: emoji,
        key: key,
        style: initialStyle,
      });

      requestAnimationFrame(() => {
        emojiThrowStack.value = emojiThrowStack.value.map((e) => {
          if (e.key === key) {
            return {
              ...e,
              style: finalStyle,
            };
          }
          return e;
        });
      });

      const duration = 1000;

      setTimeout(() => {
        emojiThrowStack.value = emojiThrowStack.value.filter((e) => e.key !== key);
      }, duration);
    }
  }
};

watch(
  computedEmojiStack,
  (newStack, oldStack) => {
    newStack.forEach((emoji) => {
      if (!oldStack.includes(emoji)) {
        animateEmoji(emoji.originUserId, emoji.targetUserId, emoji.emoji);
      }
    });
  },
  { deep: true }
);
</script>
