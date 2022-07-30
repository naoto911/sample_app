<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

        <!-- ここから 紹介 -->
          <v-col cols="10">
            <v-card-text>
              <h3>頻度</h3>
                <p v-if="group.frequency" >{{getFrequency(group.frequency)}}</p>
                <p v-else>頻度が未登録です</p>
              <h3>場所</h3>
                <!-- <p v-if="!group.lat && !group.lng" >{{group.region}}</p> -->
                <p v-if="!group.lat && !group.lng" >場所が未登録です。</p>
                <GoogleMap :parent_object="group"></GoogleMap>
            </v-card-text>
          </v-col>
        <!-- ここまで 紹介 -->

        <!-- ここから ボタン類 -->
          <v-col v-if="val" class="text-right" cols="2">
              <v-btn icon @click="openModal(group.id)">
                <v-icon>mdi-delete</v-icon>
              </v-btn>

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
          </v-col>
        <!-- ここまで ボタン類 -->

        </v-row>
      </v-responsive>
    </v-card>

    <Modal :showContent="showContent" @close="closeModal" @delete="deleteAction"></Modal>

  </div>
</template>

<script>
import Modal from '../../components/Modal.vue';
import GoogleMap from '../../components/GoogleMap.vue'
import axios from 'axios';

export default {

  components: { 
    Modal,
    GoogleMap,
  },

  data() {
    return {
      length: 3,
      onboarding: 0,
      dialog: false,

      group: {},
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
    this.getGroup(this.$route.params.id);
  },

  watch: {
    '$route' (to, from) {
      this.getGroup(to.params.id)
    }
 },

  methods: {
    getGroup(id) {
      axios
        .get(`/api/v1/groups/${id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
        });
    },
    deleteGroup(id) {
      axios.delete(`/api/v1/groups/${id}`)
        .then(res => {
          this.$router.push({ path: '/groups' });
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
          reslut = "ガチ"
          break;
        case 2:
          reslut = "時々"
          break;
        case 3:
          reslut = "まれ"
          break;
        default :
          reslut = null
      }
      return reslut;
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