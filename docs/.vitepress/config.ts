import { DefaultTheme, defineConfig } from 'vitepress'

// https://vitepress.vuejs.org/config/app-configs
export default defineConfig({
    lang: "en-GB",
    title: "Verde",
    description: "Syncs file systems between roblox studio and your editor of choice",

    lastUpdated: true,
    cleanUrls: true,

    sitemap: {
        hostname: "https://verde.quantix.dev"
    },

    head: [
        ['link', { rel: 'icon', href: '/verde.svg' }],
        ['meta', { name: 'theme-color', content: '#' }],
        ['meta', { name: 'og:type', content: 'website' }],
        ['meta', { name: 'og:locale', content: 'en' }],
        ['meta', { name: 'og:site_name', content: 'Verde' }]
    ],

    markdown: {
        theme: 'monokai',
        lineNumbers: true
    },

    themeConfig: {
        logo: "/verde.svg",
        search: {
            // TODO: Change to algolia once released
            provider: "local"
        },
        nav: [
            {
                text: 'Guide',
                link: '/guide/introduction',
                activeMatch: '/guide/'
            },
            {
                text: 'Reference',
                link: '/reference/',
                activeMatch: '/reference/'
            }
        ],
        socialLinks: [
            { icon: 'github', link: 'https://github.com/quantix-dev/verde' }
        ],
        sidebar: {
            '/guide/': {
                base: '/guide/',
                items: sidebarGuide()
            },
            '/reference/': {
                base: '/reference/',
                items: sidebarReference()
            },
        },
        editLink: {
            pattern: 'https://github.com/quantix-dev/verde/tree/main/docs/:path',
            text: 'Contribute to this page on GitHub'
        },
        footer: {
            message: 'Released under the Mozilla Public License Version 2.0 license.',
        }
    }
})

function sidebarGuide(): DefaultTheme.SidebarItem[] {
    return [
        {
            text: 'Guide',
            items: [
                { text: "Introduction", link: 'introduction' },
                { text: "Quick Start", link: 'quick-start' },
            ]
        },
        {
            text: 'Project',
            base: 'project-',
            items: [
                { text: "Introduction", link: 'intro' },
                { text: "Setup", link: 'setup' },
            ]
        },
        {
            text: 'Studio Plugin',
            base: 'plugin-',
            items: [
                { text: "Introduction", link: 'intro' },
                { text: "Setup", link: 'setup' }
            ]
        },
    ]
}

function sidebarReference(): DefaultTheme.SidebarItem[] {
    return [
        {
            text: 'Reference',
            items: [
                { text: 'CLI', link: 'cli' },
                {
                    text: "Project File", 
                    base: 'project-file-',
                    items: [
                        { text: 'Overview', link: 'config' }
                    ]
                },
            ]
        },
    ]
}