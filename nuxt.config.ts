// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/i18n',
    '@nuxtjs/google-fonts',
    'nuxt-icon',
  ],
  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_API_BASE || 'http://localhost:8080',
      wsBase: process.env.NUXT_WS_BASE || 'ws://localhost:8080'
    }
  },
  googleFonts: {
    families: {
      Oswald: true,
    }
  },
})
