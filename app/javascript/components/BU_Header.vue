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


<!-- ①-1 ここから GroupNewのバックアップ -->
<template>
  <div>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <v-text-field
        v-model="group.name"
        :counter="10"
        :rules="nameRules"
        label="名前"
        required
      ></v-text-field>
      
      <v-text-field
        label="練習場所"
        prepend-inner-icon="mdi-map-marker"
      ></v-text-field>

      <v-textarea
        v-model="group.introduction"
        background-color="white"
        filled
        label="グループ紹介"
        auto-grow
      ></v-textarea>

      <!-- ここから ①-1 画像uploda -->

      <v-file-input
        v-model="group.image"
        accept="image/*"
        label="File input"
        filled
        prepend-icon="mdi-camera"
      ></v-file-input>

      <v-responsive :aspect-ratio="1/1" max-width="50%">
        <v-img
          v-if="group.image"
          :src= "url"

        ></v-img>
      </v-responsive>

      <!-- ここまで ①-1 画像uploda -->

      <v-text-field
        label="instagramのURL"
        prepend-inner-icon="mdi-instagram"
      ></v-text-field>

      <!-- ここから ①- 頻度選択 -->
          <v-radio-group
            v-model="frequency"
            row
          >
            <v-radio
              label="ガチ"
              value="1"
            ></v-radio>
            <v-radio
              label="時々"
              value="2"
            ></v-radio>
            <v-radio
              label="まれ"
              value="3"
            ></v-radio>
          </v-radio-group>
      <!-- ここまで ①- 頻度選択 -->

      <!-- ここから ①-2 ボタン類 -->
      <v-row class="my-4">

        <v-btn
          color="primary"
          class="mr-4"
          dark
          @click="createGroup"
        >
          作成
          <v-icon
            dark
            right
          >
            mdi-checkbox-marked-circle
          </v-icon>
        </v-btn>

        <v-btn
          color="error"
          class="mr-4"
          @click="reset"
        >
          リセット
        </v-btn>

      </v-row>
      <!-- ここまで ①-2 ボタン類 -->

    </v-form>

  <!-- ①ここから プレビュー -->
    <!-- <v-row align="center">

      <v-col cols="1">
        <v-avatar
          size="60"
        >
          <v-img
            v-if="url"
            :src="url">
          ></v-img>
          <v-icon v-else>{{ "画" }}</v-icon>
        </v-avatar>
      </v-col>

      <v-col cols="10">
        <h2>{{ group.name }}</h2>
      </v-col>

      <v-col cols="1"></v-col>

    </v-row> -->
  <!-- ①ここまで プレビュー -->

  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      valid: true,
      current_user: {},
      group: {
        name: '',
        // adminuser_id: '',
        introduction: '',
        image: ''
      },
      // image: '',
      // uploadedImage: '',
      // name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      select: null,
      // url: null,
      frequency: '2',
    }
  },

  computed:{
    url(){
      if(this.group.image===''){return;}
      else{return URL.createObjectURL(this.group.image);}
    }
  },

  created() {
    this.getGroup();
  },

  methods: {
    // uploadImage(){
    //   this.url = URL.createObjectURL(this.$refs.image.files[0]);
    // },
    // validate () {
    //   this.$refs.form.validate()
    // },
    reset () {
      this.$refs.form.reset()
    },
    // resetValidation () {
    //   this.$refs.form.resetValidation()
    // },
    // setImage (e) {
    // this.image = e.target.files[0]
    // },
    getGroup() {
      axios
        .get('/api/v1/groups/new.json')
        .then(response => {
        this.current_user = response.data.current_user;
      });
    },
    createGroup () {
      if (!this.group.name) return;
      const formData = new FormData()
      formData.append('group[name]', this.group.name)
      formData.append('group[adminuser_id]', this.current_user.id)
      formData.append('group[introduction]', this.group.introduction)
      formData.append('group[image]', this.group.image)

      axios
        .post('/api/v1/groups', formData)
        .then(response => {
          console.log('OK');
          console.log(this.group);
          this.$router.push({ path: '/' });
        })        
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    } 
  },

}
</script>

<!-- ①-1 ここまで GroupNewのバックアップ -->

  <!-- ①ここから ボタン類 -->
    <v-row>
      <v-col></v-col>
      <v-spacer></v-spacer>
      <v-col class="text-right">
        
        <!-- ①-1 ここから 削除ボタン -->
            <v-btn 
              icon 
              @click="openModal(event.id)"
            >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        <!-- ①-1 ここまで 削除ボタン -->

        <!-- ②-2 ここから UserEditへのリンク -->
          <router-link
            :to=" $route.path + '/edit' "
            active-class="link--active"
            exact
            class="link"
          >
            <v-btn icon>
              <v-icon>mdi-pencil</v-icon>
            </v-btn>
          </router-link>
        <!-- ②-2 ここまで UserEditへのリンク -->

      </v-col>
    </v-row>
  <!-- ①ここまで ボタン類 -->