<template>
  <div>
    <h1>Approval list</h1>
    <p>申請中</p>
    <div
      v-if="approvals.length == 0"
      class="text-h6 grey--text text--lighten-1 font-weight-light"
      style="align-self: center;"
    >
      You Don`t have any approvals
    </div>
  <!-- ここから ② 申請list -->
    <v-card
      v-else
      v-for="approval in approvals"
      :key="approval.id"
      class="my-8"
    >
    <v-container>
      <v-row 
        justify="space-around"
        align="center"
      >
        <v-col cols=2>
          <!-- ここから②-2-1 Avatar -->
            <router-link
              v-for="approval_user in getApprovalUser(approval.user_id)"
              :key="approval_user.id"
              :to=" '/users/' + (Number(approval_user.id)) + '/detail' "
              active-class="link--active"
              exact
              class="link"
            >
              <v-avatar>
                <v-img
                  v-if="approval_user"
                  :src= "approval_user.image.url"
                  alt="John"
                ></v-img>
                <span v-else>G</span>
              </v-avatar>
            </router-link>
          <!-- ここまで②-2-1 Avatar -->
        </v-col>

        <v-col cols=8>
          <v-card-title>
            {{ approval.content }}
          </v-card-title>
        </v-col>

        <v-col cols=2>
          <!-- ①-1 ここから 拒否ボタン -->
            <v-btn @click="denyApplication(approval.id)" icon>
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          <!-- ①-1 ここまで 拒否ボタン -->

          <!-- ①-2 ここから 承認ボタン -->
            <v-btn @click="permitApproval(approval.id)" icon>
              <v-icon>mdi-account-multiple-check</v-icon>
            </v-btn>  
            <!-- <router-link
              :to=" '/groups/' + (Number(approval.group_id)) + '/joins/' + (Number(approval.id)) +'/permit'"
              active-class="link--active"
              exact
              class="link"
            >
              <v-btn icon>
                <v-icon>mdi-account-multiple-check</v-icon>
              </v-btn>
            </router-link> -->
          <!-- ①-2 ここまで 承認ボタン -->
        </v-col>
        
      </v-row>
    </v-container>
    </v-card>
  <!-- ここまで ② 申請list -->
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      approval: [],
      approval_user: [], 

      group: [],
      approvals: [],
      approval_users: [], 
    }
  },

  created () {
    this.getUser();
  },

  methods: {
    getUser() {
      axios
      .get(`/api/v1/groups/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.approvals = response.data.approvals;
        this.approval_users = response.data.approval_users;
      });
    },
    permitApproval(id) {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/joins/${id}/permit.json`)
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
    denyApplication() {
    },
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
    getApprovalUser(key_id){
      const data = this.approval_users;
      const result = data.filter(x => x.id === key_id);
      return result;
    },
  },

}
</script>