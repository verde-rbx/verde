import { h } from "vue";
import DefaultTheme from "vitepress/theme";
import "./main.css";

import Homepage from "./components/Homepage.vue";

export default {
  ...DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      "home-features-after": () => h(Homepage),
    });
  },
};
