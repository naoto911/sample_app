<template>
  <div>
    <h1>Mypage</h1>

    <v-card class="mt-8">
      <v-row
        class="pa-4"
        justify="space-between"
      >

      <!-- ①ここからUser詳細 -->
        <v-col
          class="d-flex text-center"
        >
          <div
            v-if="!user"
            class="text-h6 grey--text text--lighten-1 font-weight-light"
            style="align-self: center;"
          >
            Select a User
          </div>
          <v-card
            v-else
            :key="user.id"
            class="pt-6 mx-auto"
            flat
            max-width="400"
          >
            <v-card-text>
              <v-avatar
                v-if="user.image"
                size="88"
              > 
              <!-- :src= "val.image.url" -->
                <v-img
                  :src= "user.image.url"
                  
                ></v-img>
              </v-avatar>
              <h3 class="text-h5 mb-2">
                {{ user.name }}
              </h3>
              <!-- <div class="blue--text mb-2">
                {{ selected.email }}
              </div>
              <div class="blue--text subheading font-weight-bold">
                {{ selected.username }}
              </div> -->
            </v-card-text>
            <v-divider></v-divider>
          <!-- ②ここからユーザー情報 -->
            <v-row
              class="text-left"
              tag="v-card-text"
            >
              <v-col
                class="text-right mr-4 mb-2"
                tag="strong"
                cols="5"
              >
                Age:
              </v-col>
              <v-col>{{ user.id }}</v-col>
              <v-col
                class="text-right mr-4 mb-2"
                tag="strong"
                cols="5"
              >
                From:
              </v-col>
              <v-col>
                <a
                  :href="`//${user.id}`"
                  target="_blank"
                >{{ user.id }}</a>
              </v-col>
            </v-row>
          <!-- ②ここまでユーザー情報 -->
          </v-card>
        </v-col>
      <!-- ①ここまでUser詳細 -->

      <!-- ①-1 ここから 削除ボタン -->
        <v-btn @click="deleteUser(user.id)" icon>
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      <!-- ①-1 ここまで 削除ボタン -->

      <!-- ①-2 ここから UserEditへのリンク -->
        <router-link
          :to="  (Number(user.id)) + '/edit'"
          active-class="link--active"
          exact
          class="link"
        >
          <v-btn icon>
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
        </router-link>
      <!-- ①-2 ここまで UserEditへのリンク -->
      
      </v-row>
    </v-card>

      <!-- ②-1 ここから 申請一覧へのリンク -->
        <router-link
          :to="  (Number(user.id)) + '/application'"
          active-class="link--active"
          exact
          class="link"
        >
          <v-btn icon>
            <v-icon>mdi-email-newsletter</v-icon>
          </v-btn>
        </router-link>
      <!-- ②-1 ここまで 申請一覧へのリンク -->

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      user: {}
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