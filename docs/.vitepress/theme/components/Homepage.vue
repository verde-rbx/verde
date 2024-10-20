<script setup lang="ts">
import { VPTeamMembers, VPTeamPage, VPTeamPageSection } from 'vitepress/theme'

interface HomepageProps {
  members: Array<{ name: string, title: string }>
}

defineProps<HomepageProps>()
</script>

<template>
  <VPTeamPage class="top-margin">
    <VPTeamPageSection>
      <template #title>
        Games
      </template>
      <template #lead>
        Games using Verde to enhance the developer experience.
      </template>
      <template #members>
        <VPTeamMembers v-if="members.length" :members="members" />
        <p v-else class="lead-text">
          Currently no games are using Verde.<br>
          Suggest your game by contacting <code>quantix.dev</code> on discord,
          or by emailing
          <code><a href="mailto:verde@quantix.dev">verde@quantix.dev</a></code>
        </p>
      </template>
    </VPTeamPageSection>
  </VPTeamPage>
</template>

<style>
.top-margin {
  margin-top: calc((var(--vp-nav-height) + var(--vp-layout-top-height, 0px)));
}

.lead-text {
  margin: 0 auto;
  text-align: center;
  color: var(--vp-c-text-3);
}
</style>
