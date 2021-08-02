<template>
  <div>
    <GroupsCard :vals="groups"></GroupsCard> 
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';
import GroupsCard from '../components/GroupsCard.vue';

export default {
  components: { 
    GroupsCard 
  },
  data() {
    return {
      groups: [],
      group: null,
      current_user: [],
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  created() {
    axios
      .get('/api/v1/groups.json')
      // .then(response => (this.groups = response.data.groups))
      .then(response => {
        this.groups = response.data.groups
        this.current_user = response.data.current_user
      });
  }
};

</script>

<style scoped>
</style>