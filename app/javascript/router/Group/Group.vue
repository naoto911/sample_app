<template>
  <div>
  <!-- ①ここから header -->
    <v-card flat>
      <v-card-text class="pa-0">
        <v-layout align-center>
          <v-avatar size="60" color="grey">
            <v-img
              v-if="group.image && group.image.url"
              :src= "group.image.url"
            ></v-img>
            <v-icon v-else>mdi-camera</v-icon>
          </v-avatar>
          <v-card-title class="text-h4">{{ group.name }}</v-card-title>
          <v-spacer></v-spacer>

          <v-btn icon>
            <v-icon v-if="favorite_status" @click="deleteFavorite()">mdi-heart</v-icon>
            <v-icon v-else @click="registerFavorite()">mdi-heart-outline</v-icon>
          </v-btn>

          <router-link 
            v-if="this.checkPermittedUser(current_user.id, all_joins) == false"
            :to=" '/groups/' + (Number(this.$route.params.id)) +'/joins/new' "
            active-class="link--active"
            exact
            class="link"
          >
            <v-btn icon>
              <v-icon>mdi-gesture-tap-button</v-icon>
            </v-btn>
          </router-link>

          <v-btn 
            icon 
            v-else-if="this.checkJoinUser(current_user.id, joins) && !includeAdminuser"
            @click="openModal(current_user.id)"
          >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </v-layout>
      </v-card-text>

      <v-card-text class="pl-0">
        {{ group.introduction }}
        <!-- {{ group.introduction | omittedText(10) }}  -->
      </v-card-text>

      <v-card-text class="pt-0 pl-0">
        <a :href="group.instagram">
          <v-btn
            v-for="icon in icons"
            :key="icon"
            icon
          >
            <v-icon left> 
              {{ icon }}
            </v-icon>
          </v-btn>
        </a>
      </v-card-text>

    </v-card>
  <!-- ①ここまで header -->
    <v-divider></v-divider>

  <!-- ②ここから tabs -->
    <v-tabs v-if="group">
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
        <v-badge
          v-if="approval_users_count > 0"
          color="orange"
          :content="approval_users_count"
        >
          {{ admin_menu.title }}
        </v-badge>
        <div v-else>
          {{ admin_menu.title }}
        </div>
      </v-tab>
    </v-tabs>
  <!-- ②ここまで tabs -->

    <router-view  class="my-5" :val="includeAdminuser"></router-view>

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
      users: [],
      current_user: [],
      all_joins: [],
      joins: [],
      approval_users_count: [],

      menus: [
        { title: '紹介', icon: 'mdi-home', url: `/groups/${this.$route.params.id}/detail` },
        { title: 'メンバー', icon: 'mdi-text-account', url: `/groups/${this.$route.params.id}/member` },
        { title: 'イベント', icon: 'mdi-information-variant', url: `/groups/${this.$route.params.id}/events` },
      ],
      admin_menu: { title: '承認', icon: 'mdi-email-newsletter', url: `/groups/${this.$route.params.id}/approval` },

      value: 1,
      includePermittedUser: false,
      includeJoinUser: false,
      includeAdminuser: false,

      favorite_status: false,

      showContent: false,
      delete_group_id: null,
      delete_id: null,

      icons: [
        'mdi-twitter',
        'mdi-instagram',
      ],
    }
  },

  created () {
    this.getGroup(this.$route.params.id);
    this.getFavorite(this.$route.params.id);
  },

  watch: {
    '$route' (to, from) {
      this.getGroup(to.params.id)
      this.getFavorite(to.params.id)
    }
 },
 
  filters: {
    omittedText(text,count) {
     // count文字目以降は"…"
     return text.length > count ? text.slice(0, count) + "…" : text;
    }
  },

  methods: {
    getGroup(id) {
      axios
        .get(`/api/v1/groups/${id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
          this.current_user = response.data.current_user;
          this.all_joins = response.data.all_joins;
          this.joins = response.data.joins
          this.approval_users_count = response.data.approval_users_count; 
        });
    },
    getFavorite(id) {
      axios
        .get(`/api/v1/groups/${id}/favorites.json`,{
          params: {
            group_id: this.$route.params.id
          }
        })
        .then(response => {
          this.favorite_status = response.data.favorite_status;
        });
    },
    checkPermittedUser(check_id, check_id2) {
      if (this.checkUser(check_id, check_id2)) {  //current_userがgroup申請済の場合, includePermittedUser = true
        this.includePermittedUser = true;
      }
      return this.includePermittedUser;
    },
    checkJoinUser(check_id, check_id2) {
      if (this.checkUser(check_id, check_id2)) {  //current_userがgroup所属済の場合, includeJoinUser = true
        this.includeJoinUser = true;
      }
      return this.includeJoinUser;
    },
    checkUser(check_id, check_id2) {
      var result = false
      for(var i in check_id2) {
        var join = check_id2[i];
        if(join.user_id == check_id)  {
          result = true;
        }
      }
      return result;
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
      axios.delete(`/api/v1/groups/${this.$route.params.id}/favorites`)
        .then(res => {
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
      this.favorite_status = false;
    },
    registerFavorite() {
      if (!this.group) return;
      const formData = new FormData()
      formData.append('favorite[group_id]', this.$route.params.id)
      formData.append('favorite[user_id]', this.current_user.id)

      axios
        .post(`/api/v1/groups/${this.$route.params.id}/favorites`, formData)
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
      this.favorite_status = true;
    },
    deleteApplication(group_id, id) {
      axios.delete(`/api/v1/groups/${group_id}/joins/${id}`)
        .then(res => {
          this.getGroup();
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
    openModal(user_id) {
      this.showContent = true;
      this.delete_group_id = this.$route.params.id;
      var id = this.getUserJoin(user_id).id;
      this.delete_id = id;
    },
    closeModal () {
      this.showContent = false
      this.delete_group_id = null;
      this.delete_id = null;
    },
    deleteAction () {
      this.showContent = false
      this.deleteApplication(this.delete_group_id, this.delete_id);
      this.delete_group_id = null;
      this.delete_id = null;
    },
    getUserJoin(key_id) {
      const data = this.joins;
      const result = data.filter(x => x.user_id === key_id);
      return result[0];
    },

  },

}
</script>