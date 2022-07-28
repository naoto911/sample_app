<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

          <v-col cols="10">
            <v-card-text>
              <h3>日付</h3>
                <p v-if="event.date" >{{ event.date }}</p>
                <p v-else>日付が未登録です</p>
              <h3>開催場所</h3>
                <!-- <p v-if="event.place" >{{ event.place }}</p> -->
                <!-- <p v-else>開催場所が未登録です。</p> -->
                <p v-if="!event.lat && !event.lng" >場所が未登録です。</p>
                <!-- <GoogleMap :parent_object="event"></GoogleMap> -->
          
            <!-- 参加,不参加の順にv-forを実行 -->
            <!-- 各v-for内で,usersをv-forでさらにネストさせていることに注意 -->
            <div
              v-for="(users, index) in Summarize_users"
              :key="users.id"
              >
                <h3>{{text[index]}}</h3>
                <v-row 
                  v-for="val in users"
                  :key="val.id"
                  cols="12"
                  align="center"
                >
                  <v-col cols="6">
                    <router-link
                      :to=" '/users/' + (Number(val.id)) + '/profile/' "
                      active-class="link--active"
                      exact
                      class="link"
                    >
                      <v-row>
                        <v-col cols="1">
                          <v-avatar color="grey">
                            <v-img
                              v-if="val.image.url"
                              :src= "val.image.url"
                              alt="John"
                            ></v-img>
                            <v-icon v-else>mdi-account</v-icon>
                          </v-avatar>
                        </v-col>
                        <v-col cols="11">
                          <v-card-text class="ml-4">
                            {{ val.name }}
                          </v-card-text>
                        </v-col>
                      </v-row>
                    </router-link>
                  </v-col>
                  <v-col cols="6">
                  </v-col>
                </v-row>
            </div>
            </v-card-text>
          </v-col>

        <!--  ここから ボタン類 -->
          <v-col v-if="val" class="text-right" cols="2">

            <v-btn icon @click="openModal(event.id)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
            
            <router-link
              :to=" $route.path + '/edit' "
              active-class="link--active"
              exact
              class="link"
            >
              <v-btn icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </router-link>

          </v-col>
        <!--  ここまで ボタン類 -->

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
      group: {},
      event: {},
      answers: [],
      users: [],
      participant_users : [],
      unparticipant_users: [],

      showContent: false,
      delete_id: null,

      text: ["参加","不参加"],
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  computed: {
    Summarize_users(){
      return [this.participant_users,this.unparticipant_users];
    },
  },

  created () {
    this.getEvent();
  },

  methods: {
    deleteEvent(id) {
      axios.delete(`/api/v1/groups/${this.$route.params.id}/events/${id}`)
        .then( (res) => {
          this.$router.push({ path: `/groups/${this.$route.params.id}/events` });
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
    getEvent() {
      axios
      .get(`/api/v1/groups/${this.$route.params.id}/events/${this.$route.params.event_id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.event = response.data.event;
        // this.answers = response.data.answers;
        // this.users = response.data.users;
        this.participant_users = response.data.participant_users;
        this.unparticipant_users = response.data.unparticipant_users;
        });
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
      this.deleteEvent(this.delete_id);
      this.delete_id = null;
    },
  },

}
</script>