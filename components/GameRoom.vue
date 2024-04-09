<template v-if="userStore.jogoComecou">
    <div class="h-full w-full flex flex-col justify-between">
        <div class="text-white text-xl flex p-4 justify-between">
            <div class="w-1/3 justify-start items-center">
                Copiar link da sala:
                <Icon size="36" name="material-symbols-light:content-copy" color="white" />
            </div>
            <div class="flex w-1/3 justify-center items-center">
                <span>Nome da sala: <span class="font-bold">{{ userStore.roomUUID }}</span></span>
            </div>
            <div class="flex w-1/3 justify-end gap-5 items-center">
                <Icon size="36" name="material-symbols-light:settings" color="white" />
                <Icon @click="endGame" size="36" name="material-symbols-light:exit-to-app" color="white" />
            </div>
        </div>
        <div class="relative pb-10">
            <div class="relative justify-center pt-32 md:pt-10 flex flex-wrap w-full gap-10">
                <div class="w-72 h-44 rounded-xl flex justify-center items-center border-green-600 border-4 mx-auto">
                    <div v-if="!userStore.roomState.autoShowCards && !userStore.roomState.showCards" class="text-red-500">
                        <button @click="toggleMostrarCartas"
                            class="text-white font-bold py-2 px-4 rounded w-40 bg-green-600 hover:bg-green-500">
                            <span>Revelar votos</span>
                        </button>
                    </div>
                    <div v-if="userStore.roomState.showCards">
                        <button @click="novaRodada"
                            class="w-50 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded bg-blue-500">
                            <span>Iniciar nova votação</span>
                        </button>
                    </div>
                </div>

                <div v-for="(player, index) in userStore.players" :key="player.id" class="absolute"
                    :style="{ transform: `rotate(${index * (360 / userStore.players.length)}deg) translate(250px) rotate(-${index * (360 / userStore.players.length)}deg)` }">
                    <PlayerVote :player="player" :mostrarCartas="userStore.roomState.showCards" />
                </div>
            </div>
        </div>
        <div class="md:justify-center overflow-x-auto gap-4 md:h-48 2 items-center w-full flex">
            <Deck v-if="!userStore.roomState.showCards" :selectedCard="selectedCard" :votar="votar" />
            <template v-else>
                <div class="flex flex-col gap-2 pb-4 md:pb-0">
                    <div class="text-white text-xl md:text-2xl">Votação encerrada</div>
                    <div class="flex items-center gap-4 text-white text-xl md:text-2xl">
                        <div class="text-green-300">Carta mais votada: </div>
                        <div
                            class="mt-4 w-10 h-14 text-black font-bold flex-col relative flex rounded-lg justify-center border-4 border-green-500 bg-green-100">
                            <span class="text-xl flex justify-center"><span>{{ winnerComputed }}</span></span>
                        </div>
                    </div>
                </div>
            </template>
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

watch(nome, (newVal, oldVal) => {
    if (newVal) {
        debouncedUpdate();
    }
});

const winnerComputed = computed(() => {
    if (userStore.players.length > 0) {
        const votes = userStore.players.map(player => player.vote);
        const mostVoted = votes.reduce((acc, curr) => {
            acc[curr] = (acc[curr] || 0) + 1;
            return acc;
        }, {});
        const mostVotedArray = Object.entries(mostVoted);
        const mostVotedSorted = mostVotedArray.sort((a, b) => b[1] - a[1]);
        return mostVotedSorted[0][0];
    }
    return null;
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

const sairDaSala = () => {
    userStore.roomUUID = null;
    userStore.jogoComecou = false;
    userStore.players = [];
    userStore.roomState.autoShowCards = true;
    userStore.roomState.showCards = false;
    selectedCard.value = null;
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