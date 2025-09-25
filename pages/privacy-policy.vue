<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white">
    <header class="backdrop-blur-sm bg-white/5 border-b border-white/10 py-3">
      <div class="container mx-auto flex justify-between items-center px-6">
        <NuxtLink to="/" class="text-xl sm:text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent hover:opacity-80 transition-opacity">
          Planning Poker Online
        </NuxtLink>
        <LanguageSelector />
      </div>
    </header>

    <main class="container mx-auto px-6 py-12 max-w-4xl">
      <div class="backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl p-8 shadow-2xl">
        <h1 class="text-3xl sm:text-4xl font-bold mb-8 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          {{ $t('privacyPolicy') }}
        </h1>
        
        <div class="prose prose-invert prose-purple max-w-none">
          <p class="text-gray-300 mb-6 text-lg">
            {{ $t('lastUpdated') }}: {{ new Date().toLocaleDateString() }}
          </p>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">1. {{ $t('informationWeCollect') }}</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyInfo1') }}
            </p>
            <ul class="list-disc list-inside text-gray-300 space-y-2 ml-4">
              <li>{{ $t('privacyInfo1a') }}</li>
              <li>{{ $t('privacyInfo1b') }}</li>
              <li>{{ $t('privacyInfo1c') }}</li>
              <li>{{ $t('privacyInfo1d') }}</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">2. {{ $t('howWeUseInfo') }}</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyInfo2') }}
            </p>
            <ul class="list-disc list-inside text-gray-300 space-y-2 ml-4">
              <li>{{ $t('privacyInfo2a') }}</li>
              <li>{{ $t('privacyInfo2b') }}</li>
              <li>{{ $t('privacyInfo2c') }}</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">3. Google AdSense</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyAdsense') }}
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">4. {{ $t('dataStorage') }}</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyInfo4') }}
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">5. {{ $t('yourRights') }}</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyInfo5') }}
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-purple-300">6. {{ $t('contactUs') }}</h2>
            <p class="text-gray-300 mb-4">
              {{ $t('privacyContact') }}: 
              <a href="https://github.com/vapdev" target="_blank" class="text-purple-400 hover:text-purple-300 underline">
                github.com/vapdev
              </a>
            </p>
          </section>
        </div>

        <div class="mt-12 pt-8 border-t border-white/10">
          <NuxtLink to="/" 
                   class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white font-semibold rounded-lg transition-all duration-300 hover:scale-105 shadow-lg">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
            </svg>
            {{ $t('backToHome') }}
          </NuxtLink>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
// SEO meta tags
useHead({
  title: 'Privacy Policy - Planning Poker Online',
  meta: [
    { name: 'description', content: 'Privacy policy for Planning Poker Online application' },
    { name: 'robots', content: 'index,follow' }
  ]
})
</script>