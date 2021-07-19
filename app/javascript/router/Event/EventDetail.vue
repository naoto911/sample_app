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

    <p>{{ event.date }}</p>
    <p>{{ event.place }}</p>

    <ul>    
      <li
        v-for="val in users"
        :key="val.id"
        cols="4"
       >
        <p>{{ val.name }}</p>
      </li>
    </ul>

    <ul>    
      <li
        v-for="val in answers"
        :key="val.id"
        cols="4"
       >
        <p>{{ val.answer }}</p>
      </li>
    </ul>

  </div>
</template>

<script>
// axiosを読み込む
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

  methods: {
  //ここから削除ボタンのメソッド
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
  //ここから削除ボタンのメソッド
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/groups/${this.$route.params.id}/events/${this.$route.params.event_id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.event = response.data.event;
        this.answers = response.data.answers;
        this.users = response.data.users;
      });
  }
}

</script>