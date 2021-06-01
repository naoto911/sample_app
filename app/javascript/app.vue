<template>
  <div id="app">
    <p>{{ message }}</p>
     <Top></Top> <!-- 追記 -->
  </div>
</template>

<script>
import Top from "./components/Top"; //追記

export default {
  data: function () {
    return {
      message: "Hello Naoto911 for Vue!"
    }
  },
  components: {
    Top //追記
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>