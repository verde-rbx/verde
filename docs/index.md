---
title: Verde
titleTemplate: :title
layout: home

hero:
  name: Verde
  text: Streamlined Roblox Development
  tagline: Empowering developers with improved collaboration and productivity for Roblox.
  image:
    src: public/Verde_Logo.svg
    alt: Verde
    width: 300
  actions:
    - theme: brand
      text: Get Started
      link: /guide/
    - theme: alt
      text: View on GitHub
      link: https://github.com/quantix-dev/verde  
features:
  - icon: 🔄
    title: File Synchronisation
    details: Effortlessly synchronise your local file system with Roblox.
  - icon: 👌
    title: Easy to use
    details: Well documented and user friendly with Verde quickstart.
  - icon: 🤝
    title: Collaborate
    details: Designed with collaboration in mind. Setup a multi-user project in seconds.
---

<script setup>
import { VPTeamPage, VPTeamPageTitle, VPTeamPageSection, VPTeamMembers } from 'vitepress/theme'

const members = [
  {
    name: 'Game Name',
    title: 'Author Name'
  }
]
</script>

<br><br>
<VPTeamPage>
  <VPTeamPageSection>
    <template #title>Games</template>
    <template #lead>Games using Verde to enhance the developer experience.</template>
    <template #members>
      <VPTeamMembers :members="members" />
    </template>
  </VPTeamPageSection>
</VPTeamPage>