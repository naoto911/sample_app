<template>
  <div>
    <v-app-bar app clipped-left>
      <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>
    <!-- ①ここからSyumixロゴ&ハンバーガーメニュー -->
      <router-link
        to="/groups/"
        active-class="link--active"
        exact
        class="link"
      ><v-toolbar-title color="warning">Syumix</v-toolbar-title></router-link>
    <!-- ①ここまでSyumixロゴ&ハンバーガーメニュー -->
      <v-spacer></v-spacer>

        <v-btn
          v-if="!Object.keys(val).length"
          color="warning"
          class="mr-4"
          dark
          @click="guestLogin"
        >
          GuestLogin
        </v-btn>

      <!-- ②-1 ここからLogin時の展開ボタン -->
        <v-menu
          v-if="Object.keys(val).length"
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
              <v-avatar size="48" color="grey">
                <v-img
                  v-if="val.image.url"
                  :src= "val.image.url"
                  alt="John"
                ></v-img>
                <v-icon v-else>mdi-account</v-icon>
              </v-avatar>
            </v-btn>
          </template>

          <v-card>
            <v-list-item-content class="justify-center">
              <div class="mx-auto text-center">

              <!-- ここから Avatar -->
                <v-avatar color="grey">
                  <v-img
                    v-if="val.image.url"
                    :src= "val.image.url"
                    alt="John"
                  ></v-img>
                  <v-icon v-else>mdi-account</v-icon>
                </v-avatar>
              <!-- ここまで Avatar -->

                <h4 v-if="val">{{ val.name }}</h4>
                <p v-if="val" class="text-caption mt-1">{{ val.email }}</p> 
                <v-divider class="my-3"></v-divider>
              <!-- ここから②-1-2 Myapage -->
                <router-link 
                  :to=" '/' + 'users/' + (Number(val.id)) + '/profile'"
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
          <v-btn color="primary">
            Login
          </v-btn>
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
            Syumix
          </v-list-item-title>
          <v-btn icon>
            <v-icon @click="drawer = false">mdi-chevron-left</v-icon>
          </v-btn>
        </v-list-item>

        <v-divider />

        <v-list nav>

          <v-list-item v-for="user_group in val2" :key="user_group.name" :to="'/groups/'+ user_group.id + '/detail'" exact>
            <v-list-item-icon>
              <v-avatar size="48" color="grey">
                <v-img
                  v-if="user_group.image.url"
                  :src= "user_group.image.url"
                ></v-img>
                <v-icon v-else>mdi-account-group-outline</v-icon>
              </v-avatar>
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
      menus: [
      // { title: 'Home', icon: 'mdi-home', url: '/groups' },
      { title: 'Find', icon: 'mdi-home', url: '/groups' },
      { title: 'Create', icon: 'mdi-account-multiple-plus', url: '/groups/new' },
      { title: 'Login', icon: 'mdi-login', url: '/login' },
      { title: 'About', icon: 'mdi-information-variant', url: '/' },
      ],
    }
  },
  
  props: {
    val: {
      type: Object
    },
    val2: {
      type: Array
    }
  },

  methods: {
    Logout(id) {
      axios.delete(`/api/v1/login`)
        .then(res => {
          this.$store.dispatch('logout')
          // this.$router.push({ path: '/login' });
          this.$router.push({ path: `/` });
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
    guestLogin () {
      axios
        .post('/api/v1/guest_login')
        .then(response => {
          var user_id = response.data.user.id;
          this.$store.dispatch('login')
          this.$router.push({ path: `/users/${user_id}/profile` });
        })        
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
      }

  },

};

</script>