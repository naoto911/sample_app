<template>
  <div>
    <p>Mypage</p>
    <p>{{ user.name }}</p>
    <p>{{ user.id }}</p>
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      user: {}
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.user = response.data.user;
      });
  }
}

</script>