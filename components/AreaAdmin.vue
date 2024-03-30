<template>

    <div class="flex flex-col text-white gap-4">
        <div class="flex gap-2">
            <div @click="virarAutomatico = !virarAutomatico"
                class="hover:bg-gray-500 w-7 rounded-lg cursor-pointer h-7 border-2 border-white justify-center flex items-center">
                <div v-if="virarAutomatico" class="font-bold text-green-400 text-xl">
                    ✓
                </div>
            </div>
            <div>Virar automaticamente após todos jogadores votarem</div>
        </div>
        <div v-if="!virarAutomatico" class="text-red-500">
            <button @click="mostrarCartas = !mostrarCartas" class="text-white font-bold py-2 px-4 rounded w-40" :class="mostrarCartas
                ? 'bg-red-500 hover:bg-red-700'
                : 'bg-green-500 hover:bg-green-700'
                ">
                <span v-if="mostrarCartas">Esconder cartas</span>
                <span v-else>Mostrar cartas</span>
            </button>
        </div>
        <div>
            <button @click="novaRodada" class="w-40 text-white font-bold py-2 px-4 rounded bg-blue-500">
                <span>Nova rodada</span>
            </button>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    virarAutomatico: Boolean,
    mostrarCartas: Boolean,
    novaRodada: Function
})
</script>