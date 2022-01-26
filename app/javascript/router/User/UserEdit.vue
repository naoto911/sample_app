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
                v-if="url"
                :src= "url"
              >
              </v-img>
              <v-img
                v-else-if="user.image && user.image.url"
                :src= "user.image.url"
              ></v-img>
              <v-icon v-else>mdi-camera</v-icon>
            </v-avatar>
          </label>
          <v-file-input
            id="name1"
            v-model="user.image"
            accept="image/*"
            filled
            @change="cheangeImage()"
            style="display:none"    
          ></v-file-input>  
        </v-col>
      <!-- ここまで ①-1 画像uploda -->

      <!-- ①-2 ここから グループ名 -->
        <v-col cols="10">
          <h2>{{ user.name }}</h2>
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

              <h3>年齢</h3>
                <v-text-field
                  v-model="user.age"
                  label="年齢"
                ></v-text-field>

<!-- <p v-if="user.sex">{{ user.sex == user1.sex }}</p> -->
              <h3>性別</h3>
                <v-radio-group
                  v-model="user.sex"
                  row
                >
                  <v-radio
                    label="男性"
                    :value=1
                  ></v-radio>
                  <v-radio
                    label="女性"
                    :value=2
                  ></v-radio>
                </v-radio-group>

              <h3>出身</h3>
                <v-text-field
                  v-model="user.birthplace"
                  label="出身"
                  prepend-inner-icon="mdi-map-marker"
                ></v-text-field>

              <h3>自己紹介</h3>
                <v-textarea
                  v-model="user.introduction"
                  background-color="white"
                  filled
                  label="自己紹介"
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
                  @click="UpdateUser"
                >
                  更新
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
      user: {},

      // user1: { sex: "1"},
      url: null,
    }
  },

  created() {
    this.getUser();
  },

  methods: {
    // validate () {
    //   this.$refs.form.validate()
    // },
    // resetValidation () {
    //   this.$refs.form.resetValidation()
    // },
    reset () {
      this.$refs.form.reset()
    },
    setImage (e) {
    this.image = e.target.files[0]
    },
    getUser() {
      axios
        .get(`/api/v1/users/${this.$route.params.id}/edit.json`)
        .then(response => {
        this.user = response.data.user;
      });
    },
    cheangeImage() {
      if (!this.user.image) return; //リセット時の画像未選択エラーを回避
      this.url = URL.createObjectURL(this.user.image);
      return this.url;
    },
    UpdateUser () {
      if (!this.user.name) return;

        const formData = new FormData()
        if (this.url || !this.user.image) {
          formData.append('user[image]', this.user.image)
        }
        formData.append('user[name]', this.user.name)
        formData.append('user[age]', this.user.age)
        formData.append('user[sex]', this.user.sex)
        formData.append('user[birthplace]', this.user.birthplace)
        formData.append('user[introduction]', this.user.introduction)

      axios
        .patch(`/api/v1/users/${this.$route.params.id}`, formData)
        .then(response => {
          console.log('OK');
          console.log(this.$route.params.id)
          this.$router.push({ path: `/users/${this.$route.params.id}/profile` });
        })    

      // axios
      //   .patch(`/api/v1/users/${this.$route.params.id}`, {
      //     user: {  name: this.user.name,
      //               email: this.user.email,
      //             }
      //   })
        // .then(response => {
        //   console.log('OK');
        //   this.$router.push({ path: '/' });
        // })        
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

    <!-- <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      <v-text-field
        v-model="user.name"
        :counter="10"
        label="Name"
        required
      ></v-text-field>

      <v-text-field
        v-model="user.email"
        :counter="10"
        label="Email"
        required
      ></v-text-field>
      
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="UpdateEdit"
      >
        Update
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
        Reset Form
      </v-btn>

    </v-form> -->
 