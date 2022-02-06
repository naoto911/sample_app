<template>
  <div>
    <p>ここにアプリの紹介を記載する</p>

    <router-link
      :to="menus[0].url"
      active-class="link--active"
      exact
      class="link"
    >
      <h3>グループを探す</h3>
    </router-link>

  </div>
</template>

<script>
import axios from 'axios';

export default {

  data() {
    return {
      groups: [],
      group: null,
      groups_length: [],

      menus: [
        { title: 'Home', icon: 'mdi-home', url: '/groups' },
        { title: 'Create', icon: 'mdi-account-multiple-plus', url: '/groups/new' },
        { title: 'Login', icon: 'mdi-information-variant', url: '/login' }
        ],
    }
  },

  methods: {
    getGroup(){
      axios
        .get('/api/v1/groups.json')
        .then(response => {
          this.groups = response.data.groups
          this.groups_length = response.data.groups_length

        });
    },
  },

}
</script>