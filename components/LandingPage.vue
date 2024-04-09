<template>
    <div class="w-full px-4 flex justify-between text-white items-center text-2xl bg-preto h-28">
        <div class="oswald-font text-green-500">Free Planning Poker</div>
        <div class="text-lg font-bold">
            <div class="flex gap-8">
                <div>Sign Up</div>
                <div>Login</div>
                <button @click="userStore.startGame" class="bg-green-500 w-60 md:hover:bg-green-400 font-bold px-4 rounded">
                    Iniciar nova sala
                </button>
            </div>
        </div>
    </div>
    <div class="flex justify-around h-full px-28 py-32">
        <div class="text-white text-xl">
            <p class="text-4xl mb-8">Bem-vindo ao <span class="underline-offset-4 underline text-green-500">Free
                    Planning Poker</span>!</p>

            <ul class="mb-8 list-disc pl-6">
                <li>Simples</li>
                <li>Em tempo real</li>
                <li>Acesse de qualquer dispositivo</li>
                <li>Jogue como convidado ou crie sua conta</li>
                <li class="mb-8">Sem limite de partidas, votos ou usuários</li>
                <li>Adicione o nome das tasks para votação (PREMIUM)</li>
                <li>Tenha acesso ao histórico das votações (PREMIUM)</li>
                <li>Exporte os resultados para CSV e Excel (PREMIUM)</li>
            </ul>

            <p class="my-32">Tenha acesso aos recursos <span
                    class="text-green-500 cursor-pointer underline">Premium</span>
            </p>
            <div class="flex align-center gap-2">
                <p class="text-xs">Criado por:</p>
                <div class="cursor-pointer flex align-center gap-2">
                    <p class="text-xs">vapdev </p>
                    <Icon name="uil:github" color="black" />
                </div>
            </div>
        </div>
        <div class="text-white text-2xl">
            <p class="text-3xl mb-4 font-bold">Jogue agora gratuitamente!</p>
            <div class="flex font-bold text-xl py-8 gap-16">
                <template v-if="!userStore.jogoComecou">
                    <div class="flex flex-col gap-6 text-white">
                        <p>Crie uma nova sala</p>
                        <button @click="userStore.startGame"
                            class="w-60 bg-green-500 md:hover:bg-green-400 text-white font-bold py-2 px-4 rounded">
                            Iniciar nova sala
                        </button>
                    </div>
                    <div class="flex flex-col gap-6 text-white">
                        <div>Ou entre em uma sala existente</div>
                        <div class="flex">
                            <input v-model="roomUUID" class="border-2 h-12 border-green-500 rounded pl-2"
                                placeholder="Insira o link da sala" />
                            <button @click="userStore.loadGame(roomUUID)"
                                class="bg-green-500 md:hover:bg-green-400 text-white font-bold py-2 px-4 rounded">
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
</template>

<script setup>
const userStore = useUserStore();
const roomUUID = ref('');
</script>