<template>
  <div>
  <!-- ①ここから header -->
    <v-row align="center">

    <!-- ①-1 ここから avatar -->
      <v-col cols="1">
        <v-avatar
          size="60"
        >
          <v-img
            v-if="group.image && group.image.url"
            :src= "group.image.url"
          ></v-img>
          <v-icon v-else>{{ menus[0].icon }}</v-icon>
        </v-avatar>
      </v-col>
    <!-- ①-1 ここまで avatar -->

    <!-- ①-2 ここから グループ名 -->
      <v-col cols="8">
        <h2>{{ group.name }}</h2>
      </v-col>
    <!-- ①-2 ここまで グループ名 -->

    <!-- ①-3 ここから お気に入りボタン -->
      <v-col cols="3" class="text-right">
        <v-btn 
          icon 
        >
          <v-icon v-if="favorite_status" @click="deleteFavorite()">mdi-heart</v-icon>
          <v-icon v-else @click="registerFavorite()">mdi-heart-outline</v-icon>
        </v-btn>
        <!-- </v-col> -->
    <!-- ①-3 ここまで お気に入りボタン -->


    <!-- ①-3 ここから 申請ボタン -->
      <!-- <v-col cols="1" class="text-right"> -->
          <router-link 
            v-if="this.checkUser(current_user.id, all_joins) == false"
            :to=" '/groups/' + (Number(this.$route.params.id)) +'/joins/new' "
            active-class="link--active"
            exact
            class="link"
          >
            <v-btn icon>
              <v-icon>mdi-gesture-tap-button</v-icon>
              <!-- <v-icon>mdi-human-greeting-variant</v-icon> -->
              <!-- <v-icon>mdi-file-document-multiple-outline</v-icon> -->
            </v-btn>
          </router-link>
      </v-col>
    <!-- ①-3 ここまで 申請ボタン -->

    </v-row>
  <!-- ①ここまで header -->


  <!-- ②ここから tabs -->
    <v-tabs>
      <v-tab
        v-for="menu in menus" 
        :key="menu.title" 
        :to="menu.url" 
        exact
      >
        {{ menu.title }}
      </v-tab>
      <v-tab 
        v-if="this.checkAdminser(current_user.id)"
        :to="admin_menu.url" 
        exact
      >
        {{ admin_menu.title }}
      </v-tab>
    </v-tabs>
  <!-- ②ここまで tabs -->

    <router-view  class="my-5" :val="includeAdminuser"></router-view>

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      users: [],
      current_user: [],
      all_joins: [],
      menus: [
        { title: '紹介', icon: 'mdi-home', url: `/groups/${this.$route.params.id}/detail` },
        { title: 'メンバー', icon: 'mdi-text-account', url: `/groups/${this.$route.params.id}/member` },
        { title: 'イベント', icon: 'mdi-information-variant', url:`/groups/${this.$route.params.id}/events` },
        // { title: '申請', icon: 'mdi-gesture-tap-button', url: `/groups/${this.$route.params.id}/approval` },
        // { title: '承認', icon: 'mdi-email-newsletter', url: `/groups/${this.$route.params.id}/approval` },
      ],
      admin_menu: { title: '承認', icon: 'mdi-email-newsletter', url: `/groups/${this.$route.params.id}/approval` },
      value: 1,
      includeUser: false,
      includeAdminuser: false,

      favorite_status: false,
    }
  },

  // computed: {
  //   isLiked() {
  //     if (this.favorite_status == null) { return false }
  //     return Boolean(this.findLikeId())
  //   },
  // },

  created () {
    this.getGroup();
  },

  methods: {
    getGroup() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
          this.current_user = response.data.current_user;
          this.all_joins = response.data.all_joins;
        });
    },
    checkUser(check_id, group_joins) {
      for(var i in group_joins) {
        var join = group_joins[i];
        if(join.user_id == check_id)  {  //current_userがgroup所属済の場合, includeUser = trueへ更新
          this.includeUser = true;
        }
      }
      return this.includeUser;
    },
    checkAdminser(check_id) {
      if(this.group.adminuser_id == check_id) {
        this.includeAdminuser = true;
      }
      else {
        this.includeAdminuser = false;
      }
      return this.includeAdminuser;
    },
    deleteFavorite() {
      this.favorite_status = false;
    },
    registerFavorite() {
      this.favorite_status = true;
    },
  },

}

</script>