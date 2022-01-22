<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

        <!-- ① ここから 紹介 -->
          <v-col cols="10">
            <v-card-text>
              <h3 class="my-8">出身: 東京都</h3>
              <!-- <p>
                ここに出身値を表示
              </p> -->
              <h3 class="my-8">年齢: 25</h3>
              <!-- <p>
                ここに年齢を表示
              </p> -->
              <h3 class="my-8">自己紹介</h3>
              <p>
                ここに自己紹介文を記載可能
              </p>
            </v-card-text>
          </v-col>
        <!-- ① ここまで 紹介 -->

        <!-- ② ここから ボタン類 -->
          <v-col v-if="user" class="text-right" cols="2">

          <!-- ①-1 ここから 削除ボタン -->
            <v-btn icon>
            <!-- <v-btn @click="deleteUser(user.id)" icon> -->
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          <!-- ①-1 ここまで 削除ボタン -->

          <!-- ①-2 ここから UserEditへのリンク -->
            <router-link
              :to="'edit'"
              active-class="link--active"
              exact
              class="link"
            >
              <v-btn icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </router-link>
          <!-- ①-2 ここまで UserEditへのリンク -->

          </v-col>
        <!-- ② ここまで ボタン類 -->

        </v-row>
      </v-responsive>
    </v-card>

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      user: {},
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