<template>
  <v-app id="inspire">
    <v-app-bar
      app
      color="teal lighten-4"
      clipped-left
    >
      <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>
      <v-toolbar-title>Syumix</v-toolbar-title>
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
        <v-list-item v-for="menu in menus" :key="menu.title" :to="menu.url">
          <v-list-item-icon>
            <v-icon>{{ menu.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ menu.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

          <!-- ここから -->
          <GroupsCard :val="group" :vals="groups"></GroupsCard>
          <!-- ここまで -->
  </v-app>
</template>

<script>
// axiosを読み込む
import axios from 'axios';
import GroupsCard from './GroupsCard.vue';

export default {
  components: { GroupsCard },
  data() {
    return {
      show: false,
      //axiosで取得するデータを入れるため、空でOK
      groups: [],
      group: [],
      drawer: false,
      group: null,
      menus: [
      { title: 'Top', icon: 'mdi-web', url: '/' },
      { title: 'Home', icon: 'mdi-home', url: '/groups' },
      { title: 'Mypage', icon: 'mdi-text-account', url: '' },
      { title: 'About', icon: 'mdi-information-variant', url: '' }
    ]
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      //GETリクエストでRailsで作成したjsonを取得する
      .get('/api/v1/groups.json')
      // .get('/api/v1/groups.json')
      //response.data は RailsのUser.select(:id, :name, :email)
      //これをdata()で定義したusersに代入する
      .then(response => (this.groups = response.data))
  }
}

</script>

<style scoped>
head {
  color: white;
}
</style>