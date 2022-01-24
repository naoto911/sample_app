<template>
  <div>

  <!-- ①ここから ボタン類 -->
    <v-row>
      <v-col></v-col>
      <v-spacer></v-spacer>
      <v-col class="text-right">
        
        <!-- ①-1 ここから 削除ボタン -->
            <v-btn 
              icon 
              @click="openModal(event.id)"
            >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        <!-- ①-1 ここまで 削除ボタン -->

        <!-- ②-2 ここから UserEditへのリンク -->
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
        <!-- ②-2 ここまで UserEditへのリンク -->

      </v-col>
    </v-row>
  <!-- ①ここまで ボタン類 -->

  <!-- ②-1 ここから イベント詳細 -->
    <p>日付 : {{ event.date }}</p>
    <p>イベント名 : {{ event.place }}</p>
  <!-- ②-1 ここまで イベント詳細 -->    

  <!-- ②-2 ここから 参加ユーザー一覧 -->
    <h3>参加ユーザー</h3>
    <!-- ここから②-2-1 Avatar -->
      <router-link
        v-for="val in participant_users"
        :key="val.id"
        :to=" '/users/' + (Number(val.id)) "
        active-class="link--active"
        exact
        class="link"
      >

        <v-avatar
          cols="4"
        >
          <v-img
            v-if="val.image"
            :src= "val.image.url"
            alt="John"
          ></v-img>
          <span v-else>G</span>
        </v-avatar>
      </router-link>
    <!-- ここまで②-2-1 Avatar -->
  <!-- ②-2 ここまで 参加ユーザー一覧 -->

  <!-- ②-3 ここから 不参加ユーザー一覧 -->
    <h3>不参加ユーザー</h3>
      <router-link
        v-for="val in unparticipant_users"
        :key="val.id"
        :to=" '/users/' + (Number(val.id)) "
        active-class="link--active"
        exact
        class="link"
      >

        <v-avatar
          cols="4"
        >
          <v-img
            v-if="val.image"
            :src= "val.image.url"
            alt="John"
          ></v-img>
          <span v-else>G</span>
        </v-avatar>
      </router-link>
  <!-- ②-3 ここまで 不参加ユーザー一覧 -->

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
      event: [],
      answers: [],
      users: [],
      participant_users : [],
      unparticipant_users: [],

      showContent: false,
      delete_id: null,
    }
  },

  // computed: {
  //   eventAnswers(){
  //     const data = this.answers;
  //     const result = data.filter(x => x.answer === "○");
  //     return result;
  //   },
  // },

  created () {
    this.getEvent();
  },

  mounted () {
  },

  beforeUpdate(){
  },

  updated(){
  },

  methods: {
    deleteEvent(id) {
      axios.delete(`/api/v1/groups/${this.$route.params.id}/events/${id}`)
        .then( (res) => {
          this.$router.push({ path: `/api/v1/groups/${this.$route.params.id}/events` });
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
    // participantUsers() { //user毎のabatarとanswerの紐付けのための関数
    //   var result2 = [];
    //   const data2 = this.eventAnswers; //○のuserのみをdata2へ格納
    //   const data3 = this.users; //group所属なかのuserをdata3へ格納
    //   for (var val in data2) {  //data2をバラバラに展開
    //     // console.log(data2[val]);
    //     for (var user in data3 ) { //usersをバラバラに展開
    //       if (data3[user].id == data2[val].user_id) { //data2のuser_id (○のuser_id)と一致するdata3(group所属中のuserを検証
    //         result2.push(data3[user]); //result2へ格納 (○でかつgroup所属中のuserを抽出)
    //       }
    //     }
    //   }
    //   console.log(result2);
    //   return result2;
    // },
  },

}

</script>