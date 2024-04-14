import { showToast } from '../composables/toast';
import { useStorage } from "@vueuse/core";

export const useUserStore = defineStore('user', () => {
    const player = ref(null)
    const players = ref([])
    const config = useRuntimeConfig();
    const roomUUID = ref(null);
    const userUUID = useStorage('userUUID', '');
    const apiUrl = config.public.apiBase;
    const wsUrl = config.public.wsBase;
    const name =  useStorage('userName', '');
    const jogoComecou = ref(false);
    const roomState = ref({
        showCards: false,
        autoShowCards: false,
    })
    const ws = ref(null)
    const POST = 'POST';
    const APPLICATION_JSON = 'application/json';
    
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
            console.log(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value)
            ws.value = new WebSocket(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value)

            ws.value.onopen = () => {
                console.log('WebSocket connected!!!!!!')
            }

            ws.value.onerror = (error) => {
                console.log('WebSocket error: ', error)
            }

            ws.value.onmessage = (event) => {
                console.log('WebSocket message connected!!!!!!', event.data)
            }

            ws.value.onclose = () => {
                console.log('WebSocket closed')
            }

            console.log(name.value)
            ws.value.addEventListener('open', (event) => {
                ws.value.send(JSON.stringify({
                    type: tipo,
                    userUUID: userUUID.value,
                    name: name.value,
                }));
            });

            ws.value.addEventListener('message', (event) => {
                console.log("Received message", event.data)
                const data = JSON.parse(event.data);
                roomState.value = data;
                players.value = data.players;
            });
        }
    }

    const startGame = async (roomName) => {
        console.log('startGame', roomName)
        const data = await fetchJson(`${apiUrl}/createRoom`, {
            userUUID: userUUID.value,
            roomName: roomName,
        });

        roomUUID.value = data.roomUUID;
        userUUID.value = data.userUUID;
        // setWebSocket('newAdmin');
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