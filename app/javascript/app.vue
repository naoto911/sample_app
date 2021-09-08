<template>
  <div id="app">
    <v-app>
      <Header :val="token"></Header>
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
import Header from "./components/Header";

import Group from "./router/Group/Group";
import GroupNew from "./router/Group/GroupNew";
import GroupEdit from "./router/Group/GroupEdit";
import GroupDetail from "./router/Group/GroupDetail";
import GroupEvent from "./router/Group/GroupEvent";
import GroupMember from "./router/Group/GroupMember";

import Approval from "./router/Group/Approval";

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import JoinNew from "./router/Join/JoinNew";
import JoinEdit from "./router/Join/JoinEdit";

import Mypage from "./router/User/Mypage";
import Login from "./router/User/Login";
import UserNew from "./router/User/UserNew";
import UserEdit from "./router/User/UserEdit";

import Application from "./router/User/Application";

export default {
  components: {
    Home,
    Header,

    Group,
    GroupNew,
    GroupEdit,
    GroupDetail,
    GroupEvent,
    GroupMember,

    Approval,

    EventNew,
    EventDetail,
    EventEdit,

    JoinNew,
    JoinEdit,

    Mypage,
    Login,
    UserNew,
    UserEdit,

    Application,
  },  

  computed: {
    token () {
      return this.$store.state.loginUser
    }
  },

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