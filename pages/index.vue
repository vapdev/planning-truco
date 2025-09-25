<template>
  <div class="landing-page min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-gray-900 text-white relative overflow-hidden">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-indigo-500/15 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-slate-500/8 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
      <div class="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-blue-500/30 to-transparent"></div>
    </div>

    <!-- Navigation Header -->
    <header class="relative z-20 backdrop-blur-sm bg-white/5 border-b border-white/10 py-4">
      <nav class="container mx-auto flex justify-between items-center px-6">
        <div class="flex items-center space-x-2">
          <img src="/favicon.ico" alt="Planning Poker" class="w-8 h-8 sm:mr-2" style="filter: brightness(0) saturate(100%) invert(47%) sepia(96%) saturate(1352%) hue-rotate(197deg) brightness(94%) contrast(101%);" />
          <h1 class="text-xl sm:text-2xl font-bold bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
            Planning Poker Online
          </h1>
        </div>
        <div class="flex items-center space-x-4">
          <LanguageSelector />
          <button @click="startGame" 
                  class="hidden sm:inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white text-sm font-medium rounded-lg transition-all duration-300 hover:scale-105 shadow-lg">
            {{ $t('getStarted') }}
          </button>
        </div>
      </nav>
    </header>

    <main class="landing-main relative z-10">
      <!-- Hero Section -->
      <section class="container mx-auto px-6 pt-16 pb-24 text-center">
        <div class="max-w-4xl mx-auto">
          <!-- Badge -->
          <div class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-500/20 to-indigo-500/20 border border-blue-500/30 rounded-full text-sm text-blue-300 mb-8 backdrop-blur-sm">
            <span class="w-2 h-2 bg-green-400 rounded-full mr-2 animate-pulse"></span>
            {{ $t('freePowerfulTool') }}
          </div>

          <h1 class="text-4xl sm:text-5xl lg:text-7xl font-extrabold leading-tight mb-6 bg-gradient-to-r from-white via-gray-200 to-blue-200 bg-clip-text text-transparent">
            {{ $t('heroTitle') }}
          </h1>
          
          <p class="text-lg sm:text-xl text-gray-300 max-w-3xl mx-auto mb-8 leading-relaxed">
            {{ $t('heroSubtitle') }}
          </p>
          
          <!-- CTA Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
            <button @click="startGame"
              class="group relative inline-flex items-center justify-center px-8 py-4 text-lg font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 focus:outline-none">
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
              <span class="relative z-10 flex items-center">
                {{ $t('startForFree') }}
                <svg class="w-5 h-5 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                </svg>
              </span>
            </button>
            <a href="https://github.com/vapdev/planning-truco" target="_blank"
               class="inline-flex items-center px-8 py-4 text-lg font-medium text-gray-300 hover:text-white border border-gray-600 hover:border-gray-500 rounded-xl transition-all duration-300 hover:bg-gray-800/50 backdrop-blur-sm">
              <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
              {{ $t('viewSource') }}
            </a>
          </div>

          <!-- Social Proof -->
          <div class="flex flex-col items-center">
            <p class="text-sm text-gray-400 mb-4">{{ $t('trustedByTeams') }}</p>
            <div class="flex items-center space-x-8 opacity-60">
              <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full flex items-center justify-center">
                  <span class="text-white font-bold text-xs">A</span>
                </div>
                <span class="text-gray-400 font-medium">Agile Teams</span>
              </div>
              <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gradient-to-r from-green-500 to-emerald-500 rounded-full flex items-center justify-center">
                  <span class="text-white font-bold text-xs">S</span>
                </div>
                <span class="text-gray-400 font-medium">Scrum Masters</span>
              </div>
              <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gradient-to-r from-orange-500 to-red-500 rounded-full flex items-center justify-center">
                  <span class="text-white font-bold text-xs">D</span>
                </div>
                <span class="text-gray-400 font-medium">Dev Teams</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Features Section -->
      <section class="container mx-auto px-6 py-24">
        <div class="text-center mb-16">
          <h2 class="text-3xl sm:text-4xl font-bold mb-4 bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
            {{ $t('whyChooseUs') }}
          </h2>
          <p class="text-xl text-gray-300 max-w-2xl mx-auto">
            {{ $t('featuresSubtitle') }}
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- Feature 1: Real-time -->
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all duration-300 hover:-translate-y-2">
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-indigo-500/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-500 rounded-lg flex items-center justify-center mb-4 shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white">{{ $t('realTimeVoting') }}</h3>
              <p class="text-gray-300 leading-relaxed">{{ $t('realTimeDescription') }}</p>
            </div>
          </div>

          <!-- Feature 2: No Registration -->
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all duration-300 hover:-translate-y-2">
            <div class="absolute inset-0 bg-gradient-to-br from-slate-500/10 to-gray-500/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-12 h-12 bg-gradient-to-br from-slate-500 to-gray-600 rounded-lg flex items-center justify-center mb-4 shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white">{{ $t('noRegistration') }}</h3>
              <p class="text-gray-300 leading-relaxed">{{ $t('noRegistrationDescription') }}</p>
            </div>
          </div>

          <!-- Feature 3: Multiple Decks -->
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all duration-300 hover:-translate-y-2">
            <div class="absolute inset-0 bg-gradient-to-br from-emerald-500/10 to-teal-500/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-12 h-12 bg-gradient-to-br from-emerald-500 to-teal-500 rounded-lg flex items-center justify-center mb-4 shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white">{{ $t('customDecks') }}</h3>
              <p class="text-gray-300 leading-relaxed">{{ $t('customDecksDescription') }}</p>
            </div>
          </div>

          <!-- Feature 4: Multi-language -->
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all duration-300 hover:-translate-y-2">
            <div class="absolute inset-0 bg-gradient-to-br from-amber-500/10 to-orange-500/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-12 h-12 bg-gradient-to-br from-amber-500 to-orange-500 rounded-lg flex items-center justify-center mb-4 shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white">{{ $t('multiLanguage') }}</h3>
              <p class="text-gray-300 leading-relaxed">{{ $t('multiLanguageDescription') }}</p>
            </div>
          </div>

          <!-- Feature 5: Mobile Friendly -->
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all duration-300 hover:-translate-y-2">
            <div class="absolute inset-0 bg-gradient-to-br from-cyan-500/10 to-sky-500/10 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-12 h-12 bg-gradient-to-br from-cyan-500 to-sky-500 rounded-lg flex items-center justify-center mb-4 shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a1 1 0 001-1V4a1 1 0 00-1-1H8a1 1 0 00-1 1v16a1 1 0 001 1z"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white">{{ $t('mobileFriendly') }}</h3>
              <p class="text-gray-300 leading-relaxed">{{ $t('mobileFriendlyDescription') }}</p>
            </div>
          </div>

        </div>
      </section>

      <!-- How It Works Section -->
      <section class="container mx-auto px-6 py-24 bg-gradient-to-b from-transparent to-slate-900/50">
        <div class="text-center mb-16">
          <h2 class="text-3xl sm:text-4xl font-bold mb-4 bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">
            {{ $t('howItWorks') }}
          </h2>
          <p class="text-xl text-gray-300 max-w-2xl mx-auto">
            {{ $t('howItWorksSubtitle') }}
          </p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <div class="text-center">
            <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-500 rounded-full flex items-center justify-center mb-6 mx-auto shadow-xl">
              <span class="text-2xl font-bold text-white">1</span>
            </div>
            <h3 class="text-xl font-semibold mb-4 text-white">{{ $t('step1') }}</h3>
            <p class="text-gray-300 leading-relaxed">{{ $t('step1Description') }}</p>
          </div>
          
          <div class="text-center">
            <div class="w-16 h-16 bg-gradient-to-br from-slate-500 to-gray-600 rounded-full flex items-center justify-center mb-6 mx-auto shadow-xl">
              <span class="text-2xl font-bold text-white">2</span>
            </div>
            <h3 class="text-xl font-semibold mb-4 text-white">{{ $t('step2') }}</h3>
            <p class="text-gray-300 leading-relaxed">{{ $t('step2Description') }}</p>
          </div>
          
          <div class="text-center">
            <div class="w-16 h-16 bg-gradient-to-br from-emerald-500 to-teal-500 rounded-full flex items-center justify-center mb-6 mx-auto shadow-xl">
              <span class="text-2xl font-bold text-white">3</span>
            </div>
            <h3 class="text-xl font-semibold mb-4 text-white">{{ $t('step3') }}</h3>
            <p class="text-gray-300 leading-relaxed">{{ $t('step3Description') }}</p>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="container mx-auto px-6 py-24 text-center">
        <div class="max-w-4xl mx-auto">
          <div class="backdrop-blur-sm bg-gradient-to-br from-white/5 to-white/10 border border-white/10 rounded-2xl p-12 shadow-2xl">
            <h2 class="text-3xl sm:text-4xl font-bold mb-6 bg-gradient-to-r from-white via-blue-200 to-indigo-200 bg-clip-text text-transparent">
              {{ $t('readyToStart') }}
            </h2>
            <p class="text-xl text-gray-300 mb-8 max-w-2xl mx-auto">
              {{ $t('ctaDescription') }}
            </p>
            <button @click="startGame"
              class="group relative inline-flex items-center justify-center px-12 py-4 text-lg font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 focus:outline-none">
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl shadow-lg group-hover:shadow-blue-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
              <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
              <span class="relative z-10 flex items-center">
                {{ $t('createRoomNow') }}
                <svg class="w-5 h-5 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                </svg>
              </span>
            </button>
          </div>
        </div>
      </section>
    </main>

    <!-- Footer -->
    <footer class="landing-footer relative z-10 backdrop-blur-sm bg-white/5 border-t border-white/10 py-6">
      <div class="container mx-auto px-6">
        <div class="flex flex-col items-center space-y-4">
          <div class="flex flex-wrap justify-center gap-6 text-sm">
            <NuxtLink to="/privacy-policy" 
                     class="text-gray-300 hover:text-blue-400 transition-colors duration-300 hover:underline">
              {{ $t('privacyPolicy') }}
            </NuxtLink>
            <NuxtLink to="/terms-of-service" 
                     class="text-gray-300 hover:text-blue-400 transition-colors duration-300 hover:underline">
              {{ $t('termsOfService') }}
            </NuxtLink>
            <a target="_blank" href="https://github.com/vapdev/planning-truco" 
               class="text-gray-300 hover:text-blue-400 transition-colors duration-300 hover:underline">
              {{ $t('sourceCode') }}
            </a>
          </div>
          <p class="text-gray-400 text-sm text-center">
            2025. {{ $t('madeWithLove') }} 
            <a target="_blank" href="https://github.com/vapdev" 
               class="text-blue-400 hover:text-blue-300 transition-colors duration-300 underline decoration-blue-400/50 hover:decoration-blue-300">
              vapdev
            </a>.
          </p>
        </div>
      </div>
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

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 1s ease-out;
}

.animate-fade-in-delay {
  animation: fade-in 1s ease-out 0.3s both;
}

.animate-fade-in-delay-2 {
  animation: fade-in 1s ease-out 0.6s both;
}

/* Enhanced glassmorphism effects */
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}

/* Custom gradient animations for background orbs */
@keyframes float {
  0%, 100% {
    transform: translateY(0px) scale(1);
  }
  50% {
    transform: translateY(-20px) scale(1.05);
  }
}

.animate-pulse {
  animation: float 6s ease-in-out infinite;
}

/* Smooth scrolling for the entire page */
html {
  scroll-behavior: smooth;
}

/* Enhanced hover effects for cards */
.group:hover .absolute {
  transform: scale(1.02);
}

/* Custom focus styles */
button:focus {
  outline: none;
}

/* Responsive adjustments for very small screens */
@media (max-height: 600px) {
  .main-content {
    padding-top: 1rem;
    padding-bottom: 1rem;
  }
  
  .hero-title {
    font-size: 2rem;
    margin-bottom: 0.5rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
    margin-bottom: 1rem;
  }
  
  .step-cards {
    gap: 0.5rem;
  }
  
  .step-card {
    padding: 0.75rem;
  }
}
</style>