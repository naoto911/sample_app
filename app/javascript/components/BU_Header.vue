
    <!-- ② ここから 申請中のデータ -->
    <v-row justify="space-between">
      <p>承認依頼</p>
      <v-col>
        <div
          v-if="approvals.length == 0"
          class="text-h6 text--lighten-1 font-weight-light"
          style="align-self: center;"
        >
          You Don`t have any approvals
        </div>
      <!-- ここから -->
        <v-card
          v-else
          v-for="approval in approvals"
          :key="approval.id"
          class="mx-auto"
        >
          <v-card-title>
            {{ approval.content }}
          </v-card-title>

          <!-- ①-1 ここから 削除ボタン -->
            <v-btn @click="deleteApplication(approval.id)" icon>
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          <!-- ①-1 ここまで 削除ボタン -->

          <!-- ①-2 ここから 申請Editへのリンク -->
            <router-link
              :to=" '/groups/' + (Number(approval.group_id)) + '/joins/' + (Number(approval.id)) +'/edit'"
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
    </v-row>
    <!-- ② ここまで 申請中のデータ -->