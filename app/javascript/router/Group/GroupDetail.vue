<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

        <!-- ① ここから 紹介 -->
          <v-col cols="10">
            <v-card-text>
              <h3>頻度</h3>
                <p v-if="group.frequency" >{{getFrequency(group.frequency)}}</p>
                <p v-else>頻度が未登録です</p>
              <h3>場所</h3>
                <p v-if="group.region" >{{group.region}}</p>
                <p v-else>場所が未登録です。</p>
              <h3>SNS</h3>
                <p v-if="group.instagram" >{{group.instagram}}</p>
                <p v-else>instagramが未登録です。</p>
              <h3>説明</h3>
                <p v-if="group.introduction" >{{group.introduction}}</p>
                <p v-else>グループ説明が未記載です。</p>
            </v-card-text>
          </v-col>
        <!-- ① ここまで 紹介 -->

        <!-- ② ここから ボタン類 -->
          <v-col v-if="val" class="text-right" cols="2">

            <!-- ②-1 ここから 削除ボタン -->
              <v-btn 
                icon 
                @click="openModal(group.id)"
              >
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            <!-- ②-1 ここまで 削除ボタン -->

            <!-- ②-2 ここから 編集ボタン -->
              <router-link
                :to=" '/groups/' + (Number(group.id)) + '/edit'"
                active-class="link--active"
                exact
                class="link"
              >
                <v-btn icon>
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </router-link>
            <!-- ②-2 ここまで 編集ボタン -->

          </v-col>
        <!-- ② ここまで ボタン類 -->

        </v-row>
      </v-responsive>
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
      length: 3,
      onboarding: 0,
      dialog: false,

      group: [],
      users: [],

      showContent: false,
      delete_id: null,
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  created() {
    this.getGroup();
  },

  methods: {
    next () {
      this.onboarding = this.onboarding + 1 === this.length
        ? 0
        : this.onboarding + 1
    },
    prev () {
      this.onboarding = this.onboarding - 1 < 0
        ? this.length - 1
        : this.onboarding - 1
    },
    getGroup() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
        });
    },
    deleteGroup(id) {
      axios.delete(`/api/v1/groups/${id}`)
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
    getFrequency(check_value) {
      var reslut = null;
      switch (check_value) {
        case 1:
          // console.log('ガチ');
          reslut = "ガチ"
          return reslut;
          break;
        case 2:
          // console.log('時々');
          reslut = "時々"
          return reslut;
          break;
        case 3:
          // console.log('まれ');
          reslut = "まれ"
          return reslut;
          break;
        default :
          // console.log('選択');
          reslut = null
          return reslut;
      }
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
      this.deleteGroup(this.delete_id);
      this.delete_id = null;
    },
  },

}
</script>