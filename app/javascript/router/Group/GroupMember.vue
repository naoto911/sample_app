<template>
  <div>
    <v-card min-height="357">
      <v-row
        class="pa-4"
        justify="space-between"
      >
      <!-- ③ここから左のユーザー一覧 -->
        <v-col cols="5">
          <v-treeview
            :active.sync="active"
            :items="users"
            :open.sync="open"
            activatable
            color="warning"
            open-on-click
            transition
          >

          <!-- ④ここからitemにアカウントアイコンを追加 -->
            <template v-slot:prepend="{ item }">
              <v-layout justify-center>
                <v-avatar>
                  <v-img
                    v-if="item.image"
                    :src= "item.image.url"
                  ></v-img>
                  <v-icon v-else>mdi-account</v-icon>
                </v-avatar>
              </v-layout>
            </template>
          <!-- ④ここまでitemにアカウントアイコンを追加 -->

          </v-treeview>
        </v-col>
      <!-- ③ここまで左のユーザー一覧 -->

        <v-divider vertical></v-divider>

        <v-col
          class="d-flex text-center"
        >
          <v-scroll-y-transition mode="out-in">
          <!-- ①ここから誰も選んでないときの表示 -->
            <div
              v-if="!selected"
              class="text-h6 grey--text text--lighten-1 font-weight-light"
              style="align-self: center;"
            >
              Select a User
            </div>
          <!-- ①ここまで誰も選んでないときの表示 -->

          <!-- ⑤ここから右側の表示 -->
            <v-card
              v-else
              :key="selected.id"
              class="pt-6 mx-auto"
              flat
              max-width="400"
            >
              <v-card-text>
                <v-avatar
                  v-if="selected.image"
                  size="88"
                >
                  <v-img
                    :src= "selected.image.url"
                  ></v-img>
                </v-avatar>
                <h3 class="text-h5 mb-2">
                  {{ selected.name }}
                  <!-- <a
                    :href="`//${selected.id}`"
                    target="_blank"
                  >
                    {{ selected.id }}
                  </a> -->
                </h3>
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
                  年齢:
                </v-col>
                <v-col v-if="selected.age">{{ selected.age }}</v-col>
                <v-col v-else>未登録</v-col>

                <v-col
                  class="text-right mr-4 mb-2"
                  tag="strong"
                  cols="5"
                >
                  出身:
                </v-col>
                <v-col v-if="areas && getBirthplace(selected.birthplace)" >{{ getBirthplace(selected.birthplace).prefName }}</v-col>
                <v-col v-else>未登録</v-col>

                <v-col
                  class="text-right mr-4 mb-2"
                  tag="strong"
                  cols="5"
                >
                  性別:
                </v-col>
                <v-col v-if="selected.sex" >{{getSex(selected.sex)}}</v-col>
                <v-col v-else>未登録</v-col>

                <v-col
                  class="text-right mr-4 mb-2"
                  tag="strong"
                  cols="5"
                >
                  自己紹介:
                </v-col>
                <v-col v-if="selected.introduction" >{{selected.introduction}}</v-col>
                <v-col v-else>未登録</v-col>

              <!-- ② ここから 削除ボタン -->
                <v-col v-if="val && selected.id != current_user.id" class="text-right" cols="2">
                  <v-btn 
                    icon 
                    @click="openModal(selected.id)"
                  >
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </v-col>
              <!-- ② ここまで 削除ボタン -->

              </v-row>
            <!-- ②ここまでユーザー情報 -->

            </v-card>
          <!-- ⑤ここまで右側の表示 -->
          </v-scroll-y-transition>
        </v-col>
      </v-row>
    </v-card>

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
      active: [],
      open: [],
      users: [],
      current_user: [],
      joions: [],
      members: [],

      showContent: false,
      delete_group_id: null,
      delete_id: null,

      areas: [],
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  computed: {
    items () {
      return [
        {
          name: 'Users',
          children: this.users,
        },
      ]
    },
    selected () {
      //active = 左のユーザーから誰かを選択したらその人がactive
      if (!this.active.length) return undefined //非activeだとselectedはundefined
      const id = this.active[0]
      return this.users.find(user => user.id === id) //usersからuser.idがidと等しいuserを探す
    },
  },

  created() {
    this.getUsers();
    this.getAreas();
  },

  methods: {
    getUsers() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}.json`)
        .then(response => {
          this.users = response.data.users;
          this.joins = response.data.joins;
          this.current_user = response.data.current_user;
        });
    },

    getSex(check_value) {
      var reslut = null;
      switch (check_value) {
        case 1:
          reslut = "男性"
          return reslut;
          break;
        case 2:
          reslut = "女性"
          return reslut;
          break;
        default:
          reslut = null
          return reslut;
      }
    },
    getAreas(){
      var temporary = axios.defaults.headers.common; //token headerを一時保存
      axios.defaults.headers.common = null; //token headerを消去
      var area_url = 'https://opendata.resas-portal.go.jp/api/v1/prefectures';

      axios
      .get(area_url,{
        headers: { "X-API-KEY": "imTqHdr2MusisKwbx1V4J3wS3XrVmwEb26Uv83qB" },
      })
      .then(response =>  {
        this.areas = response.data.result;
        axios.defaults.headers.common = temporary; //token headerを復活
      });
    },
    getBirthplace(key_id){
      // const key_id = this.user.birthplace;
      const data = this.areas;
      const result = data.filter(x => x.prefCode === key_id);
      return  result[0];
    },

    deleteApplication(group_id, id) {
      axios.delete(`/api/v1/groups/${group_id}/joins/${id}`)
        .then(res => {
          this.getUsers();
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
    openModal(user_id) {
      this.showContent = true;
      this.delete_group_id = this.$route.params.id;
      var id = this.getUserJoin(user_id).id;
      this.delete_id = id;
    },
    closeModal () {
      this.showContent = false
      this.delete_group_id = null;
      this.delete_id = null;
    },
    deleteAction () {
      this.showContent = false
      this.deleteApplication(this.delete_group_id, this.delete_id);
      this.delete_group_id = null;
      this.delete_id = null;
    },
    getUserJoin(key_id) {
      const data = this.joins;
      const result = data.filter(x => x.user_id === key_id);
      return result[0];
    },
  },

}
</script>