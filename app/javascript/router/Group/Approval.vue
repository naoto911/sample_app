<template>
  <div>
    <p>参加リクエスト一覧</p>

  <!-- ここから ② 申請無しの場合 -->
    <div
      v-if="approvals.length == 0"
      class="text-h6 grey--text text--lighten-1 font-weight-light"
      style="align-self: center;"
    >
      申請中のユーザーはいません
    </div>
  <!-- ここまで ② 申請無しの場合 -->

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

        <!-- ここから ②-1 User情報 -->
          <v-col cols=4>
            <router-link
              v-for="approval_user in getApprovalUser(approval.user_id)"
              :key="approval_user.id"
              :to=" '/users/' + (Number(approval_user.id)) + '/profile' "
              active-class="link--active"
              exact
              class="link"
            >
              <v-row align="center">

              <!-- ここから②-1-1 Avatar -->
                <v-col cols="2">
                  <v-avatar>
                    <v-img
                      v-if="approval_user"
                      :src= "approval_user.image.url"
                      alt="John"
                    ></v-img>
                    <span v-else>G</span>
                  </v-avatar>
                </v-col>
              <!-- ここから②-1-1 Avatar -->

              <!-- ここから②-1-2 User_name -->
                <v-col cols="10">
                  <v-card-title>
                    {{ approval_user.name }}
                  </v-card-title>
                </v-col>
              <!-- ここから②-1-2 User_name -->

              </v-row>
            </router-link>
          </v-col>
        <!-- ここまで ②-1 User情報 -->

        <!-- ここから ②-2 申請内容 -->
          <v-col cols=6>
            <v-card-title>
              {{ approval.content }}
            </v-card-title>
          </v-col>
        <!-- ここまで ②-2 申請内容 -->

        <!-- ここから ②-3 ボタン類 -->
          <v-col cols=2>
            <!-- ①-1 ここから 拒否ボタン -->
              <v-btn 
                icon 
                @click="openModal(approval.id)"
              >
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            <!-- ①-1 ここまで 拒否ボタン -->

            <!-- ①-2 ここから 承認ボタン -->
              <v-btn 
                icon 
                @click="permitApproval(approval.id)"
              >
                <v-icon>mdi-account-multiple-check</v-icon>
              </v-btn>  
            <!-- ①-2 ここまで 承認ボタン -->
          </v-col>
        <!-- ここまで ②-3 ボタン類 -->

        </v-row>
      </v-container>
    </v-card>
  <!-- ここまで ② 申請list -->

    <Modal :showContent="showContent" @close="closeModal" @delete="deleteAction"></Modal>
  </div>
</template>


<script>
import Modal from '../../components/Modal.vue';
import axios from 'axios';

export default {

  components: { 
    Modal,
  },

  data() {
    return {
      approval: [],
      approval_user: [], 

      group: [],
      approvals: [],
      approval_users: [], 

      showContent: false,
      delete_id: null,
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
    denyApproval(id) {
      axios.delete(`/api/v1/groups/${this.$route.params.id}/joins/${id}/deny`)
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
    getApprovalUser(key_id){
      const data = this.approval_users;
      const result = data.filter(x => x.id === key_id);
      return result;
    },
    openModal(id) {
      this.showContent = true;
      this.delete_id = id;
    },
    closeModal () {
      this.showContent = false
      this.delete_id = null;
    },
    deleteAction () {
      this.showContent = false
      this.denyApproval(this.delete_id);
      this.delete_id = null;
    },
  },

}
</script>