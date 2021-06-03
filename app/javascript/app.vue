<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import Home from "./components/Home";
import Group from "./components/Group";
import GroupDetail from "./components/GroupDetail";

export default {
  data: function () {
    return {
      message: "Hello Naoto911 for Vue!"
    }
  },
  components: {
    Home,
    Group,
    GroupDetail
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>