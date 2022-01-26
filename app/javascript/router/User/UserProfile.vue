<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

        <!-- ① ここから 紹介 -->
          <v-col cols="10">
            <v-card-text>
              <h3>年齢</h3>
                <p v-if="user.age">{{user.age}}</p>
                <p v-else>年齢が未登録です</p>
              <h3>性別</h3>
                <p v-if="user.sex" >{{getSex(user.sex)}}</p>
                <p v-else>性別が未登録です。</p>
              <h3>出身</h3>
              <!-- {{getFrequency(group.frequency)}} -->
                <p v-if="user.birthplace" >{{user.birthplace}}</p> 
                <p v-else>出身が未登録です。</p>
              <h3>自己紹介</h3>
                <p v-if="user.introduction" >{{user.introduction}}</p>
                <p v-else>自己紹介が未記載です。</p>
            </v-card-text>
          </v-col>
        <!-- ① ここまで 紹介 -->

        <!-- ② ここから ボタン類 -->
          <v-col v-if="user" class="text-right" cols="2">

          <!-- ①-1 ここから 削除ボタン -->
            <v-btn 
              icon 
              @click="openModal(user.id)"
            >
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
      group: [],
      user: {},

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
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.user = response.data.user;
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
          reslut = null
          return reslut;
      }
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
      this.deleteUser(this.delete_id);
      this.delete_id = null;
    },

  },


}

</script>