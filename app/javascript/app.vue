<template>
  <div id="app">
    <!-- <p>{{ message }}</p> -->
     <Group></Group> <!-- 追記 -->
  </div>
</template>

<script>
import Group from "./components/Group"; //追記

export default {
  data: function () {
    return {
      message: "Hello Naoto911 for Vue!"
    }
  },
  components: {
    Group //追記
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>