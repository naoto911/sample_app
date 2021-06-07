<template>
  <div>
    <GroupsCard :val="group" :vals="groups"></GroupsCard>
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
      group: null
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get('/api/v1/groups.json')
      .then(response => (this.groups = response.data))
  }
}

</script>

<style scoped>
</style>