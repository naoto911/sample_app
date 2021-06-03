<template>
  <v-app id="inspire">
    <v-app-bar
      app
      shrink-on-scroll
    >
      <v-app-bar-nav-icon></v-app-bar-nav-icon>

      <v-toolbar-title>Syumix</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

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