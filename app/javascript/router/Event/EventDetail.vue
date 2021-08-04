<template>
  <div>

  <!-- ①ここから ボタン類 -->
    <v-row>
      <v-col></v-col>
      <v-spacer></v-spacer>
      <v-col class="text-right">
        
        <!-- ①-1 ここから 削除ボタン -->
          <v-btn @click="deleteEvent(event.id)" icon>
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

  <!-- ①-1 ここから イベント詳細 -->
    <p>日付 : {{ event.date }}</p>
    <p>イベント名 : {{ event.place }}</p>
  <!-- ①-1 ここまで イベント詳細 -->    

  <!-- ①-2 ここから 参加ユーザー一覧 -->
    <h3>参加</h3>
      <p
        v-for="val in participantUsers()"
        :key="val.id"
        cols="4"
       >
        {{ val.name }}
      </p>
  <!-- ①-2 ここまで 参加ユーザー一覧 -->

  <!-- ①-3 ここから 不参加ユーザー一覧 -->
    <h3>不参加</h3>
      <!-- <p
        v-for="val in participantUsers()"
        :key="val.id"
        cols="4"
       >
        {{ val.name }}
      </p> -->
  <!-- ①-3 ここまで 不参加ユーザー一覧 -->

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      event: [],
      answers: [],
      users: [],
    }
  },

  computed: {
    eventAnswers(){
      const data = this.answers;
      const result = data.filter(x => x.answer === "-");
      return result;
    },
  },

  created () {
    this.getEvent();
    // this.pushEvent();
    // console.log(this.events2);
    // console.log("createdが実行された");
  },

  mounted () {
    // this.getEvent();
    // console.log(this.events2);
    // console.log("mountedが実行された");

    // this.pushEvent();
    // this.$refs.calendar.checkChange();
  },

  beforeUpdate(){
    // console.log(this.events2);
    // this.participantUsers();
    this.participantUsers();
    // console.log();
    // console.log(this.eventAnswers);
    console.log("beforeUpdateが実行された");
  },

  updated(){
    // console.log(this.events2);
    // console.log("updatedが実行された");
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
        this.answers = response.data.answers;
        this.users = response.data.users;
        });
    },

    participantUsers() {
      var result2 = [];
      const data2 = this.eventAnswers;
      const data3 = this.users;
      // var val = [];
      // var user =[];
      for (var val in data2) {
        // console.log(data2[val]);
        for (var user in data3 ) {
          if (data3[user].id == data2[val].user_id) {
            result2.push(data3[user]);
          }
        }
      }
      console.log(result2);
      return result2;
    },

  },

}

</script>