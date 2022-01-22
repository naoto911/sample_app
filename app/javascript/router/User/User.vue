<template>
  <div>
    <!-- <h1>マイページ</h1> -->

  <!-- ①ここから header -->
    <v-row align="center">

    <!-- ①-1 ここから avatar -->
      <v-col cols="1">
        <v-avatar
          size="60"
        >
          <v-img
            v-if="user.image"
            :src= "user.image.url"
          ></v-img>
          <v-icon v-else>{{ menus[0].icon }}</v-icon>
        </v-avatar>
      </v-col>
    <!-- ①-1 ここまで avatar -->

    <!-- ①-2 ここから グループ名 -->
      <v-col cols="10">
        <h2>{{ user.name }}</h2>
      </v-col>
    <!-- ①-2 ここまで グループ名 -->

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
    <!-- ②ここまで tabs -->

    <router-view  class="my-5"></router-view>

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      user: {},
      menus: [
        { title: 'プロフィール', icon: 'mdi-home', url: `/users/${this.$route.params.id}/profile` },
        { title: '申請', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/application` },
        { title: 'イベント', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/application` },
        { title: 'お気に入り', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/application` },
      ],
    }
  },

  created () {
    this.getUser();
  },

  methods: {
    getUser() {
      axios
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.user = response.data.user;
      });
    },
    deleteUser(id) {
      axios.delete(`/api/v1/users/${id}`)
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
  },

}

</script>