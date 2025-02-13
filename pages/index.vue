<template>
  <div class="flex flex-col h-screen bg-gray-50 text-gray-900">
    <header class="bg-indigo-600 text-white py-6 shadow-md">
      <div class="flex justify-between items-center px-6">
        <div class="container mx-auto flex justify-between items-center px-6">
          <h1 class="text-2xl font-bold">Planning Poker Online</h1>
        </div>
        <LanguageSelector />
      </div>
    </header>

    <main class="flex flex-1 flex-col items-center justify-center text-center px-6">
      <h2 class="text-4xl md:text-5xl font-extrabold leading-tight max-w-4xl pt-6">
        {{ $t('simpleFastEfficient') }}
      </h2>
      <p class="mt-4 text-lg text-gray-700 max-w-2xl">
        {{ $t('subtitle') }}
      </p>
      <button @click="startGame"
        class="mt-6 bg-indigo-500 hover:bg-indigo-600 text-white font-semibold py-3 px-8 rounded-lg shadow-lg text-xl">
        {{ $t('createRoom') }}
      </button>
    </main>

    <section class="flex-1 flex flex-col py-12 bg-white shadow-inner w-full text-center px-6">
      <div class="max-w-4xl mx-auto">
        <h3 class="text-3xl font-bold">{{ $t('howItWorks') }}</h3>
        <p class="mt-4 text-lg text-gray-700">{{ $t('simpleFastEfficient') }}</p>
        <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">{{ $t('step1') }}</h4>
            <p class="text-gray-600 mt-2">{{ $t('step1Description') }}</p>
          </div>
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">{{ $t('step2') }}</h4>
            <p class="text-gray-600 mt-2">{{ $t('step2Description') }}</p>
          </div>
          <div class="p-6 bg-gray-200 rounded-lg shadow">
            <h4 class="text-xl font-semibold">{{ $t('step3') }}</h4>
            <p class="text-gray-600 mt-2">{{ $t('step3Description') }}</p>
          </div>
        </div>
      </div>
    </section>
    <footer class="bg-gray-800 text-white text-center py-4">
      <p>2025. {{ $t('madeWithLove') }} <a target="_blank" href="https://github.com/vapdev">vapdev</a>.</p>
    </footer>
  </div>
</template>

<script setup>
const { gtag } = useGtag();
const router = useRouter();
const startGame = () => {
  gtag("event", "start_game");
  router.push("/new");
};
</script>