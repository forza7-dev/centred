export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  css: ['~/assets/css/main.css'],

  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/google-fonts',
  ],

  googleFonts: {
    families: {
      'Quicksand': [400, 500, 600, 700],
      'DM Sans': [400, 500, 600, 700],
      'Marcellus': [400],
      'Caveat': [400, 500, 600, 700],
    },
  },

  app: {
    head: {
      title: 'Centred',
      meta: [
        { name: 'description', content: 'Person-centred planning tools by Forza7' },
      ],
    },
  },
})
