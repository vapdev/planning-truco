<template>
  <div class="flex flex-col h-screen bg-gray-50 text-gray-900">
    <header class="bg-indigo-600 text-white py-6 shadow-md">
      <div class="container mx-auto flex justify-between items-center px-6">
        <h1 class="text-2xl font-bold">Planning Poker Online</h1>
      </div>
    </header>

    <main class="flex-1 flex flex-col items-center justify-center text-center px-6">
      <h2 class="text-4xl md:text-5xl font-extrabold leading-tight max-w-3xl pt-6">
        Facilite suas estimativas de sprint com nosso Planning Poker gratuito!
      </h2>
      <p class="mt-4 text-lg text-gray-700 max-w-2xl">
        Crie uma sala, convide sua equipe e tome decisões com mais colaboração e eficiência.
      </p>
      <button @click="startGame" class="mt-6 bg-indigo-500 hover:bg-indigo-600 text-white font-semibold py-3 px-8 rounded-lg shadow-lg text-xl">
        Criar Sala Agora
      </button>
    </main>

    <section class="py-12 bg-white shadow-inner w-full text-center px-6">
      <div class="max-w-4xl mx-auto">
        <h3 class="text-3xl font-bold">Como Funciona?</h3>
        <p class="mt-4 text-lg text-gray-700">Simples, rápido e eficiente.</p>
        <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">1. Crie uma sala</h4>
            <p class="text-gray-600 mt-2">Basta clicar no botão acima e gerar uma sala única.</p>
          </div>
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">2. Compartilhe o link</h4>
            <p class="text-gray-600 mt-2">Convide seu time enviando o link da sala para os membros.</p>
          </div>
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">3. Vote e decida</h4>
            <p class="text-gray-600 mt-2">Cada membro vota e o resultado é exibido em tempo real.</p>
          </div>
        </div>
      </div>
    </section>
    <footer class="bg-gray-800 text-white text-center py-4">
      <p>2025. Feito com ❤️ por <a href="https://github.com/vapdev">vapdev</a>.</p>
    </footer>
  </div>
</template>

<script setup>
const router = useRouter();
const startGame = () => {
  router.push("/new");
};
</script>