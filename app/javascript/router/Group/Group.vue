<template>
  <div>
  <!-- ①ここから header -->
    <v-row align="center">

    <!-- ①-1 ここから avatar -->
      <v-col cols="1">
        <v-avatar
          size="60"
        >
          <v-img
            v-if="group.image"
            :src= "group.image.url"
          ></v-img>
          <v-icon v-else>{{ menus[0].icon }}</v-icon>
        </v-avatar>
      </v-col>
    <!-- ①-1 ここまで avatar -->

    <!-- ①-2 ここから グループ名 -->
      <v-col cols="10">
        <h2>{{ group.name }}</h2>
      </v-col>
    <!-- ①-2 ここまで グループ名 -->

    <!-- ①-3 ここから 申請ボタン -->
      <v-col cols="1" class="text-right">
          <router-link 
            :to=" '/groups/' + (Number(this.$route.params.id)) +'/joins/new' "
            active-class="link--active"
            exact
            class="link"
          >
            <v-btn icon>
              <v-icon>mdi-file-document-multiple-outline</v-icon>
            </v-btn>
          </router-link>
      </v-col>
    <!-- ①-3 ここまで 申請ボタン -->

    </v-row>
  <!-- ①ここまで header -->


  <!-- ②ここから tabs -->
    <v-tabs>
      <v-tab
        v-for="menu in menus" 
        :key="menu.title" 
        :to="menu.url" 
        exact
      >
        {{ menu.title }}
      </v-tab>
    </v-tabs>

    <!-- <v-tabs icons-and-text>
      <v-tab
        v-for="menu in menus" 
        :key="menu.title" 
        :to="menu.url" 
        exact
      >
        {{ menu.title }}
        <v-icon>{{ menu.icon }}</v-icon>
      </v-tab>
    </v-tabs> -->

  <!-- ②ここまで tabs -->

    <router-view></router-view>
    
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      users: [],
      menus: [
        { title: '紹介', icon: 'mdi-home', url: `/groups/${this.$route.params.id}/detail` },
        { title: 'メンバー', icon: 'mdi-text-account', url: `/groups/${this.$route.params.id}/member` },
        { title: 'イベント', icon: 'mdi-information-variant', url:`/groups/${this.$route.params.id}/events` },
        { title: '申請', icon: 'mdi-email-newsletter', url: `/groups/${this.$route.params.id}/approval` },
      ],
      value: 1 
    }
  },

  created () {
    this.getGroup();
  },
  
  methods: {
    getGroup() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
        });
    },
  },

}

</script>