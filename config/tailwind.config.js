const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/components/**/*.{html.erb,rb}',
    './app/views/**/*.{html.erb,rb}',
    './app/helpers/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', ...defaultTheme.fontFamily.sans],
        mono: ['Monaco', 'Menlo', 'Ubuntu Mono', ...defaultTheme.fontFamily.mono]
      },
      colors: {
        // Maintain existing color scheme
        'stomp-gray': {
          50: '#f9fafb',
          100: '#f3f4f6',
          200: '#e5e7eb',
          300: '#d1d5db',
          400: '#9ca3af',
          500: '#6b7280',
          600: '#4b5563',
          700: '#374151',
          800: '#1f2937',
          900: '#111827',
          950: '#0f172a'
        }
      },
      animation: {
        'shimmer': 'shimmer 2s infinite',
        'progress-shine': 'progress-shine 1.5s ease-in-out infinite',
        'pulse': 'pulse 2s infinite'
      },
      keyframes: {
        shimmer: {
          '100%': { transform: 'translateX(100%)' }
        },
        'progress-shine': {
          '0%': { transform: 'translateX(-100%)' },
          '50%': { transform: 'translateX(100%)' },
          '100%': { transform: 'translateX(100%)' }
        }
      }
    },
  },
  plugins: [],
}