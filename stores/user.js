import { showToast } from '../composables/toast';
import { defineStore } from 'pinia';

export const useUserStore = defineStore('user', () => {
    const player = ref(null);
    const players = ref([]);
    const playerLocations = ref({});
    const config = useRuntimeConfig();
    const roomUUID = ref(null);
    const userUUID = ref("");
    const apiUrl = config.public.apiBase;
    const wsUrl = config.public.wsBase;
    const name = ref("Guest");
    const jogoComecou = ref(false);
    const roomState = ref({
        showCards: false,
        autoShowCards: false,
    });
    const ws = ref(null);
    const POST = 'POST';
    const APPLICATION_JSON = 'application/json';
    const isDarkMode = ref(false);

    watch(userUUID, (newVal) => {
        if (newVal !== null && newVal !== '') {
            localStorage.setItem('userUUID', newVal);
        }
    });

    watch(name, (newVal) => {
        if (newVal !== null) {
            localStorage.setItem('userName', newVal);
        }
    });

    async function fetchJson(url, body) {
        const response = await fetch(url, {
            method: POST,
            headers: {
                'Content-Type': APPLICATION_JSON,
            },
            body: JSON.stringify(body),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        return response.json();
    }

    const noVotes = computed(() => {
        return players.value.every(player => player.voted === false);
    });

    function setWebSocket(tipo) {
        if (process.client) {
            ws.value = new WebSocket(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value);

            ws.value.onopen = () => { };

            ws.value.onerror = (error) => { };

            ws.value.onmessage = (event) => { };

            ws.value.onclose = () => {
                setTimeout(() => {
                    setWebSocket(); // Re-establish the WebSocket connection
                }, 1000); // 1-second delay before reconnecting
            };

            ws.value.addEventListener('open', (event) => {
                ws.value.send(JSON.stringify({
                    type: tipo,
                    userUUID: userUUID.value,
                    name: name.value,
                }));
            });

            ws.value.addEventListener('message', (event) => {
                const data = JSON.parse(event.data);
                roomState.value = data;
                players.value = data.players;
                if (data.emojis) {
                    data.emojis.forEach(emoji => {
                        emojiStack.value.push({
                            emoji: emoji.Emoji,
                            originUserId: emoji.OriginUserID,
                            targetUserId: emoji.TargetUserID,
                            key: Date.now(),
                        })
                    })
                }
            });
        }
    }

    const startGame = async (roomName) => {
        const data = await fetchJson(`${apiUrl}/createRoom`, {
            userUUID: userUUID.value,
            roomName: roomName,
        });
        roomUUID.value = data.roomUUID;
        userUUID.value = data.userUUID;
        navigateTo(`/rooms/${roomUUID.value}`);
    };

    const loadGame = async (inputRoomUUID) => {
        if (inputRoomUUID) {
            const data = await fetchJson(`${apiUrl}/joinRoom`, {
                userUUID: userUUID.value,
                roomUUID: inputRoomUUID,
            });

            userUUID.value = data.userUUID;
            roomUUID.value = data.roomUUID;
            setWebSocket('newPlayer');
        }
    };

    const changeName = async (newName) => {
        name.value = newName;
        const response = await fetch(`${apiUrl}/changeName`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                roomUUID: roomUUID.value,
                userUUID: userUUID.value,
                name: newName,
            }),
        });

        if (!response.ok) {
            showToast({ message: 'Erro', position: 'top-center', offsetY: 4, type: 'error' });
            throw new Error('Error changing name');
        } else {
            showToast({ message: 'Nome alterado com sucesso!', position: 'top-center', offsetY: 4, type: 'success' });
        }
    };

    const changeRoomName = async (newName) => {
        const response = await fetch(`${apiUrl}/changeRoomName`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                roomUUID: roomUUID.value,
                userUUID: userUUID.value,
                roomName: newName,
            }),
        });

        if (!response.ok) {
            showToast({ message: 'Erro', position: 'top-center', offsetY: 4, type: 'error' });
            throw new Error('Error changing room name');
        } else {
            showToast({ message: 'Nome da sala alterado com sucesso!', position: 'top-center', offsetY: 4, type: 'success' });
        }
    };

    const kickPlayer = async (playerUUID) => {
        const response = await fetch(`${apiUrl}/kickPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                roomUUID: roomUUID.value,
                userUUID: userUUID.value,
                playerUUID: playerUUID,
            }),
        });

        if (!response.ok) {
            showToast({ message: 'Erro', position: 'top-center', offsetY: 4, type: 'error' });
            throw new Error('Error kicking player');
        } else {
            showToast({ message: 'Jogador removido com sucesso!', position: 'top-center', offsetY: 4, type: 'success' });
        }
    };

    // Função para atualizar as localizações dos jogadores
    const updatePlayerLocation = (playerId, position) => {
        playerLocations.value[playerId] = position;
    };

    const jogadorLogado = computed(() =>
        players.value.find((player) => player.uuid === userUUID.value)
    );

    const emojiStack = ref([])

    const addEmoji = (emoji, originUserId, targetUserId) => {
        ws.value.send(JSON.stringify({
            type: 'emoji',
            emoji: emoji,
            originUserId,
            targetUserId,
        }));
    }

    return {
        player,
        ws,
        roomState,
        setWebSocket,
        startGame,
        players,
        playerLocations,
        userUUID,
        roomUUID,
        name,
        jogoComecou,
        loadGame,
        changeName,
        changeRoomName,
        noVotes,
        isDarkMode,
        kickPlayer,
        updatePlayerLocation,
        jogadorLogado,
        emojiStack,
        addEmoji,
    };
});
