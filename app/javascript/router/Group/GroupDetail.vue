<template>
  <div>
    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>

        <!-- ① ここから 紹介 -->
          <v-col cols="10">
            <v-card-text>
              <h3>説明</h3>
              <p>
                {{group.introduction}}
              </p>
              <h3>頻度</h3>
              <p>
                頻度をプルダウンで選択
              </p>
              <h3>場所</h3>
              <p>
                場所をリンク
              </p>
              <h3>SNS</h3>
              <p>
                instagram等のリンク
              </p>
            </v-card-text>
          </v-col>
        <!-- ① ここまで 紹介 -->

        <!-- ② ここから ボタン類 -->
          <v-col v-if="val" class="text-right" cols="2">

            <!-- ②-1 ここから 削除ボタン -->
              <v-dialog
                v-model="dialog"
                width="500"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-btn 
                    icon 
                    v-bind="attrs"
                    v-on="on"
                  >
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </template>

                <v-card>
                  <v-card-title class="text-h5 grey lighten-2">
                    削除します。よろしいですか？
                  </v-card-title>

                  <v-card-text>
                    この操作は取り消せません。
                  </v-card-text>

                  <v-divider></v-divider>

                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      color="primary"
                      text
                      @click="dialog = false"
                    >
                      キャンセル
                    </v-btn>
                    <v-btn
                      color="error"
                      text
                      @click="deleteGroup(group.id)"
                    >
                      削除
                    </v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            <!-- ②-1 ここまで 削除ボタン -->

            <!-- ②-2 ここから 編集ボタン -->
              <router-link
                :to=" '/groups/' + (Number(group.id)) + '/edit'"
                active-class="link--active"
                exact
                class="link"
              >
                <v-btn icon>
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </router-link>
            <!-- ②-2 ここまで 編集ボタン -->

          </v-col>
        <!-- ② ここまで ボタン類 -->

        </v-row>
      </v-responsive>
    </v-card>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      length: 3,
      onboarding: 0,
      dialog: false,

      group: [],
      users: [],
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  created() {
    this.getGroup();
  },

  methods: {
    next () {
      this.onboarding = this.onboarding + 1 === this.length
        ? 0
        : this.onboarding + 1
    },
    prev () {
      this.onboarding = this.onboarding - 1 < 0
        ? this.length - 1
        : this.onboarding - 1
    },
    getGroup() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}.json`)
        .then(response => {
          this.group = response.data.group;
          this.users = response.data.users;
        });
    },
    deleteGroup(id) {
      axios.delete(`/api/v1/groups/${id}`)
        .then(res => {
          this.$router.push({ path: '/' });
        })
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
  },

}
</script>