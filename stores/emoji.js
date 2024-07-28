export const useEmojiStore = defineStore('emoji', () => {
    const emojiStack = ref([])

    const addEmoji = (emoji, originUserId, targetUserId) => {
        emojiStack.value.push({
            key: Date.now(), // Adiciona a chave gerada com base na data
            emoji,
            originUserId,
            targetUserId,
        })
    }
    return { emojiStack, addEmoji }
})