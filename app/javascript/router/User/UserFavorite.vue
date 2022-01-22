<template>
  <div>
    <p>ここにお気に入りGroup一覧を表示</p>

  <!-- ここから ② Event一覧 -->
    <v-card
      v-for="user_favorite_group in user_favorite_groups"
      :key="user_favorite_group.id"
      class="my-8"
    >
      <v-container>
        <v-row 
          justify="space-around"
          align="center"
        >

          <!-- <v-col cols=4>
              {{ join_event.date }}
          </v-col>

          <v-col 
            v-for="event_group in getEvnetGgroup(join_event.group_id)"
            :key="event_group.id"
            cols=4
          >
              {{ event_group.name }}
          </v-col>

          <v-col cols=4>
            <v-card-title>
              {{ join_event.place }}
            </v-card-title>
          </v-col> -->

        </v-row>
      </v-container>
    </v-card>
  <!-- ここまで ② Event一覧 -->

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      user_favorite_groups: [],
      user: {},
    }
  },

  created () {
    // this.getUser();
  },

  methods: {
    // getUser() {
    //   axios
    //   .get(`/api/v1/users/${this.$route.params.id}.json`)
    //   .then(response => {
    //     this.user_groups = response.data.user_groups;
    //     this.user = response.data.user;
    //     this.join_events = response.data.join_events;
    //   });
    // },
    // getEvnetGgroup(key_id){
    //   const data = this.user_groups;
    //   const result = data.filter(x => x.id === key_id);
    //   return result;
    // },
  },


}

</script>