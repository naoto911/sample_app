<template>
  <div>

    <v-row align="center">
      <v-col cols="1">
        <v-avatar size="60" color="grey">
          <v-img
            v-if="user.image && user.image.url"
            :src= "user.image.url"
          ></v-img>
          <v-icon v-else>mdi-account</v-icon>
        </v-avatar>
      </v-col>
      <v-col cols="10">
        <v-card-text>
          <h2 class="ml-4">{{ user.name }}</h2>
        </v-card-text>
      </v-col>
    </v-row>

    <!-- ②ここから tabs -->
      <v-tabs>
        <v-tab
          v-for="menu in menus" 
          :key="menu.title" 
          :to="menu.url" 
          exact
        >
          <v-badge
            v-if="applicaiton_groups_count > 0 && menu.title == '申請' "
            color="orange"
            :content="applicaiton_groups_count"
          >
            {{ menu.title }}
          </v-badge>
          <div v-else>
            {{ menu.title }}
          </div>
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
      applicaiton_groups_count: [],

      menus: [
        { title: 'プロフィール', icon: 'mdi-home', url: `/users/${this.$route.params.id}/profile` },
        { title: 'イベント', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/event` },
        { title: '申請', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/application` },
        { title: 'お気に入り', icon: 'mdi-email-newsletter', url: `/users/${this.$route.params.id}/favorite` },
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
        this.applicaiton_groups_count = response.data.applicaiton_groups_count;
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