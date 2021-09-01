<template>
  <div>
    <GroupsCard :vals="groups"></GroupsCard> 
  </div>
</template>

<script>
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

  created() {
    this.getGroup();
  },

  methods: {
    getGroup(){
      axios
        .get('/api/v1/groups.json')
        .then(response => {
          this.groups = response.data.groups
          this.current_user = response.data.current_user
        });
    }
  },

}
</script>