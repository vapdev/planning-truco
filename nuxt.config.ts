// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: false },

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

  colorMode: {
    preference: 'light'
  },

  css: ['~/assets/css/main.css'],

  gtag: {
    id: process.env.NUXT_GTAG_ID,
  },

  i18n: {
    locales: [
      { code: 'en', language: 'en-US' },
      { code: 'pt', language: 'pt-BR' },
      { code: 'es', language: 'es-ES' },
      { code: 'fr', language: 'fr-FR' },
      { code: 'zh', language: 'zh-CN' },
      { code: 'ar', language: 'ar-SA' },
      { code: 'de', language: 'de-DE' },
      { code: 'it', language: 'it-IT' },
      { code: 'ja', language: 'ja-JP' },
      { code: 'pl', language: 'pl-PL' },
      { code: 'ru', language: 'ru-RU' },
      { code: 'ko', language: 'ko-KR' }
    ],
    defaultLocale: 'en',
    vueI18n: './i18n.config.ts',
    strategy: 'no_prefix',
    lazy: true,
    langDir: 'locales/'
  },

  compatibilityDate: '2025-02-14'
})