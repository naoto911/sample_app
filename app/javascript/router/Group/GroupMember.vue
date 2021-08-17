<template>
  <div>

        <v-card>
          <v-card-title class="orange white--text text-h5">
            Group Members
          </v-card-title>
          <v-row
            class="pa-4"
            justify="space-between"
          >
          <!-- ③ここから左のユーザー一覧                 :load-children="fetchUsers"-->
            <v-col cols="5">
              <v-treeview
                :active.sync="active"
                :items="users"
                :open.sync="open"
                activatable
                color="warning"
                open-on-click
                transition
              >

              <!-- ④ここからitemにアカウントアイコンを追加 -->
                <template v-slot:prepend="{ item }">
                  <!-- <v-icon v-if="!item.children">
                    mdi-account
                  </v-icon> -->
                  <v-layout justify-center>
                    <v-avatar>
                    <!-- <v-avatar size="50"> -->
                      <!-- <v-icon v-if="!item.children">
                        mdi-account
                      </v-icon> -->
                      <v-img
                        v-if="item.image"
                        :src= "item.image.url"
                        class="mb-6"
                      ></v-img>
                      <v-icon v-else>mdi-account</v-icon>
                    </v-avatar>
                  </v-layout>
                </template>
              <!-- ④ここまでitemにアカウントアイコンを追加 -->

              </v-treeview>
            </v-col>
          <!-- ③ここまで左のユーザー一覧 -->

            <v-divider vertical></v-divider>

            <v-col
              class="d-flex text-center"
            >
              <v-scroll-y-transition mode="out-in">
              <!-- ①ここから誰も選んでないときの表示 -->
                <div
                  v-if="!selected"
                  class="text-h6 grey--text text--lighten-1 font-weight-light"
                  style="align-self: center;"
                >
                  Select a User
                </div>
              <!-- ①ここまで誰も選んでないときの表示 -->

              <!-- ⑤ここから右側の表示 -->
                <v-card
                  v-else
                  :key="selected.id"
                  class="pt-6 mx-auto"
                  flat
                  max-width="400"
                >
                  <v-card-text>
                    <v-avatar
                      v-if="selected.image"
                      size="88"
                    >
                      <v-img
                        :src= "selected.image.url"
                        class="mb-6"
                      ></v-img>
                    </v-avatar>
                    <h3 class="text-h5 mb-2">
                      {{ selected.name }}
                    </h3>
                    <!-- <div class="blue--text mb-2">
                      {{ selected.email }}

                      //src="/uploads/user/image/3/FH000027.JPG"

                    </div>
                    <div class="blue--text subheading font-weight-bold">
                      {{ selected.username }}
                    </div> -->
                  </v-card-text>
                  <v-divider></v-divider>
                <!-- ②ここからユーザー情報 -->
                  <v-row
                    class="text-left"
                    tag="v-card-text"
                  >
                    <v-col
                      class="text-right mr-4 mb-2"
                      tag="strong"
                      cols="5"
                    >
                      Age:
                    </v-col>
                    <v-col>{{ selected.name }}</v-col>
                    <v-col
                      class="text-right mr-4 mb-2"
                      tag="strong"
                      cols="5"
                    >
                      From:
                    </v-col>
                    <v-col>
                      <a
                        :href="`//${selected.id}`"
                        target="_blank"
                      >{{ selected.id }}</a>
                    </v-col>
                    <!-- <v-col
                      class="text-right mr-4 mb-2"
                      tag="strong"
                      cols="5"
                    >
                      Phone:
                    </v-col>
                    <v-col>{{ selected.phone }}</v-col> -->
                  </v-row>
                <!-- ②ここまでユーザー情報 -->
                </v-card>
              <!-- ⑤ここまで右側の表示 -->
              </v-scroll-y-transition>
            </v-col>
          </v-row>
        </v-card>
        
  </div>
</template>

<script>
import axios from 'axios';

  // const avatars = [
  //   '?accessoriesType=Blank&avatarStyle=Circle&clotheColor=PastelGreen&clotheType=ShirtScoopNeck&eyeType=Wink&eyebrowType=UnibrowNatural&facialHairColor=Black&facialHairType=MoustacheMagnum&hairColor=Platinum&mouthType=Concerned&skinColor=Tanned&topType=Turban',
  //   '?accessoriesType=Sunglasses&avatarStyle=Circle&clotheColor=Gray02&clotheType=ShirtScoopNeck&eyeType=EyeRoll&eyebrowType=RaisedExcited&facialHairColor=Red&facialHairType=BeardMagestic&hairColor=Red&hatColor=White&mouthType=Twinkle&skinColor=DarkBrown&topType=LongHairBun',
  //   '?accessoriesType=Prescription02&avatarStyle=Circle&clotheColor=Black&clotheType=ShirtVNeck&eyeType=Surprised&eyebrowType=Angry&facialHairColor=Blonde&facialHairType=Blank&hairColor=Blonde&hatColor=PastelOrange&mouthType=Smile&skinColor=Black&topType=LongHairNotTooLong',
  //   '?accessoriesType=Round&avatarStyle=Circle&clotheColor=PastelOrange&clotheType=Overall&eyeType=Close&eyebrowType=AngryNatural&facialHairColor=Blonde&facialHairType=Blank&graphicType=Pizza&hairColor=Black&hatColor=PastelBlue&mouthType=Serious&skinColor=Light&topType=LongHairBigHair',
  //   '?accessoriesType=Kurt&avatarStyle=Circle&clotheColor=Gray01&clotheType=BlazerShirt&eyeType=Surprised&eyebrowType=Default&facialHairColor=Red&facialHairType=Blank&graphicType=Selena&hairColor=Red&hatColor=Blue02&mouthType=Twinkle&skinColor=Pale&topType=LongHairCurly',
  // ]

  // const pause = ms => new Promise(resolve => setTimeout(resolve, ms))

  export default {
    data: () => ({
      active: [],
      // avatar: null,
      open: [],
      users: [],

      members: [],

    }),

    computed: {
      items () {
        return [
          {
            name: 'Users',
            children: this.users,
          },
        ]
      },
      selected () {
        //active = 左のユーザーから誰かを選択したらその人がactive
        if (!this.active.length) return undefined //非activeだとselectedはundefined
      
        const id = this.active[0]

        return this.users.find(user => user.id === id) //usersからuser.idがidと等しいuserを探す
      },
    },

    // watch: {
    // // selectedが変更されたらrandomAvatorを実行する
    // //左の一覧からユーザーを選択するたびに,avatarをランダムに定義する
    // //同じユーザーでもn回目の選択ごとにavatar = アイコンが更新される 
    //   selected: 'randomAvatar',
    // },

    mounted() {
      this.getUsers();
    },

    methods: {
      

      // async fetchUsers (item) {
      //   //非同期でユーザー一覧を取得してくる処理
      //   //バックエンドのAPIを自分で作っているので

      //   // Remove in 6 months and say
      //   // you've made optimizations! :)
      //   await pause(1500)

      //   return fetch('https://jsonplaceholder.typicode.com/users')
      //     .then(res => res.json())
      //     .then(json => (item.children.push(...json)))
      //     .catch(err => console.warn(err))
      // },

      //アバター画像をAPIからランダムに取得するためのコード
      // randomAvatar () {
      //   this.avatar = avatars[Math.floor(Math.random() * avatars.length)]
      // },

      getUsers() {
        axios
          .get(`/api/v1/groups/${this.$route.params.id}.json`)
          .then(response => {
            // this.group = response.data.group;
            // this.members = response.data.users;
            this.users = response.data.users;
          });
      },
    },

  }
</script>