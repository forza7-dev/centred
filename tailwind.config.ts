import type { Config } from 'tailwindcss'

export default {
  theme: {
    extend: {
      colors: {
        teal: {
          DEFAULT: '#72B9CF',
          50: '#EFF8FA',
          100: '#D9EEF4',
          200: '#B3DDE9',
          300: '#8DCCDE',
          400: '#72B9CF',
          500: '#4DA1BC',
          600: '#3D8199',
          700: '#2E6176',
          800: '#1F4153',
          900: '#102030',
        },
        coral: {
          DEFAULT: '#CF8872',
          50: '#FAF3F0',
          100: '#F4E2DB',
          200: '#E9C5B7',
          300: '#DEA893',
          400: '#CF8872',
          500: '#BC6A50',
          600: '#99533D',
          700: '#763E2E',
          800: '#53291F',
          900: '#301510',
        },
        navy: {
          DEFAULT: '#161F38',
          50: '#E8EAF0',
          100: '#C5CAD6',
          200: '#8B95AD',
          300: '#515F84',
          400: '#2C3A5E',
          500: '#161F38',
          600: '#12192E',
          700: '#0E1324',
          800: '#0A0D1A',
          900: '#060810',
        },
        sand: {
          DEFAULT: '#FAF6F0',
          50: '#FFFFFF',
          100: '#FAF6F0',
          200: '#F0E6D4',
          300: '#E6D6B8',
          400: '#DCC69C',
          500: '#D2B680',
        },
      },
      fontFamily: {
        sans: ['Quicksand', 'system-ui', 'sans-serif'],
        heading: ['Quicksand', 'system-ui', 'sans-serif'],
        content: ['DM Sans', 'system-ui', 'sans-serif'],
      },
    },
  },
} satisfies Partial<Config>
