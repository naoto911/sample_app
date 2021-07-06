<template>
<div>
    <v-app-bar
      app
      clipped-left
    >
      <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>
      <router-link
        to="/"
        active-class="link--active"
        exact
        class="link"
      ><v-toolbar-title color="warning">Syumix</v-toolbar-title></router-link>
      <v-spacer></v-spacer>

      <!-- ここからLogoutボタン -->
        <v-btn 
          dark v-on="on" 
          @click="Logout(val.id)" 
          style="margin-top: 8px"
          v-if="val"
        >
          <span class="material-icons" style="margin-right: 4px;">
            delete
          </span>
        </v-btn>
      <!-- ここまでLogoutボタン -->

      <router-link
        v-if="val"
        :to=" 'users/' + (Number(val.id))"
        active-class="link--active"
        exact
        class="link"
      >
        <v-avatar>
          <v-img
            :src= "val.image.url"
            alt="John"
          ></v-img>
        </v-avatar>
      </router-link>

    </v-app-bar>

    <v-navigation-drawer
      app
      v-model="drawer"
      clipped
      temporary
      light
    >
      <v-list-item>
        <v-list-item-title class="title">
          Application
        </v-list-item-title>
        <v-btn icon>
          <v-icon @click="drawer = false">>mdi-chevron-left</v-icon>
        </v-btn>
      </v-list-item>
      <v-divider />
      <v-list nav>
        <v-list-item v-for="menu in menus" :key="menu.title" :to="menu.url" exact>
          <v-list-item-icon>
            <v-icon>{{ menu.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ menu.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
</div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      drawer: false,
      menus: [
      { title: 'Home', icon: 'mdi-home', url: '/groups' },
      { title: 'Create', icon: 'mdi-account-multiple-plus', url: '/groups/new' },
      { title: 'Mypage', icon: 'mdi-text-account', url: '/' },
      // { title: 'About', icon: 'mdi-information-variant', url: '/bar' },
      { title: 'Login', icon: 'mdi-information-variant', url: '/login' }
    ]
    }
  },
  props: {
    val: {
      type: Object
    }
  },
  methods: {
  //ここからLogoutメソッド
    Logout(id) {
      axios.delete(`/api/v1/login`)
        .then(res => {
          this.$router.push({ path: '/' });
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
  //ここまでLogoutメソッド
  },
};

</script>

<style scoped>
head {
  color: white;
}

a {
  color: grey;
}
</style>