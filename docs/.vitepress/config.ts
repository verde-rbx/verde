import footnote from 'markdown-it-footnote'
import { defineConfig } from 'vitepress'
import pkg from '../package.json'

const repo = pkg.repository

// https://vitepress.vuejs.org/config/app-configs
export default defineConfig({
  // https://vitepress.dev/reference/site-config#site-metadata
  title: 'Verde',
  description: 'Syncs file systems between roblox studio and your editor of choice',
  head: [
    ['link', { rel: 'icon', href: '/verde.svg' }],
    ['meta', { name: 'theme-color', content: '#' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:locale', content: 'en' }],
    ['meta', { name: 'og:site_name', content: 'Verde' }],
  ],
  lang: 'en-GB',

  // https://vitepress.dev/reference/site-config#routing
  cleanUrls: true,

  // https://vitepress.dev/reference/site-config#build
  srcDir: 'src',

  // https://vitepress.dev/reference/site-config#theming
  lastUpdated: true,

  // https://vitepress.dev/reference/site-config#customization
  markdown: {
    theme: 'monokai',
    lineNumbers: true,
    config(md) {
      md.use(footnote)
    },
  },

  sitemap: {
    hostname: 'https://verde.quantix.dev',
  },

  themeConfig: {
    logo: '/verde.svg',
    search: {
      // TODO: Change to algolia once released
      provider: 'local',
    },
    nav: [
      {
        text: 'Guide',
        link: '/guide/introduction',
        activeMatch: '/guide/',
      },
      {
        text: 'Reference',
        link: '/reference/',
        activeMatch: '/reference/',
      },
      {
        text: pkg.version,
        items: [
          {
            text: 'Release Notes',
            link: `${repo}/releases/latest`,
          },
          {
            text: 'Contributing',
            link: `${repo}/blob/main/.github/CONTRIBUTING.md`,
          },
        ],
      },
    ],
    socialLinks: [
      { icon: 'github', link: repo },
    ],
    sidebar: {
      '/guide/': {
        base: '/guide/',
        items: [
          {
            text: 'Guide',
            items: [
              { text: 'Introduction', link: 'introduction' },
              { text: 'Quick Start', link: 'quick-start' },
            ],
          },
          {
            text: 'Studio Plugin',
            items: [
              { text: 'Introduction', link: 'plugin' },
            ],
          },
          {
            text: 'Project',
            items: [
              { text: 'Introduction', link: 'project' },
            ],
          },
          {
            text: 'CLI & API Reference',
            base: '/reference/',
            link: '/',
          },
        ],
      },
      '/reference/': {
        base: '/reference/',
        items: [
          {
            text: 'Reference',
            items: [{ text: 'CLI', link: 'cli' }],
          },
        ],
      },
    },
    editLink: {
      pattern: `${repo}/tree/main/docs/:path`,
      text: 'Contribute to this page on GitHub',
    },
    footer: {
      message: 'Released under the Mozilla Public License Version 2.0.',
    },
  },
})
