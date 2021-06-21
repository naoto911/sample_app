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
import Header from "./components/Header";

import Group from "./router/Group/Group";
import GroupNew from "./router/Group/GroupNew";
import GroupEdit from "./router/Group/GroupEdit";
import GroupDetail from "./router/Group/GroupDetail";
import GroupEvent from "./router/Group/GroupEvent";
import GroupMember from "./router/Group/GroupMember";
import Test from "./router/Group/Test";

import Mypage from "./router/User/Mypage";
import Login from "./router/User/Login";
import UserNew from "./router/User/UserNew";

export default {
  data: function () {
    return {
      current_user: {}
    }
  },
  components: {
    Home,
    Header,

    Group,
    GroupNew,
    GroupEdit,
    GroupDetail,
    GroupEvent,
    GroupMember,
    Test,

    Mypage,
    Login,
    UserNew
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