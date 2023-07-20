import { defineConfig } from 'vitepress'

// https://vitepress.vuejs.org/config/app-configs
export default defineConfig({
    lang: "en-GB",
    title: "Verde",
    description: "Syncs file systems between roblox studio and your editor of choice",
    base: "/verde",
    lastUpdated: true,

    markdown: {
        theme: 'monokai',
        lineNumbers: true
    },

    themeConfig: {
        nav: [
            { text: 'Docs', link: '/docs' },
            { text: 'Quick Start', link: '/guide/quick-start' }
        ],
        socialLinks: [
            { icon: 'github', link: 'https://github.com/quantix-dev/verde' }
        ],
        sidebar: [
            {
                text: 'Guide',
                items: [
                    { text: "Introduction", link: '/guide/' },
                    { text: "Quick Start", link: '/guide/quick-start' },
                ]
            },
            {
                text: 'Project File',
                items: [
                    { text: "Introduction", link: '/project-file/' },
                    { text: "Setup", link: '/project-file/setup' },
                    { text: "Syntax", link: '/project-file/syntax' },
                ]
            },
            {
                text: 'Studio Plugin',
                items: [
                    { text: "Introduction", link: '/plugin/' },
                    { text: "Setup", link: '/plugin/setup' },
                    { text: "Features", link: '/plugin/features' },
                ]
            },
            { text: 'Reference', link: '/reference/' }
        ],
        editLink: {
            pattern: 'https://github.com/quantix-dev/verde/tree/main/docs/:path',
            text: 'Contribute to this page on GitHub'
        },
        footer: {
            message: 'Released under the Mozilla Public License Version 2.0 license. Created with Vitepress',
            copyright: 'Copyright © 2023-present quantix-dev'
        }
    }
})
