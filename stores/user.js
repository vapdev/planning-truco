import { showToast } from '../composables/toast';
import { useStorage } from "@vueuse/core";

export const useUserStore = defineStore('user', () => {
    const player = ref(null)
    const players = ref([])
    const config = useRuntimeConfig();
    const roomUUID = ref(null);
    const userUUID = ref("");
    const apiUrl = config.public.apiBase;
    const wsUrl = config.public.wsBase;
    const name =  ref("Guest")
    const jogoComecou = ref(false);
    const roomState = ref({
        showCards: false,
        autoShowCards: false,
    })
    const ws = ref(null)
    const POST = 'POST';
    const APPLICATION_JSON = 'application/json';
    
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

    function setWebSocket(tipo) {
        if (process.client) {
            ws.value = new WebSocket(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value)

            ws.value.onopen = () => {
            }

            ws.value.onerror = (error) => {
            }

            ws.value.onmessage = (event) => {
            }

            ws.value.onclose = () => {
            }

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
    }

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
            showToast({ message: 'Erro', position: 'top-center', offsetY: 4, type: 'error'})
            throw new Error('Error changing name');
        } else {
            showToast({ message: 'Nome alterado com sucesso!', position: 'top-center', offsetY: 4, type: 'success' })
        }
    }
    
    return { player, ws, roomState, setWebSocket, startGame, players, userUUID, roomUUID, name, jogoComecou, loadGame, changeName }
})