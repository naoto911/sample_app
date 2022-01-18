<template>
  <div id="app">
    <v-app>
      <Header :val="token" :val2="user_groups"></Header>
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

import Approval from "./router/Group/Approval";

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import JoinNew from "./router/Join/JoinNew";
import JoinEdit from "./router/Join/JoinEdit";

import User from "./router/User/User";
import UserNew from "./router/User/UserNew";
import UserEdit from "./router/User/UserEdit";
import UserProfile from "./router/User/UserProfile";
import Application from "./router/User/Application";

import Login from "./router/User/Login";


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

    User,
    UserNew,
    UserEdit,
    UserProfile,
    Application,
    
    Login,
  },  

  data() {
    return {
      user_groups: [],
      current_user: [],
      dummy_token: null,
      // dummy_token: {
      //   id:null,
      //   name:null,
      //   email:null,
      //   image:{url:null,thumb:{url:null}}
      //   },
    }
  },

  computed: {
    token () {
      console.log("toeknを実行");
      var login_user = this.$store.state.loginUser
      console.log(login_user.id);
      if (login_user.id !== void 0) {
        console.log("Login_userのid取得")
        this.getUsers(login_user.id)
        return login_user;
      }
      else {
        console.log("Login_userのid未取得")
        return this.dummy_token;
      }
    },
  },

  created() {
    console.log("created");
    this.login(); //初期描写時にLogin実行 (以後は,Login or GestLogin 毎に各関数でpost中に実行)
  },

  methods: {
    getUsers(user_id) {
      console.log("getusers実行")
      if (!user_id) return; //初期描写時のtoekn未取得を回避
      axios
        .get(`/api/v1/users/${user_id}.json`)
        .then(response => {
          // this.current_user = response.data.current_user;
          this.user_groups = response.data.user_groups;
        });
    },
    login(){
      this.$store.dispatch('login')
    },
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