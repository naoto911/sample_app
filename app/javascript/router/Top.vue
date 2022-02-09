<template>
  <div>

  <!-- ここから Header --> 
  <v-app-bar
    app
    clipped-left
  >
  <!-- ① ここからSyumixロゴ --> 
   <router-link
      to="/groups/"
      active-class="link--active"
      exact
      class="link"
    >
      <v-toolbar-title color="warning">Syumix</v-toolbar-title>
    </router-link>
  <!-- ① ここまでSyumixロゴ -->

    <v-spacer></v-spacer>

    <!-- ②-2 ここから GestLoginボタン -->
      <v-btn
        color="warning"
        class="mr-4"
        dark
        @click="gestLogin"
      >
        GestLogin
      </v-btn>
    <!-- ②-2 ここまで GestLoginボタン -->

    <!-- ②-2 ここから Loginボタン -->
      <router-link
        to="/login"
        active-class="link--active"
        exact
        class="link"
      >
        <v-btn color="primary">
          Login
        </v-btn>
      </router-link>
    <!-- ②-2 ここまで Loginボタン -->

  </v-app-bar>
  <!-- ここまで Header --> 

  <!-- ここから アプリ紹介 --> 
  <h2>Syumixでできる事</h2>

  <v-timeline :dense="$vuetify.breakpoint.smAndDown">
    <v-timeline-item
      color="purple lighten-2"
      fill-dot
      right
    >
      <v-card>
        <v-card-title class="purple lighten-2">
          <v-icon
            dark
            size="42"
            class="mr-4"
          >
            mdi-magnify
          </v-icon>
          <h2 class="text-h4 white--text font-weight-light">
            グループを探す
          </h2>
        </v-card-title>
        <v-container>
          <v-row>
            <v-col
              cols="12"
            >
              <p>・名称検索,人数検索でソート</p>
              <p>・気になるグループはお気に入り登録</p>
              <p>・Myapageから確認できるよ!</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-timeline-item>

    <v-timeline-item
      color="amber lighten-1"
      fill-dot
      left
      small
    >
      <v-card>
        <v-card-title class="amber lighten-1 justify-end">
          <h2 class="text-h4 mr-4 white--text font-weight-light">
            グループへ参加
          </h2>
          <v-icon
            dark
            size="42"
          >
            mdi-email-outline
          </v-icon>
        </v-card-title>
        <v-container>
          <v-row>
            <v-col
              cols="12"
            >
              <p>・気になるグループへ承認依頼を出そう</p>
              <p>・申請状況はmypageから確認可能</p>
              <p>・承認されるとグループのイベントへ参加可能</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-timeline-item>

    <v-timeline-item
      color="cyan lighten-1"
      fill-dot
      right
    >
      <v-card>
        <v-card-title class="cyan lighten-1">
          <v-icon
            class="mr-4"
            dark
            size="42"
          >
            mdi-calendar-text
          </v-icon>
          <h2 class="text-h4 white--text font-weight-light">
            イベントへ参加
          </h2>
        </v-card-title>
        <v-container>
          <v-row>
            <v-col
              cols="12"
              md="4"
            >
              <p>・参加,不参加を選ぼう</p>
              <p>・参加状況は詳細ページで閲覧できるよ</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-timeline-item>

    <v-timeline-item
      color="red lighten-1"
      fill-dot
      left
      small
    >
      <v-card>
        <v-card-title class="red lighten-1 justify-end">
          <h2 class="text-h4 mr-4 white--text font-weight-light">
            イベントを管理
          </h2>
          <v-icon
            dark
            size="42"
          >
            mdi-calendar-text
          </v-icon>
        </v-card-title>
        <v-container>
          <v-row>
            <v-col
              cols="12"
              md="10"
            >
              <p>Mypageから参加予定のイベントを確認</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-timeline-item>

    <v-timeline-item
      color="green lighten-1"
      fill-dot
      right
    >
      <v-card>
        <v-card-title class="green lighten-1">
          <v-icon
            class="mr-4"
            dark
            size="42"
          >
            mdi-account-multiple-outline
          </v-icon>
          <h2 class="text-h4 white--text font-weight-light">
            グループを作ろう
          </h2>
        </v-card-title>
        <v-container>
          <v-row>
            <v-col>
              <p>グループを作って幹事になろう</p>
              <p>イベントの作成,メンバーの承認ができる</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-timeline-item>
  </v-timeline>
  <!-- ここまで アプリ紹介 --> 

  </div>
</template>

<script>
import axios from 'axios';

export default {

  data() {
    return {
      groups: [],
      group: null,
      groups_length: [],

      menus: [
        { title: 'Home', icon: 'mdi-home', url: '/groups' },
        { title: 'Create', icon: 'mdi-account-multiple-plus', url: '/groups/new' },
        { title: 'Login', icon: 'mdi-information-variant', url: '/login' }
        ],
    }
  },

  methods: {
    getGroup(){
      axios
        .get('/api/v1/groups.json')
        .then(response => {
          this.groups = response.data.groups
          this.groups_length = response.data.groups_length

        });
    },
    Logout() {
    },
    gestLogin () {
    },
  },

}
</script>