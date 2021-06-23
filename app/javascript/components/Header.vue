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
      <!-- <v-btn icon>
        <v-icon>mdi-text-account</v-icon>
      </v-btn> -->
      <!-- <v-btn icon>
        <v-icon>mdi-account-search</v-icon>
      </v-btn> -->
      <router-link
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
  }
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