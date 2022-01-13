<template>
<div>
    <v-app-bar
      app
      clipped-left
    >
    
      <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>
    <!-- ①ここからSyumixロゴ&ハンバーガーメニュー -->
      <router-link
        to="/"
        active-class="link--active"
        exact
        class="link"
      ><v-toolbar-title color="warning">Syumix</v-toolbar-title></router-link>
    <!-- ①ここまでSyumixロゴ&ハンバーガーメニュー -->
      <v-spacer></v-spacer>
      
      <!-- ②-1 ここからLogin時の展開ボタン -->
        <v-menu
          v-if="val"
          bottom
          min-width="200px"
          rounded
          offset-y
        >
          <template  v-slot:activator="{ on }">
            <v-btn
              icon
              x-large
              v-on="on"
            >
              <v-avatar
                size="48"
              >
                <v-img
                  v-if="val.image"
                  :src= "val.image.url"
                  alt="John"
                ></v-img>
                <span v-else>G</span>
              </v-avatar>
            </v-btn>
          </template>

          <v-card>
            <v-list-item-content class="justify-center">
              <div class="mx-auto text-center">

              <!-- ここから②-1-1 Avatar -->
                <v-avatar>
                  <v-img
                    v-if="val.image"
                    :src= "val.image.url"
                    alt="John"
                  ></v-img>
                  <span v-else>G</span>
                </v-avatar>
              <!-- ここまで②-1-1 Avatar -->

                <h4 v-if="val">{{ val.name }}</h4> <!-- 名前 -->
                <p v-if="val" class="text-caption mt-1">{{ val.email }}</p> <!-- E-mail -->
                <v-divider class="my-3"></v-divider>
              <!-- ここから②-1-2 Myapage -->
                <router-link 
                  :to=" '/' + 'users/' + (Number(val.id))"
                  active-class="link--active"
                  exact
                  class="link"
                >
                  <v-btn
                    depressed
                    rounded
                    text
                  >
                    Mypage
                  </v-btn>
                </router-link>
              <!-- ここまで②-1-2 Myapage -->
                <v-divider class="my-3"></v-divider>
              <!-- ここから②-1-3 Logout -->
                <v-btn
                  depressed
                  rounded
                  text
                  @click.stop="Logout(val.id)"
                >
                  Logout
                </v-btn>
              <!-- ここまで②-1-3 Logout -->
            
              </div>
            </v-list-item-content>
          </v-card>

        </v-menu>
      <!-- ②-1 ここまでLogin時の展開ボタン -->

      <!-- ②-2ここから非Login時 -->
        <router-link
          v-else
          to="/login"
          active-class="link--active"
          exact
          class="link"
        >
          Login
        </router-link>
      <!-- ②-2ここまで非Login時 -->

    </v-app-bar>
  <!-- ③ここからサイドバー -->
    <v-navigation-drawer
      app
      v-model="drawer"
      clipped
      temporary
      light
    >
      <v-list-item>
        <v-list-item-title class="title text-center">
          Application
        </v-list-item-title>
        <v-btn icon>
          <v-icon @click="drawer = false">>mdi-chevron-left</v-icon>
        </v-btn>
      </v-list-item>
      <v-divider />
      <v-list nav>
      
        <v-list-item v-for="user_group in user_groups" :key="user_group.name">
          <v-list-item-icon>
            <v-icon>{{ menus[0].icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ user_group.name }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

      <v-divider />
 
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
  <!-- ③ここまでサイドバー -->
</div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      drawer: false,
      current_user: [],
      user_groups: [],

      menus: [
      { title: 'Home', icon: 'mdi-home', url: '/groups' },
      { title: 'Create', icon: 'mdi-account-multiple-plus', url: '/groups/new' },
      // { title: 'Mypage', icon: 'mdi-text-account', url: '/' },
      // { title: 'About', icon: 'mdi-information-variant', url: '/bar' },
      { title: 'Login', icon: 'mdi-information-variant', url: '/login' }
      ],
    }
  },
  
  props: {
    val: {
      type: Object
    }
  },

  computed: {

    get_user () {
      console.log("get_user")
      // return console.log(this.$store.state.loginUser.name)
      // return console.log(this.token.id)
      const test = this.$store.state.loginUser.id
      // console.log(test)
      this.getEvent(test);
      // return this.getEvent(test.id);
      //  return this.user_groups;
    },
  },

  created () {
    // this.getEvent(this.$store.state.loginUser.id);
  },

  methods: {
    Logout(id) {
      axios.delete(`/api/v1/login`)
        .then(res => {
          this.$router.push({ path: '/login' });
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },

    getEvent(user_id) {
      console.log("getEvent")
      axios
        .get(`/api/v1/users/${user_id}.json`)
        .then(response => {
          // this.current_user = response.data.current_user;
          this.user_groups = response.data.user_groups;
        });
    },
  },

};

</script>