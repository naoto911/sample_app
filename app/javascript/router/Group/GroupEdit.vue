<template>
  <div>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
    <v-card>
      <v-card-text class="d-flex flex-row">
        <label for="name1">
          <v-avatar size="60" color="grey">
            <v-img 
              v-if="url"
              :src= "url"
            >
            </v-img>
            <v-img
              v-else-if="group.image && group.image.url"
              :src= "group.image.url"
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

        <v-text-field
          v-model="group.name"
          :counter="10"
          :rules="nameRules"
          label="名前"
          required
          filled
          height=60px
          class="my-0 pt-0 ml-4"
        ></v-text-field>
      </v-card-text>

      <v-card-text>
        <v-textarea
          v-model="group.introduction"
          :rules="introductionRules"
          filled
          label="グループ紹介"
          auto-grow
          clearable
        ></v-textarea>
      </v-card-text>  

      <v-card-text>        
        <v-text-field
          v-model="group.twitter"
          label="twitterのURL"
          prepend-inner-icon="mdi-twitter"
          filled
        ></v-text-field>
        <v-text-field
          v-model="group.instagram"
          label="instagramのURL"
          prepend-inner-icon="mdi-instagram"
          filled
        ></v-text-field>
       </v-card-text>  

        <v-card-text>
          <div><strong>頻度</strong></div>
          <v-radio-group v-model="group.frequency" row>
            <v-radio
              v-for="(freq, index) in freqs"
              :key="index"
              :label="freq"
              :value="index+1"
            >
            </v-radio>
          </v-radio-group>
        </v-card-text>  

        <!-- <v-card-text> -->
          <!-- <v-text-field
            v-model="group.region"
            label="練習場所"
            prepend-inner-icon="mdi-map-marker"
            filled
          ></v-text-field> -->
          <GoogleMap :parent_object="group" @latlng="changeMarker"></GoogleMap>
        <!-- </v-card-text> -->

        <!-- ここから ボタン類 -->
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            :disabled="!valid"
            color="primary"
            class="mr-4"
            @click="updateGroup"
          >
            更新
            <v-icon dark right>
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
        <!-- ここまで ボタン類 -->

      </v-card>
    </v-form>
  </div>
</template>

<script>
import GoogleMap from '../../components/GoogleMap.vue'
import axios from 'axios';

export default {

  components: { 
    GoogleMap,
  },

  data() {
    return {
      valid: true,
      current_user: {},
      group: {},

      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      introductionRules: [
        v => !!v || 'Introduction is required',
      ],

      url: null,
      freqs:["ガチ", "時々", "まれ"],
    }
  },

  created() {
    this.getGroup();
  },

  methods: {
    validate () {
      return this.$refs.form.validate()
    },
    reset () {
      this.url = null
      this.$refs.form.reset()
    },
    getGroup() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/edit.json`)
        .then(response => {
        this.group = response.data.group;
        const redirect = response.data.redirect;
        if (redirect) {
          console.log("管理者以外はrootに返す")
          this.$router.push({ path: '/groups' });;
        }
      });
    },
    cheangeImage() {
      if (!this.group.image) return; //リセット時の画像未選択エラーを回避
      this.url = URL.createObjectURL(this.group.image);
      return this.url;
    },
    updateGroup () {
      if (!this.validate()) return;
      // if (!this.group.name) return;

        const formData = new FormData()
        if (this.url || !this.group.image) {
          formData.append('group[image]', this.group.image)
        }
        formData.append('group[name]', this.group.name)
        formData.append('group[frequency]', this.group.frequency)
        formData.append('group[lat]', this.group.lat)
        formData.append('group[lng]', this.group.lng)
        formData.append('group[instagram]', this.group.instagram)
        formData.append('group[introduction]', this.group.introduction)

      axios
        .patch(`/api/v1/groups/${this.$route.params.id}`, formData)
        .then(response => {
          console.log('OK');
          this.$router.push({ path: '/groups' });
        })    

        // .patch(`/api/v1/groups/${this.$route.params.id}`, {
        //   group: { 
        //     image: this.group.image,
        //     name: this.group.name,
        //     frequency: this.group.frequency,
        //     region: this.group.region,
        //     instagram: this.group.instagram,
        //     introduction: this.group.introduction,
        //     // adminuser_id: this.group.adminuser_id.id, 
        //   }
        // })
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
    },
    changeMarker(latlng) {
      console.log('mapの座標が届いた')
      this.group.lat = latlng.lat;
      this.group.lng = latlng.lng;
      console.log(latlng.address)
    },
  },

}
</script>