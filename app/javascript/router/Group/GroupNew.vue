<template>
  <div>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
    <!-- ①ここから header -->
      <v-row align="center">

      <!-- ここから ①-1 画像uploda -->
        <v-col cols="1">
          <label for="name1">
            <v-avatar
              size="60"
              color="grey"
            >
              <v-img
                v-if="group.image"
                :src= "url"
              ></v-img>
              <v-icon v-else>mdi-camera</v-icon>
            </v-avatar>
          </label>
          <v-file-input
            id="name1"
            v-model="group.image"
            accept="image/*"
            filled
            @change="cheangeImage()"
            style="display:none"    
          ></v-file-input>  
        </v-col>
      <!-- ここまで ①-1 画像uploda -->

      <!-- ①-2 ここから グループ名 -->
        <v-col cols="11">
          <v-text-field
            v-model="group.name"
            :counter="10"
            :rules="nameRules"
            label="名前"
            required
          ></v-text-field>
        </v-col>
      <!-- ①-2 ここまで グループ名 -->
      
      </v-row>
    <!-- ①ここまで header -->

    <v-row style="min-height: 48px;"></v-row>

    <v-card>
      <v-responsive :aspect-ratio="16/9">
        <v-row>
        <!-- ① ここから 紹介 -->
          <v-col cols="12">
            <v-card-text>

              <h3>頻度</h3>
                <v-radio-group
                  v-model="group.frequency"
                  row
                >
                  <v-radio
                    label="ガチ"
                    :value=1
                  ></v-radio>
                  <v-radio
                    label="時々"
                    :value=2
                  ></v-radio>
                  <v-radio
                    label="まれ"
                    :value=3
                  ></v-radio>
                </v-radio-group>

              <h3>場所</h3>
                <v-text-field
                  v-model="group.region"
                  label="練習場所"
                  prepend-inner-icon="mdi-map-marker"
                ></v-text-field>

              <h3>SNS</h3>
                <v-text-field
                  v-model="group.instagram"
                  label="instagramのURL"
                  prepend-inner-icon="mdi-instagram"
                ></v-text-field>

              <h3>説明</h3>
                <v-textarea
                  v-model="group.introduction"
                  background-color="white"
                  filled
                  label="グループ紹介"
                  auto-grow
                ></v-textarea>

            </v-card-text>
          </v-col>
        <!-- ① ここまで 紹介 -->

        <!-- ここから ①-2 ボタン類 -->
          <v-col cols="4">
            <v-card-actions>
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
            </v-card-actions>
          </v-col>
        <!-- ここまで ①-2 ボタン類 -->

        </v-row>
      </v-responsive>
    </v-card>
    </v-form>
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
        image: null,
        name: null,
        frequency: '2',
        region: null,
        instagram: null,
        introduction: null,

        url: null,
      },

      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      select: null,

      frequency: '2',
    }
  },

  // computed:{
  //   url(){
  //     if(this.group.image === null){return;}
  //     else{return URL.createObjectURL(this.group.image);}
  //   }
  // },

  created() {
    this.getGroup();
  },

  methods: {
    reset () {
      this.$refs.form.reset()
    },
    getGroup() {
      axios
        .get('/api/v1/groups/new.json')
        .then(response => {
        this.current_user = response.data.current_user;
      });
    },
    cheangeImage() {
      if (!this.group.image) return; //リセット時の画像未選択エラーを回避
      this.url = URL.createObjectURL(this.group.image);
      return this.url;
    },
    createGroup () {
      if (!this.group.name) return;
      const formData = new FormData()
      formData.append('group[image]', this.group.image)
      formData.append('group[name]', this.group.name)
      formData.append('group[frequency]', this.group.frequency)
      formData.append('group[region]', this.group.region)
      formData.append('group[instagram]', this.group.instagram)
      formData.append('group[introduction]', this.group.introduction)
      formData.append('group[adminuser_id]', this.current_user.id)

      axios
        .post('/api/v1/groups', formData)
        .then(response => {
          console.log('OK');
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