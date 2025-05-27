<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white relative overflow-hidden atkinson-hyperlegible-mono-regular">
    <!-- Animated background elements -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 4s;"></div>
    </div>

    <header class="relative z-10 backdrop-blur-sm bg-white/5 border-b border-white/10 py-6">
      <div class="container mx-auto flex justify-between items-center px-6">
        <h1 class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          Vitor Bohn
        </h1>
        <nav class="hidden md:flex space-x-8">
          <a href="#sobre" class="px-4 hover:text-purple-300 transition-colors duration-300">Sobre</a>
          <a href="#projetos" class="px-4 hover:text-purple-300 transition-colors duration-300">Projetos</a>
          <a href="#contato" class="px-4 hover:text-purple-300 transition-colors duration-300">Contato</a>
        </nav>
      </div>
    </header>

    <section id="sobre" class="relative z-10 py-20 text-center">
      <div class="container mx-auto px-6">
        <h2 class="text-5xl font-extrabold bg-gradient-to-r from-white via-purple-200 to-pink-200 bg-clip-text text-transparent mb-8 animate-fade-in">
          Sobre Mim
        </h2>
        <p class="text-xl text-gray-300 max-w-4xl mx-auto leading-relaxed animate-fade-in-delay">
          Olá! Sou um desenvolvedor Full Stack com mais de 4 anos de experiência em JavaScript, Vue, PHP, Python e Go. 
          Adoro resolver problemas complexos e criar soluções eficientes e escaláveis.
        </p>
      </div>
    </section>

    <section id="projetos" class="relative z-10 py-20">
      <div class="container mx-auto px-6 text-center">
        <h2 class="text-5xl font-extrabold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-8">
          Projetos
        </h2>
        <p class="text-xl text-gray-400 mb-16">Confira alguns dos projetos que desenvolvi recentemente.</p>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10">
            <div class="absolute inset-0 bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <h3 class="text-2xl font-semibold text-white mb-4">Planning Poker Online</h3>
              <p class="text-gray-300 mb-6 leading-relaxed">Uma aplicação de Planning Poker online, projetada para facilitar a colaboração em equipe na estimativa de tarefas.</p>
              <a href="https://planning.codestation.com.br" target="_blank" 
                 class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white font-semibold rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-300 transform hover:scale-105">
                Ver Projeto
                <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                </svg>
              </a>
            </div>
          </div>
          
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10" style="animation-delay: 0.2s;">
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-purple-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <h3 class="text-2xl font-semibold text-white mb-4">Marketplace para Escolas</h3>
              <p class="text-gray-300 mb-6 leading-relaxed">Um marketplace para escolas venderem materiais como kits de livros, com integrações de pagamento e sistema de pedidos.</p>
              <a href="#" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white font-semibold rounded-lg hover:from-blue-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105">
                Ver Projeto
                <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                </svg>
              </a>
            </div>
          </div>
          
          <div class="group relative p-8 backdrop-blur-sm bg-white/5 border border-white/10 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:bg-white/10" style="animation-delay: 0.4s;">
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/10 to-blue-500/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="relative z-10">
              <h3 class="text-2xl font-semibold text-white mb-4">Chatbot para ERP Agroindustrial</h3>
              <p class="text-gray-300 mb-6 leading-relaxed">Um chatbot integrado a um ERP, facilitando a interação e automação de processos no setor agroindustrial.</p>
              <a href="#" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-indigo-600 to-blue-600 text-white font-semibold rounded-lg hover:from-indigo-700 hover:to-blue-700 transition-all duration-300 transform hover:scale-105">
                Ver Projeto
                <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                </svg>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section id="contato" class="relative z-10 py-20">
      <div class="container mx-auto px-6 text-center">
        <h2 class="text-5xl font-extrabold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-8">
          Contato
        </h2>
        <p class="text-xl text-gray-400 mb-12">Entre em contato para mais informações ou para discutir possíveis colaborações!</p>
        <a href="mailto:vpbohn@gmail.com" 
           class="group relative inline-flex items-center justify-center px-12 py-4 text-xl font-semibold text-white transition-all duration-300 ease-out transform hover:scale-105 hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900">
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl shadow-lg group-hover:shadow-purple-500/25 group-hover:shadow-2xl transition-all duration-300"></div>
          <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl opacity-0 group-hover:opacity-100 blur transition-opacity duration-300"></div>
          <span class="relative z-10 flex items-center">
            Enviar E-mail
            <svg class="w-6 h-6 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
            </svg>
          </span>
        </a>
      </div>
    </section>

    <footer class="bg-blue-900 text-white text-center py-6">
      <p>&copy; 2025. Criado com ❤️ por <a href="https://github.com/vapdev" target="_blank" class="hover:text-blue-300">vapdev</a>.</p>
    </footer>
  </div>
</template>

<script setup>
// Aqui você pode adicionar qualquer lógica de Vue, como data, métodos, etc.
</script>
