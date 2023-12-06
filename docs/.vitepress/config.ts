import { DefaultTheme, defineConfig } from "vitepress";
import pkg from "../package.json";

// https://vitepress.vuejs.org/config/app-configs
export default defineConfig({
  lang: "en-GB",
  title: "Verde",
  description:
    "Syncs file systems between roblox studio and your editor of choice",

  lastUpdated: true,
  cleanUrls: true,

  sitemap: {
    hostname: "https://verde.quantix.dev",
  },

  head: [
    ["link", { rel: "icon", href: "/verde.svg" }],
    ["meta", { name: "theme-color", content: "#" }],
    ["meta", { name: "og:type", content: "website" }],
    ["meta", { name: "og:locale", content: "en" }],
    ["meta", { name: "og:site_name", content: "Verde" }],
  ],

  markdown: {
    theme: "monokai",
    lineNumbers: true,
  },

  themeConfig: {
    logo: "/verde.svg",
    search: {
      // TODO: Change to algolia once released
      provider: "local",
    },
    nav: [
      {
        text: "Guide",
        link: "/guide/introduction",
        activeMatch: "/guide/",
      },
      {
        text: "Reference",
        link: "/reference/",
        activeMatch: "/reference/",
      },
      {
        text: pkg.version,
        items: [
          {
            text: "Release Notes",
            link: "https://github.com/quantix-dev/verde/releases/latest",
          },
          {
            text: "Contributing",
            link: "https://github.com/quantix-dev/verde/blob/main/.github/CONTRIBUTING.md",
          },
        ],
      },
    ],
    socialLinks: [
      { icon: "github", link: "https://github.com/quantix-dev/verde" },
    ],
    sidebar: {
      "/guide/": {
        base: "/guide/",
        items: sidebarGuide(),
      },
      "/reference/": {
        base: "/reference/",
        items: sidebarReference(),
      },
    },
    editLink: {
      pattern: "https://github.com/quantix-dev/verde/tree/main/docs/:path",
      text: "Contribute to this page on GitHub",
    },
    footer: {
      message: "Released under the Mozilla Public License Version 2.0.",
    },
  },
});

function sidebarGuide(): DefaultTheme.SidebarItem[] {
  return [
    {
      text: "Guide",
      items: [
        { text: "Introduction", link: "introduction" },
        { text: "Quick Start", link: "quick-start" },
      ],
    },
    {
      text: "Studio Plugin",
      items: [
        { text: "Introduction", link: "plugin" },
      ]
    },
    {
      text: "Project",
      items: [
        { text: "Introduction", link: "project" },
      ]
    },
    {
      text: "CLI & API Reference",
      base: "/reference/",
      link: "/"
    }
  ];
}

function sidebarReference(): DefaultTheme.SidebarItem[] {
  return [
    {
      text: "Reference",
      items: [{ text: "CLI", link: "cli" }],
    },
  ];
}
