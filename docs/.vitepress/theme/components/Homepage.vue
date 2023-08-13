<script setup lang="ts">
import { VPTeamPage, VPTeamPageSection, VPTeamMembers } from "vitepress/theme";

const members = [
  // {
  //   name: 'Game Name',
  //   title: 'Author Name'
  // }
];
</script>

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

<template>
  <VPTeamPage class="top-margin">
    <VPTeamPageSection>
      <template #title>Games</template>
      <template #lead>
        Games using Verde to enhance the developer experience.
      </template>
      <template #members>
        <VPTeamMembers v-if="members.length > 0" :members="members" />
        <p class="lead-text" v-else>
          Currently no games are using Verde.<br />
          Suggest your game by contacting <code>quantix.dev</code> on discord,
          or by emailing
          <code><a href="mailto:verde@quantix.dev">verde@quantix.dev</a></code>
        </p>
      </template>
    </VPTeamPageSection>
  </VPTeamPage>
</template>
