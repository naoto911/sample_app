<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

          <v-col cols="10">
            <v-card-text>
              <v-radio-group
                v-model="Myanswer.answer"
                row
                @change="updateAnswer(Myanswer)"
              >
                <v-radio label="参加" value="○"></v-radio>
                <v-radio label="不参加" value="-"></v-radio>
              </v-radio-group>

              <h3>日付</h3>
                <p v-if="event.date" >{{ event.date }}</p>
                <p v-else>日付が未登録です</p>
              <h3>開催場所</h3>
                <!-- <p v-if="event.place" >{{ event.place }}</p> -->
                <!-- <p v-else>開催場所が未登録です。</p> -->
                <p v-if="!event.lat && !event.lng" >場所が未登録です。</p>
                <!-- <GoogleMap :parent_object="event"></GoogleMap> -->
            </v-card-text>

            <!-- 参加,不参加の順にv-forを実行 -->
            <!-- 各v-for内で,usersをv-forでさらにネストさせていることに注意 -->
            <div
              v-for="(users, index) in Summarize_users"
              :key="users.id"
              >
              <v-list subheader>
                <v-subheader>{{text[index]}}</v-subheader>

                <v-list-item
                  v-for="user in users"
                  :key="user.id"
                >
                  <v-list-item-avatar>
                    <v-img
                      v-if="user.image.url"
                      :src= "user.image.url"
                    ></v-img>
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title v-text="user.name"></v-list-item-title>
                  </v-list-item-content>
                  <!-- <v-list-item-icon>
                    <v-icon :color="user.introduction ? 'deep-purple accent-4' : 'grey'">
                      mdi-message-outline
                    </v-icon>
                  </v-list-item-icon> -->
                </v-list-item>
              </v-list>
              <v-divider v-if="!(index=Summarize_users.length)"></v-divider> 
            </div>
            
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
      participant_users : [],
      unparticipant_users: [],
      Myanswer: {},

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

  watch: {
    'Myanswer.answer': function() {
      this.getEvent()
    }
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
        this.participant_users = response.data.participant_users;
        this.unparticipant_users = response.data.unparticipant_users;
        const answers = response.data.answers;
        this.Myanswer = this.MyAnswer(answers)
        });
    },
    MyAnswer(answers){
      const data = answers
      const result = data.filter(x => x.event_id === this.event.id);
      return result[0];
    },
    updateAnswer(updateAnswer) {
      axios
        .patch(`/api/v1/answers/${updateAnswer.id}`, {
          answer: {
            answer: updateAnswer.answer
          }
        })

      .then(response => {
        console.log('OK');
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
      this.deleteEvent(this.delete_id);
      this.delete_id = null;
    },
  },

}
</script>