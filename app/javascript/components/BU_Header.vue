<!-- ②ここから 写真スライド -->
  <v-card>
    <v-window
      v-model="onboarding"
    >
      <v-window-item
        v-for="n in length"
        :key="`card-${n}`"
      >
        <v-card>
          <v-responsive :aspect-ratio="1/1">
            <v-img
              v-if="group.image"
              :src= "group.image.url"
            ></v-img>
          </v-responsive>
        </v-card>
      </v-window-item>
    </v-window>

    <v-card-actions class="justify-space-between">
      <v-btn
        text
        @click="prev"
      >
        <v-icon>mdi-chevron-left</v-icon>
      </v-btn>
      <v-item-group
        v-model="onboarding"
        class="text-center"
        mandatory
      >
        <v-item
          v-for="n in length"
          :key="`btn-${n}`"
          v-slot="{ active, toggle }"
        >
          <v-btn
            :input-value="active"
            icon
            @click="toggle"
          >
            <v-icon>mdi-record</v-icon>
          </v-btn>
        </v-item>
      </v-item-group>
      <v-btn
        text
        @click="next"
      >
        <v-icon>mdi-chevron-right</v-icon>
      </v-btn>
    </v-card-actions>

  </v-card>
  <!-- ②ここまで 写真スライド -->


<!-- ①-1 ここから 削除ボタン -->
<v-btn icon>
<!-- <v-btn @click="deleteUser(user.id)" icon> -->
  <v-icon>mdi-delete</v-icon>
</v-btn>
<!-- ①-1 ここまで 削除ボタン -->


<!-- ①-1 ここから 都道府県API -->
    getArea(){
      var area_url = 'https://opendata.resas-portal.go.jp/api/v1/prefectures';
      axios
      .get(area_url,{
        headers: { "X-API-KEY": "imTqHdr2MusisKwbx1V4J3wS3XrVmwEb26Uv83qB" },
      })
      .then(response =>  {
        this.area = response;
      });
    },
<!-- ①-1 ここまで 都道府県API -->