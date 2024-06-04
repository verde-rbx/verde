<script setup lang="ts">
import DefaultTheme from 'vitepress/theme'
import Homepage from './Homepage.vue'

const { Layout } = DefaultTheme
</script>

<template>
  <Layout>
    <template #home-features-after>
      <Homepage :members="[]" />
    </template>
  </Layout>
</template>
