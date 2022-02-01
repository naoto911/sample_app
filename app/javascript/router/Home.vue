<template>
  <div>
    <GroupsCard :vals="groups" :groups_length="groups_length"></GroupsCard> 
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
      groups_length: [],
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
          this.groups_length = response.data.groups_length

        });
    },
  },

}
</script>