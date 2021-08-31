    <v-row justify="space-between">
    <!-- ① ここから 申請中のデータ -->
      <p>申請中</p>
      <v-col>
        <div
          v-if="applications.length == 0"
          class="text-h6 grey--text text--lighten-1 font-weight-light"
          style="align-self: center;"
        >
          You Don`t have any applications
        </div>
      <!-- ここから -->
        <v-card
          v-else
          v-for="application in applications"
          :key="application.id"
          class="mx-auto"
        >
          <v-card-title>
            {{ application.content }}
          </v-card-title>

          <!-- ①-1 ここから 削除ボタン -->
            <v-btn @click="deleteApplication(application.id)" icon>
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          <!-- ①-1 ここまで 削除ボタン -->

          <!-- ①-2 ここから 申請Editへのリンク -->
            <router-link
              :to=" '/groups/' + (Number(application.group_id)) + '/joins/' + (Number(application.id)) +'/edit'"
              active-class="link--active"
              exact
              class="link"
            >
              <v-btn icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </router-link>
          <!-- ①-2 ここまで 申請Editへのリンク -->

        </v-card>
      <!-- ここまで -->
      </v-col>
    <!-- ① ここまで 申請中のデータ -->
    </v-row>