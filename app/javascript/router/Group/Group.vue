<template>
  <div>
    <h2>{{ group.name }}</h2>
    <!-- <h2>{{ group.introduction }}</h2> -->
    <router-view></router-view>
    
    <v-bottom-navigation
      :value="value"
      color="primary"
    >
      <v-btn
        v-for="menu in menus" 
        :key="menu.title" 
        :to="menu.url" 
        exact
      >
        <span>{{ menu.title }}</span>
        <v-icon>{{ menu.icon }}</v-icon>
      </v-btn>

    </v-bottom-navigation>

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      users: [],
      menus: [
      { title: 'GroupDetail', icon: 'mdi-home', url: `/groups/${this.$route.params.id}/detail` },
      { title: 'Edit', icon: 'mdi-account-multiple-plus', url: `/groups/${this.$route.params.id}/edit` },
      { title: 'Member', icon: 'mdi-text-account', url: `/groups/${this.$route.params.id}/member` },
      // { title: 'About', icon: 'mdi-information-variant', url: '/bar' },
      { title: 'Event', icon: 'mdi-information-variant', url:`/groups/${this.$route.params.id}/events` }
      ],
      value: 1 
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