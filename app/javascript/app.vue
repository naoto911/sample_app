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

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import Mypage from "./router/User/Mypage";
import Login from "./router/User/Login";
import UserNew from "./router/User/UserNew";
import UserEdit from "./router/User/UserEdit";

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

    EventNew,
    EventDetail,
    EventEdit,

    Mypage,
    Login,
    UserNew,
    UserEdit
  },  

  created () {
    this.getEvent();
    // console.log("createdが実行された");
  },

  mounted () {
    // this.getEvent();
  },

  beforeUpdate() {
    // this.getEvent();
    // console.log("befoerUpdateが実行された");
  },

  methods: {
    getEvent() {
      axios
        .get('/api/v1/groups.json')
        .then(response => {
          this.current_user = response.data.current_user;
        });
    },
  },

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