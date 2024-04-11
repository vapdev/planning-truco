<template>
    <div class="flex flex-col w-full h-full">
        <div class="w-full px-4 flex justify-between text-white items-center text-2xl bg-preto h-16">
            <div class="oswald-font text-blue-500">Free Planning Poker</div>
            <div class="text-lg font-bold">
                <div class="flex gap-4">
                    <div class="md:hover:bg-gray-600 rounded cursor-pointer p-2">Sign Up</div>
                    <div class="md:hover:bg-gray-600 rounded cursor-pointer p-2">Login</div>
                    <button @click="startGame"
                        class="bg-blue-500 md:hover:bg-blue-400 font-bold px-4 rounded">
                        Iniciar nova sala
                    </button>
                </div>
            </div>
        </div>
        <div class="flex h-full w-full justify-between">
            <div class="text-white flex flex-col justify-center items-center w-1/2 text-xl">
                <div>
                    <p class="text-4xl mb-8">Bem-vindo ao <span
                            class="underline-offset-4 underline text-blue-500 font-bold">Free
                            Planning Poker</span></p>
                    <div class="mb-8">
                        A solução perfeita para os planejamentos de sprint da sua equipe
                    </div>
                </div>
                <div class="w-[600px]">
                    <!-- galeria de imagens -->
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
                </div>
                <div class="flex align-center gap-2 mt-8">
                    <p class="text-xs">Criado por:</p>
                    <div class="cursor-pointer flex align-center gap-2">
                        <p class="text-xs">vapdev </p>
                        <Icon name="uil:github" color="black" />
                    </div>
                </div>
            </div>
            <div class="text-white flex flex-col justify-center items-center w-1/2 text-2xl">
                <p class="text-3xl mb-4 font-bold">Jogue agora gratuitamente!</p>
                <div class="flex flex-col font-bold text-xl py-8 gap-16">
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
                                <input v-model="roomUUID"
                                    class="border-2 outline outline-blue-500 text-gray-800 h-12 rounded pl-2"
                                    placeholder="Insira o link da sala" />
                                <button @click="loadGame(roomUUID)"
                                    class="outline outline-blue-500 md:hover:bg-blue-500 text-white font-bold py-2 px-4 rounded">
                                    Entrar
                                </button>
                            </div>
                        </div>
                    </template>
                    <!-- <div class="flex h-10">
              <input v-model="nome" class="border-2 w-40 rounded pl-2" placeholder="Seu nome aqui" />
            </div> -->
                </div>
            </div>
        </div>
        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalCriar">
            <div class="relative rounded-lg font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon @click="modalCriar = false"
                        class=" md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out" size="38"
                        name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="mb-4 text-white text-4xl">Criando sala</div>
                <div class="text-md flex flex-col gap-4 text-white">
                    <div>Nome da sala: (Opcional)</div>
                    <div class="flex w-full gap-4">
                        <input v-model="roomName"
                            class="border-2 text-gray-800 outline-offset-2 outline outline-blue-500 h-10 w-full  rounded pl-2"
                            placeholder="Nome da sala" />
                    </div>
                </div>
                <div class="text-md flex flex-col gap-4 text-white">
                    <div>Seu nome: (Como os outros irão te ver)</div>
                    <div class="flex w-full gap-4">
                        <input v-model="userName"
                            class="border-2 text-gray-800 outline outline-blue-500 h-10 w-full rounded pl-2"
                            placeholder="Seu nome" />
                    </div>
                </div>
                <button @click="userStore.startGame(roomName, userName)"
                    class=" bg-blue-500 mt-6 w-full md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded">
                    Iniciar
                </button>
            </div>
        </UModal>
        <UModal :ui="{ overlay: { background: 'bg-blue-200/40' } }" v-model="modalEntrar">
            <div class="relative rounded-lg font-bold bg-[#3f4146] p-12 flex flex-col gap-6">
                <div class="absolute cursor-pointer text-white flex top-2 right-2">
                    <Icon @click="modalCriar = false"
                        class=" md:hover:bg-gray-500 p-0.5 rounded-full transition-all duration-250 ease-out" size="38"
                        name="material-symbols:close-small-rounded"></Icon>
                </div>
                <div class="mb-4 text-white text-4xl">Entrar em sala</div>
                <div class="text-md flex flex-col gap-4 text-white">
                    <div>Seu nome:</div>
                    <div class="flex w-full gap-4">
                        <input v-model="roomUUID"
                            class="border-2 outline outline-blue-500 text-gray-800 h-10 w-full rounded pl-2"
                            placeholder="Seu nome" />
                    </div>
                </div>
                <button @click="startGame"
                    class=" bg-blue-500 mt-24 w-full md:hover:bg-blue-400 text-white font-bold py-2 px-4 rounded">
                    Entrar
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

const roomName = ref('');
const userName = ref('');

const startGame = () => {
    modalCriar.value = true;
    // userStore.startGame();
}

const loadGame = (roomUUID) => {
    modalEntrar.value = true;
    // userStore.loadGame(roomUUID);
}
</script>