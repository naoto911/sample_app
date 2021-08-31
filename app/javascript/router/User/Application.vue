<template>
  <div>
    <h1>Application list</h1>

    <v-row justify="space-between">
    <!-- ① ここから 申請中のデータ -->
      <v-col>
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
          class="mx-auto"
        >
          <v-card-title>
            {{ application.content }}
          </v-card-title>

          <p>ここにアイコンが表示されて欲しい</p>
          <!-- ここから②-2-1 Avatar -->
            <router-link
              v-for="application_group in applicaiton_group(application.group_id)"
              :key="application_group.id"
              :to=" '/groups/' + (Number(application_group.id)) + '/detail' "
              active-class="link--active"
              exact
              class="link"
            >
              <v-avatar
                cols="4"
              >
                <v-img
                  v-if="application_group"
                  :src= "application_group.image.url"
                  alt="John"
                ></v-img>
                <span v-else>G</span>
              </v-avatar>
            </router-link>
          <!-- ここまで②-2-1 Avatar -->

          <!-- <p>{{ applicaiton_group(application.group_id)[0].name }}</p> -->

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
    <!-- ① ここまで 申請中のデータ -->
    </v-row>

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

  // computed: {
  //   applicaiton_group(){
  //     const data = this.applicaiton_groups;
  //     console.log(data);
  //     const result = data.filter(x => x.id === this.application.group_id);
  //     console.log(this);
  //     console.log(this.application.group_id);
  //     return result;
  //   },
  // },

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