<template>
  <div>
    <p>このリンク先にグループのイベント詳細を記載する</p>
    <p>{{ join.id }}</p>
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      group: [],
      join: [],
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      .get(`/api/v1/groups/${this.$route.params.id}.json`)
      .then(response => {
        this.group = response.data.group;
        this.join = response.data.join;
      });
  }
}

</script>