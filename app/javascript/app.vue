<template>
  <div id="app">
    <v-app>
      <Header :val="current_user"></Header>
      <!-- <Header></Header> -->
      <v-main>
        <v-container>
          <router-view></router-view>
        </v-container>
      </v-main>
    </v-app>
  </div>
</template>

<script>
import axios from 'axios';

import Home from "./router/Home";
import Group from "./router/Group";
import GroupDetail from "./router/GroupDetail";
import Header from "./components/Header";
import GroupNew from "./router/GroupNew";
import GroupEvent from "./router/GroupEvent";
import GroupMember from "./router/GroupMember";

export default {
  data: function () {
    return {
      current_user: {}
    }
  },
  components: {
    Home,
    Group,
    GroupDetail,
    Header,
    GroupNew,
    GroupEvent,
    GroupMember
  },  
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get('/api/v1/groups.json')
      // .then(response => (this.groups = response.data.groups))
      .then(response => {
        // this.groups = response.data.groups
        this.current_user = response.data.current_user;
      });
  }
};
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