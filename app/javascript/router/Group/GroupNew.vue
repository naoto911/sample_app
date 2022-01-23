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