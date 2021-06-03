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
            :key="group.id"
            cols="4"
          >
          <!-- ここから -->
          <router-link
            :to=" 'groups/' + (Number(group.id))"
            active-class="link--active"
            exact
            class="link"
          >
              <v-card
                class="mx-auto"
                max-width="344"
              >
                <v-img
                  :src= "group.image.url"
                  height="200px"
                ></v-img>

                <v-card-title>
                  {{ group.name }}
                </v-card-title>

                <v-card-subtitle>
                  {{ group.introduction }}
                </v-card-subtitle>

                <v-card-actions>
                  <v-btn
                    color="orange lighten-2"
                    text
                  >
                    LEARN MORE
                  </v-btn>

                  <v-spacer></v-spacer>

                  <v-btn
                    icon
                    @click="show = !show"
                  >
                    <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
                  </v-btn>
                </v-card-actions>

                <v-expand-transition>
                  <div v-show="show">
                    <v-divider></v-divider>

                    <v-card-text>
                      ここに,グループ説明を表示
                    </v-card-text>
                  </div>
                </v-expand-transition>
              </v-card>
            </router-link>
            <!-- ここまで -->
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
      show: false,
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