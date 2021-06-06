<template>
  <div>
    <ul>
      <li v-for="user in users">{{ user.name }}</li>
    </ul>
  </div>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      //axiosで取得するデータを入れるため、空でOK
      group: [],
      users: []
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      //GETリクエストでRailsで作成したjsonを取得する
      .get(`/api/v1/groups/${this.$route.params.id}.json`)
      //response.data は RailsのUser.select(:id, :name, :email)
      //これをdata()で定義したusersに代入する
      .then(response => {
        this.group = response.data.group;
        this.users = response.data.users;
      });
  }
}

</script>