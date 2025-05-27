<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white relative overflow-hidden">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <header class="relative z-10 backdrop-blur-sm bg-white/5 border-b border-white/10 py-6">
      <div class="container mx-auto flex justify-between items-center px-6">
        <h1 class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          Planning Poker Online
        </h1>
        <LanguageSelector />
      </div>
    </header>

    <main class="relative z-10 flex flex-col items-center justify-center text-center px-6 py-20">
      <!-- Hero Section -->
      <div class="max-w-6xl mx-auto">
        <h2 class="text-5xl md:text-7xl font-extrabold leading-tight mb-8 bg-gradient-to-r from-white via-purple-200 to-pink-200 bg-clip-text text-transparent animate-fade-in">
          {{ $t('simpleFastEfficient') }}
        </h2>
        <p class="text-xl md:text-2xl text-gray-300 max-w-3xl mx-auto mb-12 leading-relaxed animate-fade-in-delay">
          {{ $t('subtitle') }}
        </p>
        
        <!-- CTA Button -->
        <button @click="startGame"
          class="group relative inline-flex items-center justify-center px-12 py-4 text-xl font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900 animate-fade-in-delay-2">
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl shadow-lg group-hover:shadow-purple-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
          <span class="relative z-10 flex items-center">
            {{ $t('createRoom') }}
            <svg class="w-6 h-6 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
            </svg>
          </span>
        </button>
      </div>
    </main>

    <!-- How it works section -->
    <section class="relative z-10 py-20 px-6">
      <div class="max-w-7xl mx-auto">
        <div class="text-center mb-16">
          <h3 class="text-4xl md:text-5xl font-bold mb-6 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
            {{ $t('howItWorks') }}
          </h3>
          <p class="text-xl text-gray-400 max-w-2xl mx-auto">
            {{ $t('simpleFastEfficient') }}
          </p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10">
            <div class="absolute inset-0 bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center mb-6 mx-auto shadow-lg">
                <span class="text-2xl font-bold text-white">1</span>
              </div>
              <h4 class="text-2xl font-semibold mb-4 text-white">{{ $t('step1') }}</h4>
              <p class="text-gray-300 leading-relaxed">{{ $t('step1Description') }}</p>
            </div>
          </div>
          
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10" style="animation-delay: 0.2s;">
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-purple-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-500 rounded-xl flex items-center justify-center mb-6 mx-auto shadow-lg">
                <span class="text-2xl font-bold text-white">2</span>
              </div>
              <h4 class="text-2xl font-semibold mb-4 text-white">{{ $t('step2') }}</h4>
              <p class="text-gray-300 leading-relaxed">{{ $t('step2Description') }}</p>
            </div>
          </div>
          
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10" style="animation-delay: 0.4s;">
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/10 to-blue-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <div class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-blue-500 rounded-xl flex items-center justify-center mb-6 mx-auto shadow-lg">
                <span class="text-2xl font-bold text-white">3</span>
              </div>
              <h4 class="text-2xl font-semibold mb-4 text-white">{{ $t('step3') }}</h4>
              <p class="text-gray-300 leading-relaxed">{{ $t('step3Description') }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="relative z-10 backdrop-blur-sm bg-white/5 border-t border-white/10 py-8">
      <div class="container mx-auto text-center px-6">
        <p class="text-gray-400">
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
</style>