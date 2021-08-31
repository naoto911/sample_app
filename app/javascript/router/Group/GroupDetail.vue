<template>
  <div>

  <!-- ①ここから ボタン類 -->
    <v-row>
      <v-col></v-col>
      <v-spacer></v-spacer>
      <v-col class="text-right">
        
        <!-- ①-1 ここから 削除ボタン -->
          <v-btn @click="deleteGroup(group.id)" icon>
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        <!-- ①-1 ここまで 削除ボタン -->

        <!-- ①-2 ここから UserEditへのリンク -->
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
        <!-- ①-2 ここまで UserEditへのリンク -->

      </v-col>
    </v-row>
  <!-- ①ここまで ボタン類 -->

    <v-card
      flat
      tile
    >
    <!-- ②-1ここからスライド部分 -->
      <v-window
        v-model="onboarding"
      >
        <v-window-item
          v-for="n in length"
          :key="`card-${n}`"
        >
          <v-card
            color="grey"
            height="500"
          >
            <v-row
              class="fill-height"
              align="center"
              justify="center"
            >
              <v-img
                :src= "group.image.url"
                max-width="344"
              ></v-img>
            </v-row>
          </v-card>
        </v-window-item>
      </v-window>
    <!-- ②-1 ここからスライド部分 -->

    <!-- ②-2 ここからスライド下のボタン類 -->
      <v-card-actions class="justify-space-between">
        <v-btn
          text
          @click="prev"
        >
          <v-icon>mdi-chevron-left</v-icon>
        </v-btn>
        <v-item-group
          v-model="onboarding"
          class="text-center"
          mandatory
        >
          <v-item
            v-for="n in length"
            :key="`btn-${n}`"
            v-slot="{ active, toggle }"
          >
            <v-btn
              :input-value="active"
              icon
              @click="toggle"
            >
              <v-icon>mdi-record</v-icon>
            </v-btn>
          </v-item>
        </v-item-group>
        <v-btn
          text
          @click="next"
        >
          <v-icon>mdi-chevron-right</v-icon>
        </v-btn>
      </v-card-actions>
    <!-- ②-2 ここまでスライド下のボタン類 -->

    <!-- ③ここからグループ詳細 -->
      <v-row
        class="fill-height"
        align="center"
        justify="center"
      >
        <p
          style="font-size: 1rem;"
          class="grey--text"
        >
          {{ group.introduction }}
        </p>
      </v-row>
    <!-- ③ここまでグループ詳細 -->

    </v-card>
  </div>
</template>

<script>
import axios from 'axios';

  export default {
    data: () => ({
      length: 3,
      onboarding: 0,

      group: [],
      users: [],
    }),

    methods: {
      next () {
        this.onboarding = this.onboarding + 1 === this.length
          ? 0
          : this.onboarding + 1
      },
      prev () {
        this.onboarding = this.onboarding - 1 < 0
          ? this.length - 1
          : this.onboarding - 1
      },
      getGroup() {
        axios
          .get(`/api/v1/groups/${this.$route.params.id}.json`)
          .then(response => {
            this.group = response.data.group;
            this.users = response.data.users;
          });
      },
    //ここから削除ボタンのメソッド
      deleteGroup(id) {
        axios.delete(`/api/v1/groups/${id}`)
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
    //ここまで削除ボタンのメソッド
    },

    created() {
      // console.log("createdを実行")
      this.getGroup();
    },
  }
</script>