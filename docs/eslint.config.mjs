// @ts-check
import antfu from '@antfu/eslint-config'

// https://github.com/antfu/eslint-config
export default antfu({
  formatters: {
    markdown: true,
  },

  stylistic: {
    indent: 2,
    quotes: 'single',
  },

  typescript: true,
})
