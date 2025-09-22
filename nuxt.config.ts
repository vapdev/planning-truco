// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: false },
  devServer: {
    host: '0.0.0.0',
    port: 3000
  },

  modules: [
    '@nuxt/ui',
    '@nuxtjs/tailwindcss',
    '@nuxtjs/i18n',
    '@nuxtjs/google-fonts',
    'nuxt-icon',
    '@pinia/nuxt',
    '@vueuse/nuxt',
    'nuxt-gtag',
  ],

  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_API_BASE || 'http://localhost:8080',
      wsBase: process.env.NUXT_WS_BASE || 'ws://localhost:8080'
    }
  },

  ssr: false,

  googleFonts: {
    download: true,
    families: {
      Oswald: true,
      Rubik: true,
      "Atkinson Hyperlegible Mono": true,
    }
  },

  css: ['~/assets/css/main.css'],

  gtag: {
    id: process.env.NUXT_GTAG_ID,
  },

 i18n: {
    // --- Configurações Gerais ---
    // strategy: 'prefix_except_default', // ou a estratégia que preferir
    defaultLocale: 'en', // Idioma padrão

    // --- Configuração do Lazy Loading ---
    lazy: true,
    langDir: 'locales', // O diretório que você já criou
    strategy: 'no_prefix', // Estratégia de prefixo, pode ser ajustada conforme necessário

    // --- O MAPEAMENTO CORRETO ---
    // Aqui você define cada idioma e aponta para o seu arquivo.
    locales: [
      {
        code: 'en',
        iso: 'en-US',
        name: 'English',
        file: 'en.ts' // <-- A propriedade 'file' que estava faltando
      },
      {
        code: 'pt',
        iso: 'pt-BR',
        name: 'Português',
        file: 'pt.ts'
      },
      {
        code: 'fr',
        iso: 'fr-FR',
        name: 'Français',
        file: 'fr.ts'
      },
      {
        code: 'es',
        iso: 'es-ES',
        name: 'Español',
        file: 'es.ts'
      },
      {
        code: 'zh',
        iso: 'zh-CN',
        name: '中文',
        file: 'zh.ts'
      },
      {
        code: 'ar',
        iso: 'ar-SA',
        name: 'العربية',
        file: 'ar.ts'
      },
      {
        code: 'de',
        iso: 'de-DE',
        name: 'Deutsch',
        file: 'de.ts'
      },
      {
        code: 'it',
        iso: 'it-IT',
        name: 'Italiano',
        file: 'it.ts'
      },
      {
        code: 'ja',
        iso: 'ja-JP',
        name: '日本語',
        file: 'ja.ts'
      },
      {
        code: 'pl',
        iso: 'pl-PL',
        name: 'Polski',
        file: 'pl.ts'
      },
      {
        code: 'ru',
        iso: 'ru-RU',
        name: 'Русский',
        file: 'ru.ts'
      },
      {
        code: 'ko',
        iso: 'ko-KR',
        name: '한국어',
        file: 'ko.ts'
      }
    ],
  },

  compatibilityDate: '2025-02-14'
})