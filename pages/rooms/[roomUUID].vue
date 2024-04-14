<template>
    <div class="h-full w-full flex flex-col justify-between">
        <!-- HEADER -->
        <HeaderSala class="h-1/6" ref="headerRef" @endGame="endGame" />

        <div class="flex h-4/6 justify-around w-full">

            <!-- MAIN CONTENT -->
            <div class="flex w-1/3 flex-col justify-center items-center ">
                <!-- PLAYERS DE CIMA -->
                <TopContainer style="height: 92px" :players="playersTop" />
                <div class="flex gap-4 justify-center items-center">
                    <!-- PLAYERS DA ESQUERDA -->
                    <LeftContainer :players="playersLeft" />
                    <!-- MESA -->
                    <Mesa @toggleMostrarCartas="toggleMostrarCartas" @novaRodada="novaRodada" />
                    <!-- PLAYERS DA DIREITA -->
                    <RightContainer :players="playersRight" />
                </div>
                <!-- PLAYERS DE BAIXO -->
                <BottomContainer style="height: 92px" :players="playersBottom" />
            </div>

        </div>

        <!-- FOOTER -->
        <div class="w-full h-2/6 flex flex-col justify-end">
            <Deck v-if="!userStore.roomState.showCards" :selectedCard="selectedCard" :votar="votar" />
            <Stats v-else />
        </div>
    </div>
</template>

<script setup>
import lodash from 'lodash';
const config = useRuntimeConfig();
const apiUrl = config.public.apiBase;
const wsUrl = config.public.wsBase;
const { debounce } = lodash;
const nome = ref("");
const selectedCard = ref(null);
const route = useRoute();
const headerRef = ref(null);
const userStore = useUserStore();
const $md = ref(null)

onMounted(async () => {
    userStore.userUUID = localStorage.getItem('userUUID');
    userStore.name = localStorage.getItem('userName');
    await userStore.loadGame(route.params.roomUUID);
    if (!userStore.name || userStore.name == 'Guest') {
        headerRef.value.modalConfig = true;
    }
    $md.value = window.matchMedia('(min-width: 768px)').matches
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

    if (jogadorLogado.value) {
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

watch(() => jogadorLogado.value, (newPlayer, oldPlayer) => {
    if (JSON.stringify(newPlayer) !== JSON.stringify(oldPlayer)) {
        if (newPlayer && !newPlayer.voted) {
            selectedCard.value = null;
        }
    }
}, { deep: true });

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