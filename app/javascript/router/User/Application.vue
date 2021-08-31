<template>
  <div>
    <h1>Application list</h1>

  <!-- ① ここから 申請中のデータ -->
    <p>申請中</p>
    <v-row justify="space-between">
      <v-col>
        <div
          v-if="!applications"
          class="text-h6 grey--text text--lighten-1 font-weight-light"
          style="align-self: center;"
        >
          You Don`t have any application
        </div>
      <!-- ここから -->
        <v-card
          v-else
          v-for="application in applications"
          :key="application.id"
          class="mx-auto"
        >
          <v-card-title>
            {{ application.content }}
          </v-card-title>

          <!-- ①-1 ここから 削除ボタン -->
            <v-btn @click="deleteApplication(application.id)" icon>
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          <!-- ①-1 ここまで 削除ボタン -->

          <!-- ①-2 ここから 申請Editへのリンク -->
            <router-link
              :to=" '/groups/' + (Number(application.group_id)) + '/joins/' + (Number(application.id)) +'/edit'"
              active-class="link--active"
              exact
              class="link"
            >
              <v-btn icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </router-link>
          <!-- ①-2 ここまで 申請Editへのリンク -->

        </v-card>
      <!-- ここまで -->
      </v-col>
    </v-row>
  <!-- ① ここまで 申請中のデータ -->

  <!-- ② ここから 申請中のデータ -->
    <p>承認依頼</p>
      <div
        class="text-h6 text--lighten-1 font-weight-light"
        style="align-self: center;"
      >
        You Don`t have any application
      </div>
  <!-- ② ここまで 申請中のデータ -->
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      application: [],
      applications: [],
      user: {}
    }
  },
  methods: {
    getUser() {
      axios
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.applications = response.data.applications;
        this.user = response.data.user;
      });
    },
  //ここから削除ボタンのメソッド
    deleteApplication(id) {
      axios.delete(`/api/v1/groups/${this.$route.params.id}/joins/${id}`)
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
  //ここまで削除ボタンのメソッド
  },

  created () {
    this.getUser();
  },
  mounted() {
  },
}

</script>