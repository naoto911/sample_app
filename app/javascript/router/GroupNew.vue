<template>
  <div>
    <p>New</p>
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  components: { 
  },
  data() {
    return {
      group: null
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get('/api/v1/groups/new.json')
      .then(response => (this.group = response.data))
  }
}

</script>

<style scoped>
</style>