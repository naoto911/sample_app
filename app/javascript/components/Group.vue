<template>
  <table>
    <tbody>
      <tr>
        <th>ID</th>
        <th>名前</th>
        <th>紹介</th>
      </tr>
      <tr v-for="group in groups" :key="group.id">
        <td>{{ group.id }}</td>
        <router-link
          :to=" 'groups/' + (Number(group.id))"
          active-class="link--active"
          exact
          class="link"
        ><td>{{ group.name }}</td></router-link>
        <td>{{ group.introduction }}</td>
      </tr>
    </tbody>
  </table>
</template>

<script>
// axiosを読み込む
import axios from 'axios';

export default {
  data() {
    return {
      //axiosで取得するデータを入れるため、空でOK
      groups: []
    }
  },
  //mountedでVueインスタンスのDOM作成完了直後に読み込む
  mounted() {
    axios
      //GETリクエストでRailsで作成したjsonを取得する
      .get('/api/v1/groups.json')
      // .get('/api/v1/groups.json')
      //response.data は RailsのUser.select(:id, :name, :email)
      //これをdata()で定義したusersに代入する
      .then(response => (this.groups = response.data))
  }
}

</script>