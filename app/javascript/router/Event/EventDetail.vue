<template>
  <div>

      <!-- ②ここからEventEditへのリンク -->
        <router-link
          :to="  $route.path + '/edit'"
          active-class="link--active"
          exact
          class="link"
        >
          <v-btn icon>
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
        </router-link>
      <!-- ②ここまでUserEditへのリンク -->

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
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/groups/${this.$route.params.id}/events/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.event = response.data.event;
        this.answers = response.data.answers;
        this.users = response.data.users;
      });
  }
}

</script>