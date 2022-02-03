<template>
  <div>
    <p>お気に入りGroup一覧</p>
    <div
      v-if="user_favorites_groups.length == 0"
      class="text-h6 grey--text text--lighten-1 font-weight-light"
      style="align-self: center;"
    >
      お気に入り中のグループはないです
    </div>

  <!-- ここから ② お気に入りGroup一覧 -->
    <v-card
      v-for="user_favorites_group in user_favorites_groups"
      :key="user_favorites_group.id"
      class="my-8"
    >
      <v-container>
        <v-row 
          justify="space-around"
          align="center"
        >

        <!-- ここから②-2-1 Avatar -->
          <v-col cols=1>
            <router-link
              :to=" '/groups/' + (Number(user_favorites_group.id)) + '/detail' "
              active-class="link--active"
              exact
              class="link"
            >
              <v-avatar>
                <v-img
                  v-if="user_favorites_group"
                  :src= "user_favorites_group.image.url"
                  alt="John"
                ></v-img>
                <span v-else>G</span>
              </v-avatar>
            </router-link>
          </v-col>
        <!-- ここまで②-2-1 Avatar -->

          <v-col cols=8>
            <v-card-title>
              {{ user_favorites_group.name }}
            </v-card-title>
          </v-col>

        <!-- ①-3 ここから お気に入りボタン -->
          <v-col cols="3" class="text-right">
            <v-btn 
              icon 
            >
              <!-- <v-icon>mdi-heart</v-icon> -->
              <v-icon @click="deleteFavorite(user_favorites_group.id)">mdi-heart</v-icon>
              <!-- <v-icon v-else @click="registerFavorite()">mdi-heart-outline</v-icon> -->
            </v-btn>
          </v-col>
        <!-- ①-3 ここまで お気に入りボタン -->

        </v-row>
      </v-container>
    </v-card>
  <!-- ここまで ② お気に入りGroup一覧 -->

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      user_favorite_groups: [],
      user: {},
      user_favorites_groups: [],

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
        this.user_groups = response.data.user_groups;
        this.user = response.data.user;
        this.join_events = response.data.join_events;
        this.user_favorites_groups = response.data.user_favorites_groups;
      });
    },
    deleteFavorite(key_id) {
      axios.delete(`/api/v1/groups/${key_id}/favorites`)
        .then(res => {
          this.getUser();
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