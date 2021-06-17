<template>
  <div>
    <p>{{ group.name }}</p>
    <p>{{ group.introduction }}</p>
    <router-view></router-view>
    
    <v-bottom-navigation
      :value="value"
      color="primary"
    >
      <v-btn
        v-for="menu in menus" 
        :key="menu.title" 
        :to="menu.url" exact
      >
        <span>{{ menu.title }}</span>
        <v-icon>{{ menu.icon }}</v-icon>
      </v-btn>

    </v-bottom-navigation>

  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      users: [],
      menus: [
      { title: 'Group', icon: 'mdi-home', url: `/groups/${this.$route.params.id}` },
      { title: 'Edit', icon: 'mdi-account-multiple-plus', url: `/groups/${this.$route.params.id}/edit` },
      { title: 'Member', icon: 'mdi-text-account', url: `/groups/${this.$route.params.id}/member` },
      // { title: 'About', icon: 'mdi-information-variant', url: '/bar' },
      { title: 'Event', icon: 'mdi-information-variant', url:`/groups/${this.$route.params.id}/event` }
      ]
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/groups/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.users = response.data.users;
      });
  }
}

</script>