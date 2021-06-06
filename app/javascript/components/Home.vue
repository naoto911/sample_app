<template>
<v-app>
  <!-- <div> -->
          <Header></Header>
          <!-- ここから -->
          <GroupsCard :val="group" :vals="groups"></GroupsCard>
          <!-- ここまで -->
  <!-- </div> -->
</v-app>
</template>

<script>
// axiosを読み込む
import axios from 'axios';
import Header from './Header.vue';
import GroupsCard from './GroupsCard.vue';

export default {
  components: { 
    Header,
    GroupsCard 
  },
  data() {
    return {
      //axiosで取得するデータを入れるため、空でOK
      groups: [],
      group: null
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

<style scoped>
head {
  color: white;
}
</style>