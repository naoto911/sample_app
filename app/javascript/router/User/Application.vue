<template>
  <div>
    <h1>Application list</h1>

    <!-- ① ここから 申請中のデータ -->
        <p>申請中</p>
        <div
          v-if="applications.length == 0"
          class="text-h6 grey--text text--lighten-1 font-weight-light"
          style="align-self: center;"
        >
          You Don`t have any applications
        </div>
      <!-- ここから -->
        <v-card
          v-else
          v-for="application in applications"
          :key="application.id"
          class="my-8"
        >
        <v-container>
          <v-row 
            justify="space-around"
            align="center"
          >
            <v-col cols=2>
              <!-- ここから②-2-1 Avatar justify="space-around"      -->
                <router-link
                  v-for="application_group in applicaiton_group(application.group_id)"
                  :key="application_group.id"
                  :to=" '/groups/' + (Number(application_group.id)) + '/detail' "
                  active-class="link--active"
                  exact
                  class="link"
                >
                  <v-avatar>
                    <v-img
                      v-if="application_group"
                      :src= "application_group.image.url"
                      alt="John"
                    ></v-img>
                    <span v-else>G</span>
                  </v-avatar>
                </router-link>
              <!-- ここまで②-2-1 Avatar -->
            </v-col>

            <v-col cols=8>
              <v-card-title>
                {{ application.content }}
              </v-card-title>
            </v-col>

            <v-col cols=2>
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
            </v-col>
          </v-row>
                </v-container>
        </v-card>

      <!-- ここまで -->
    <!-- ① ここまで 申請中のデータ -->

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
      approval: [],
      approvals: [],
      user: {},
      application_group: {},
      applicaiton_groups: {},
    }
  },

  methods: {
    getUser() {
      axios
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.applications = response.data.applications;
        this.approvals = response.data.approvals;
        this.user = response.data.user;
        this.applicaiton_groups = response.data.applicaiton_groups;
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
    applicaiton_group(key_id){
      const data = this.applicaiton_groups;
      console.log(data);
      const result = data.filter(x => x.id === key_id);
      console.log(key_id);
      console.log(result);
      console.log(result[0].name);
      return result;
    },
  },

  created () {
    this.getUser();
  },
  mounted() {
  },
}

</script>