export const useUserStore = defineStore('user', () => {
    const player = ref(null)
    const players = ref([])
    const config = useRuntimeConfig();
    const roomUUID = ref(null);
    const userUUID = ref(null);
    const apiUrl = config.public.apiBase;
    const wsUrl = config.public.wsBase;
    const name = ref("Anônimo");
    const jogoComecou = ref(false);
    const roomState = ref({
        showCards: false,
        autoShowCards: false,
    })
    const ws = ref(null)
    const startGame = async () => {
        const response = await fetch(`${apiUrl}/createRoom`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                userUUID: userUUID.value,
            }),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        roomUUID.value = data.roomUUID;
        userUUID.value = data.userUUID;
        localStorage.setItem('userUUID', userUUID.value);
        setWebSocket('newAdmin');
        navigateTo(`/rooms/${roomUUID.value}`);
    }
    const loadGame = async (inputRoomUUID) => {
        if (inputRoomUUID) {
            const response = await fetch(`${apiUrl}/joinRoom`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    userUUID: localStorage.getItem('userUUID'),
                    roomUUID: inputRoomUUID,
                }),
            });
    
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
    
            const data = await response.json();
            userUUID.value = data.userUUID;
            roomUUID.value = data.roomUUID;
            localStorage.setItem('userUUID', userUUID.value);
            setWebSocket('newPlayer');
        }
    };
    function setWebSocket(tipo) {
        console.log(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value)
        ws.value = new WebSocket(wsUrl + '/ws/' + roomUUID.value + '/' + userUUID.value)
        ws.value.onopen = () => {
            console.log('WebSocket connected!!!!!!')
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
    return { player, ws, roomState, setWebSocket, startGame, players, userUUID, roomUUID, name, jogoComecou, loadGame }
})