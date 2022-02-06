<template>
  <div id="app">
    <v-app>
      <Header v-if="!checkURL" :val="token" :val2="user_groups"></Header>
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

import Top from "./router/Top";
import Home from "./router/Home";
import Header from "./components/Header";

import Group from "./router/Group/Group";

import Approval from "./router/Group/Approval";

import EventNew from "./router/Event/EventNew";
import EventDetail from "./router/Event/EventDetail";
import EventEdit from "./router/Event/EventEdit";

import JoinNew from "./router/Join/JoinNew";
import JoinEdit from "./router/Join/JoinEdit";

import User from "./router/User/User";

import Login from "./router/User/Login";


export default {
  components: {
    Top,
    Home,
    Header,

    Group,

    Approval,

    EventNew,
    EventDetail,
    EventEdit,

    JoinNew,
    JoinEdit,

    User,
    
    Login,
  },  

  data() {
    return {
      user_groups: [],
    }
  },

  computed: {
    token () {
      var result = {};
      var login_user = this.$store.state.loginUser

      if (login_user !== null) { //Login_userが存在する時
        this.getUsers(login_user.id)
        result = login_user;
      }
      return result;
    },
    checkURL() {
      // console.log(this.$route.path);
      // console.log(this.$route.path === '/');
      var result = false;
      if (this.$route.path === '/') { //rootの時はHeaderを非表示にする
       result = true
      }
      return result;
    }    
  },

  created() {
    this.login(); //初期描写時にLogin実行 (以後は,Login or GestLogin 毎に各関数でpost中に実行)
  },

  methods: {
    getUsers(user_id) {
      // console.log("getusers実行")
      if (!user_id) return; //初期描写時のtoekn未取得を回避
      axios
        .get(`/api/v1/users/${user_id}.json`)
        .then(response => {
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