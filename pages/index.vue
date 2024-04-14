<template>
    <div class="flex flex-col w-full h-full">
        <div class="w-full px-4 flex justify-between text-white items-center text-2xl bg-preto md:h-16">
            <div class=" text-blue-500 font-bold">Free Planning Poker</div>
            <div class="text-lg font-bold">
                <div class="flex gap-4">
                    <button @click="startGame"
                        class="bg-blue-500 md:hover:bg-blue-400 font-bold p-2 px-4 rounded">
                        Iniciar nova sala
                    </button>
                </div>
            </div>
        </div>
        <div class="flex flex-col md:flex-row h-full w-full">
            <div class="p-6 pt-14 text-white flex flex-col justify-center items-center w-full md:w-1/2 text-xl">
                <div>
                    <p class="text-4xl mb-8">Bem-vindo ao <span
                            class="underline-offset-4 underline text-blue-500 font-bold">Free
                            Planning Poker</span></p>
                    <div class="mb-8">
                        A solução perfeita para os planejamentos de sprint da sua equipe
                    </div>
                </div>
                <!-- <div class="w-[600px]">
                    <div class="flex w-full gap-4">
                        <div class="">
                            <img src="https://planning-poker-agile.web.app/static/media/Session.6e63c44d14589001840a.jpg"
                                alt="Imagem 1" class="rounded-lg" />
                        </div>
                        <div class="">
                            <img src="https://planning-poker-agile.web.app/static/media/Session.6e63c44d14589001840a.jpg"
                                alt="Imagem 2" class="rounded-lg" />
                        </div>
                    </div>
                    <div class="flex gap-4 mt-4 w-full">
                        <div class="">
                            <img src="https://planning-poker-agile.web.app/static/media/Session.6e63c44d14589001840a.jpg"
                                alt="Imagem 1" class="rounded-lg" />
                        </div>
                        <div>
                            <img src="https://planning-poker-agile.web.app/static/media/Session.6e63c44d14589001840a.jpg"
                                alt="Imagem 2" class="rounded-lg" />
                        </div>
                    </div>
                </div> -->
            </div>
            <div class="text-white pl-6 flex flex-col justify-center items-center w-full md:w-1/2 text-2xl">
                <div class="text-3xl font-bold">Jogue agora gratuitamente!</div>
                <div class="flex flex-col font-bold text-xl py-8 gap-6 md:gap-16">
                    <template v-if="!userStore.jogoComecou">
                        <div class="flex flex-col gap-6 text-white">
                            <p>Crie uma nova sala</p>
                            <button @click="startGame"
                                class="w-60 h-12 bg-blue-500 md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded">
                                Iniciar nova sala
                            </button>
                        </div>
                        <div class="flex flex-col gap-6 text-white">
                            <div>Ou entre em uma sala existente</div>
                            <div class="flex gap-4">
                                <UInput v-model="roomUUID" size="xl" color="blue"  class="w-full text-white" placeholder="Insira o link da sala" />
                                <button @click="loadGame(roomUUID)"
                                    class="outline outline-blue-500 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded">
                                    Entrar
                                </button>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
        </div>
        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalCriar">
            <div class="relative rounded-lg rubik-font font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon @click="modalCriar = false"
                        class=" md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out" size="38"
                        name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="mb-4 text-white text-4xl">Criando sala</div>
                <div class="text-md flex flex-col gap-4 text-white">
                    <div>Nome da sala:</div>
                    <div class="flex text-white w-full gap-4">
                        <UInput color="blue" v-model="roomName" size="lg" class="w-full " placeholder="Nome da sala (Opcional)" />
                    </div>
                </div>
                <button @click="userStore.startGame(roomName)"
                    class=" bg-blue-500 mt-6 w-full md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded">
                    Iniciar
                </button>
            </div>
        </UModal>
    </div>
</template>

<script setup>
const userStore = useUserStore();
const roomUUID = ref('');
const modalCriar = ref(false);
const modalEntrar = ref(false);

onMounted(() => {
    userStore.userUUID = localStorage.getItem('userUUID');
    userStore.name = localStorage.getItem('userName');
});

const roomName = ref('');
const userName = ref('');
const goToGithub = () => {
    window.open('https://github.com/vapdev', '_blank');
};
const startGame = () => {
    modalCriar.value = true;
    // userStore.startGame();
}

const loadGame = (roomUUID) => {
    modalEntrar.value = true;
    // userStore.loadGame(roomUUID);
}
</script>