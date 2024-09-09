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
    families: {
      Oswald: true,
      Rubik: true
    }
  },
  colorMode: {
    preference: 'light'
  },
  css: ['~/assets/css/main.css'],
  gtag: {
    id: process.env.NUXT_GTAG_ID,
  }
})
