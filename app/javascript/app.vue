<template>
  <div id="app">
    <v-app>
      <Header></Header>
      <v-main>
        <v-container>
          <router-view></router-view>
        </v-container>
      </v-main>
    </v-app>
  </div>
</template>

<script>
import Home from "./router/Home";
import Group from "./router/Group";
import GroupDetail from "./router/GroupDetail";
import Header from "./router/Header";
import GroupNew from "./router/GroupNew";

export default {
  data: function () {
    return {
      message: "Hello Naoto911 for Vue!"
    }
  },
  components: {
    Home,
    Group,
    GroupDetail,
    Header,
    GroupNew
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

head {
  color: white;
}
</style>