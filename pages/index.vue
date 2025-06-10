<template>
  <div class="h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white relative flex flex-col">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <header class="relative z-20 backdrop-blur-sm bg-white/5 border-b border-white/10 py-3 overflow-visible">
      <div class="container mx-auto flex justify-between items-center px-6 overflow-visible">
        <h1 class="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          Planning Poker Online
        </h1>
        <LanguageSelector />
      </div>
    </header>

    <main class="relative z-10 flex flex-col items-center justify-center text-center px-4 py-4 sm:py-8 flex-1">
      <!-- Hero Section -->
      <div class="max-w-4xl mx-auto">
        <h2 class="text-2xl sm:text-3xl md:text-5xl font-extrabold leading-tight mb-2 sm:mb-4 bg-gradient-to-r from-white via-purple-200 to-pink-200 bg-clip-text text-transparent animate-fade-in hero-title">
          {{ $t('simpleFastEfficient') }}
        </h2>
        <p class="text-sm sm:text-lg md:text-xl text-gray-300 max-w-2xl mx-auto mb-4 sm:mb-6 leading-relaxed animate-fade-in-delay hero-subtitle">
          {{ $t('subtitle') }}
        </p>
        
        <!-- CTA Button -->
        <button @click="startGame"
          class="group relative inline-flex items-center justify-center px-8 sm:px-10 py-2.5 sm:py-3 text-base sm:text-lg font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900 animate-fade-in-delay-2 mb-4 sm:mb-8">
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl shadow-lg group-hover:shadow-purple-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
          <span class="relative z-10 flex items-center">
            {{ $t('createRoom') }}
            <svg class="w-4 h-4 sm:w-5 sm:h-5 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
            </svg>
          </span>
        </button>
      </div>
      
      <!-- Compact How it works section -->
      <div class="max-w-5xl mx-auto w-full">
        <div class="text-center mb-3 sm:mb-6">
          <h3 class="text-xl sm:text-2xl md:text-3xl font-bold mb-1 sm:mb-3 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
            {{ $t('howItWorks') }}
          </h3>
        </div>
        
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-2 sm:gap-4 step-cards">
          <div class="group relative p-3 sm:p-4 backdrop-blur-sm bg-white/5 border border-white/10 rounded-lg sm:rounded-xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 hover:bg-white/10 step-card">
            <div class="absolute inset-0 bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-lg sm:rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-10 h-10 sm:w-12 sm:h-12 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center justify-center mb-2 sm:mb-3 mx-auto shadow-lg">
                <span class="text-base sm:text-lg font-bold text-white">1</span>
              </div>
              <h4 class="text-base sm:text-lg font-semibold mb-1 sm:mb-2 text-white">{{ $t('step1') }}</h4>
              <p class="text-gray-300 text-xs sm:text-sm leading-relaxed">{{ $t('step1Description') }}</p>
            </div>
          </div>
          
          <div class="group relative p-3 sm:p-4 backdrop-blur-sm bg-white/5 border border-white/10 rounded-lg sm:rounded-xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 hover:bg-white/10 step-card">
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-purple-500/10 rounded-lg sm:rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-10 h-10 sm:w-12 sm:h-12 bg-gradient-to-br from-blue-500 to-purple-500 rounded-lg flex items-center justify-center mb-2 sm:mb-3 mx-auto shadow-lg">
                <span class="text-base sm:text-lg font-bold text-white">2</span>
              </div>
              <h4 class="text-base sm:text-lg font-semibold mb-1 sm:mb-2 text-white">{{ $t('step2') }}</h4>
              <p class="text-gray-300 text-xs sm:text-sm leading-relaxed">{{ $t('step2Description') }}</p>
            </div>
          </div>
          
          <div class="group relative p-3 sm:p-4 backdrop-blur-sm bg-white/5 border border-white/10 rounded-lg sm:rounded-xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 hover:bg-white/10 step-card">
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/10 to-blue-500/10 rounded-lg sm:rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-10 h-10 sm:w-12 sm:h-12 bg-gradient-to-br from-indigo-500 to-blue-500 rounded-lg flex items-center justify-center mb-2 sm:mb-3 mx-auto shadow-lg">
                <span class="text-base sm:text-lg font-bold text-white">3</span>
              </div>
              <h4 class="text-base sm:text-lg font-semibold mb-1 sm:mb-2 text-white">{{ $t('step3') }}</h4>
              <p class="text-gray-300 text-xs sm:text-sm leading-relaxed">{{ $t('step3Description') }}</p>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="relative z-10 backdrop-blur-sm bg-white/5 border-t border-white/10 py-4 mt-auto">
      <div class="container mx-auto text-center px-6">
        <p class="text-gray-400 text-sm">
          2025. {{ $t('madeWithLove') }} 
          <a target="_blank" href="https://github.com/vapdev" 
             class="text-purple-400 hover:text-purple-300 transition-colors duration-300 underline decoration-purple-400/50 hover:decoration-purple-300">
            vapdev
          </a>.
        </p>
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