<!--
<template>
  <v-bottom-navigation v-model="value">
    <v-btn value="recent">
      <span>Recent</span>
    </v-btn>
 
    <v-btn value="favorites">
      <span>Favorites</span>      
    </v-btn>
 
    <v-btn value="nearby">
      <span>Nearby</span>      
    </v-btn>
  </v-bottom-navigation>
</template>
-->

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

    <v-main>
      <v-container>
        <v-row>
          <v-col
            v-for="group in groups"
            :key="group"
            cols="4"
          >
            <v-card height="200">{{ group.name }}</v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      //axiosで取得するデータを入れるため、空でOK
      groups: []
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