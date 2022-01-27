<template>
  <div>
    <p>ここにお気に入りGroup一覧を表示</p>

  <!-- ここから ② 都道府県APIのテスト -->
    <v-select
      v-if="areas.data && areas.data.result"
      v-model="e1"
      item-text="prefName"
      item-value="value"
      :items="areas.data.result"
      menu-props="auto"
      label="Select"
      hide-details
      prepend-icon="mdi-map-marker"
      single-line
      return-object
    ></v-select>

    <p v-if="e1">{{e1}}</p>
  <!-- ここまで ② 都道府県APIのテスト -->

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

// axios.defaults.headers.common = {
//     'X-Requested-With': 'XMLHttpRequest',
//     'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
// };

export default {
  data() {
    return {
      user_favorite_groups: [],
      user: {},

      e1: {prefCode: 35, prefName:'山口県'},
      area: [],
      areas: [],
    }
  },

  created () {
    // this.getUser();
    this.getAreas();
    // this.getArea();
  },

  methods: {
    getArea () {
      console.log("ここで確認")
      // console.log(this.areas.data)
      // console.log(this.areas.data.result)
      let obj = this.areas.data.result;
      for(let k in obj) {
        // console.log(obj[k]);
        this.area.push(obj[k].prefName)
      }

      // var OneArea  = []
      // for (OneArea of this.areas.data.result) {
      //   console.log(OneArea)
      //   this.area.push(OneArea.prefName);
        return this.area;
      // }
    },
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
    getAreas(){
      var area_url = 'https://opendata.resas-portal.go.jp/api/v1/prefectures';
      axios
      .get(area_url,{
        headers: { "X-API-KEY": "imTqHdr2MusisKwbx1V4J3wS3XrVmwEb26Uv83qB" },
      })
      .then(response =>  {
        this.areas = response;
      });
    },
  },


}

</script>