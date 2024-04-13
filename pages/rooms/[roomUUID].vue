<template>
    <div class="h-full w-full flex flex-col justify-between">
        <!-- HEADER -->
        <HeaderSala @endGame="endGame" />

        <div class="flex justify-around w-full">
            <div class="text-white w-1/3"></div>

            <!-- MAIN CONTENT -->
            <div class="flex w-1/3 flex-col items-center ">
                <!-- PLAYERS DE CIMA -->
                <TopContainer :players="playersTop" />
                <div class="flex gap-4 justify-center items-center">
                    <!-- PLAYERS DA ESQUERDA -->
                    <LeftContainer :players="playersLeft" />
                    <!-- MESA -->
                    <Mesa @toggleMostrarCartas="toggleMostrarCartas" @novaRodada="novaRodada" />
                    <!-- PLAYERS DA DIREITA -->
                    <RightContainer :players="playersRight" />
                </div>
                <!-- PLAYERS DE BAIXO -->
                <BottomContainer :players="playersBottom" />
            </div>

            <div class="text-white w-1/3"></div>
        </div>

        <!-- FOOTER -->
        <div class="w-full">
            <Deck style="height: 236px" v-if="!userStore.roomState.showCards" :selectedCard="selectedCard" :votar="votar" />
            <Stats v-else />
        </div>
    </div>
</template>

<script setup>
import lodash from 'lodash';
const config = useRuntimeConfig();
const userStore = useUserStore();
const apiUrl = config.public.apiBase;
const wsUrl = config.public.wsBase;
const { debounce } = lodash;
const nome = ref("");
const selectedCard = ref(null);
const route = useRoute();

userStore.loadGame(route.params.roomUUID);

watch(nome, (newVal, oldVal) => {
    if (newVal) {
        debouncedUpdate();
    }
});

const playersBottom = computed(() => {
    return userStore.players.filter((_, index) => {
        if (index < 4) return index % 4 === 0;
        return index % 2 === 0;
    });
});

const playersTop = computed(() => {
    return userStore.players.filter((_, index) => {
        if (index < 4) return index % 4 === 1;
        return index % 2 === 1;
    });
});

const playersLeft = computed(() => {
    return userStore.players.filter((_, index) => index === 2);
});

const playersRight = computed(() => {
    return userStore.players.filter((_, index) => index === 3);
});

const debouncedUpdate = debounce(() => {
    fetch(`${apiUrl}/changeName`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            userUUID: userStore.userUUID,
            roomUUID: userStore.roomUUID,
            name: userStore.nome,
        }),
        
    });
}, 1000); // 1000 milliseconds = 1 second

watch(userStore.players, (newPlayers, oldPlayers) => {
    if (newPlayers.length > 0) {
        newPlayers.forEach(player => {
            if (player.voted && player.vote !== selectedCard.value && player.uuid === userUUID.value) {
                selectedCard.value = player.vote;
            }
            if (selectedCard.value && !player.voted && player.uuid === userUUID.value) {
                selectedCard.value = null;
            }
        });
    }
}, { deep: true });

const novaRodada = () => {
    fetch(`${apiUrl}/resetVotes`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            roomUUID: userStore.roomUUID,
        }),
        
    });
}

const onePlayerlist = [
    {
        // mock player
        id: 1,
        name: "Player 1",
    },
]

const player = {
    // mock player
    id: 1,
    name: "Player 1",
    voted: true,
    vote: 5,
}

const players = [
    {
        // mock player
        id: 1,
        name: "Player 1",
    },
    {
        // mock player
        id: 2,
        name: "Player 2",
    },
    {
        // mock player
        id: 3,
        name: "Player 3",
    },
    {
        // mock player
        id: 4,
        name: "Player 4",
    },
    {
        // mock player
        id: 5,
        name: "Player 5",
    },
    {
        // mock player
        id: 6,
        name: "Player 6",
    },
    {
        // mock player
        id: 7,
        name: "Player 7",
    },
    {
        // mock player
        id: 8,
        name: "Player 8",
    },
    {
        // mock player
        id: 9,
        name: "Player 9",
    },
    {
        // mock player
        id: 10,
        name: "Player 10",
    },
    {
        id: 11,
        name: 'sdadas',
    },
    {
        id: 11,
        name: 'sdadas',
    },
    {
        id: 11,
        name: 'sdadas',
    },
    {
        id: 11,
        name: 'sdadas',
    },
]

const sairDaSala = () => {
    userStore.roomUUID = null;
    userStore.jogoComecou = false;
    userStore.players = [];
    userStore.roomState.autoShowCards = true;
    userStore.roomState.showCards = false;
    selectedCard.value = null;
    navigateTo('/');
};

const votar = (score) => {
    if (selectedCard.value === score) {
        selectedCard.value = null;
    } else {
        selectedCard.value = score;
    }
    console.log('votando')
    console.log(jogadorLogado.value)

    if (jogadorLogado.value) {
        console.log('votando')
        userStore.ws.send(JSON.stringify({
            type: 'vote',
            userUUID: userStore.userUUID,
            roomUUID: userStore.roomUUID,
            vote: score
        }));
    }
};



const endGame = () => {
    if (userStore.roomUUID) {
        fetch(`${apiUrl}/leaveRoom`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                userUUID: userStore.userUUID,
                roomUUID: userStore.roomUUID,
            }),
            
        });
    }
    sairDaSala();
};

const jogadorLogado = computed(() =>
    userStore.players.find((player) => player.uuid === userStore.userUUID)
);

const toggleMostrarCartas = () => {
    fetch(`${apiUrl}/showCards`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            roomUUID: userStore.roomUUID,
        }),
        
    });
};

const toggleVirarAutomatico = () => {
    fetch(`${apiUrl}/autoShowCards`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            roomUUID: userStore.roomUUID,
        }),
        
    });
};
</script>