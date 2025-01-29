import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import Layout from './components/Layout.vue'
import './main.css'

export default <Theme>{
  extends: DefaultTheme,
  Layout,
}
