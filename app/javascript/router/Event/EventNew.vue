<template>
  <div>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >

    <!-- <v-row justify="space-around"> -->
      
    <v-row>
    <!-- ①-1 ここから日付 -->
      <v-col
        cols="12"
      >
        <v-menu
          v-model="menu1"
          :close-on-content-click="false"
          :nudge-right="40"
          transition="scale-transition"
          offset-y
          min-width="auto"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-text-field
              v-model="event.date"
              label="日付"
              prepend-icon="mdi-calendar"
              readonly
              v-bind="attrs"
              v-on="on"
            ></v-text-field>
          </template>
          <v-date-picker
            v-model="event.date"
            @input="menu1 = false"
          ></v-date-picker>
        </v-menu>
      </v-col>
    <!-- ①-1 ここまで日付 -->

    <!-- ①-2 ここから開始時間 -->
      <v-col
        cols="11"
        sm="5"
      >
        <v-menu
          ref="menu"
          v-model="menu2"
          :close-on-content-click="false"
          :nudge-right="40"
          :return-value.sync="time"
          transition="scale-transition"
          offset-y
          max-width="290px"
          min-width="290px"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-text-field
              v-model="event.starttime"
              label="開始時刻"
              prepend-icon="mdi-clock-time-four-outline"
              readonly
              v-bind="attrs"
              v-on="on"
            ></v-text-field>
          </template>
          <v-time-picker
            v-if="menu2"
            v-model="event.starttime"
            full-width
            @click:minute="$refs.menu.save(time)"
          ></v-time-picker>
        </v-menu>
      </v-col>
    <!-- ①-2 ここまで開始時間 -->
      <v-spacer></v-spacer>
    <!-- ①-3 ここから終了時間 -->
      <v-col
        cols="11"
        sm="5"
      >
        <v-menu
          ref="menu"
          v-model="menu3"
          :close-on-content-click="false"
          :nudge-right="40"
          :return-value.sync="time"
          transition="scale-transition"
          offset-y
          max-width="290px"
          min-width="290px"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-text-field
              v-model="event.finishtime"
              label="終了時刻"
              prepend-icon="mdi-clock-time-four-outline"
              readonly
              v-bind="attrs"
              v-on="on"
            ></v-text-field>
          </template>
          <v-time-picker
            v-if="menu3"
            v-model="event.finishtime"
            full-width
            @click:minute="$refs.menu.save(time)"
          ></v-time-picker>
        </v-menu>
      </v-col>
    <!-- ①-3 ここまで終了時間 -->
    </v-row>

    <!-- ①-4 ここから開催場所 -->
      <h3>開催場所</h3>
        <v-text-field
          v-model="event.place"
          label="開催場所"
          required
        ></v-text-field>
        <p v-if="!event.lat && !event.lng" >場所が未登録です。</p>
        <GoogleMap :parent_object="event" @latlng="changeMarker"></GoogleMap>

    <!-- ①-4 ここまで開催場所 -->

    <!-- ①-5 ここから備考 -->
      <v-text-field
        v-model="event.remarks"
        label="備考"
        required
      ></v-text-field>
    <!-- ①-5 ここまで備考 -->

    <!-- ② ここからボタン -->
      <v-btn
        color="primary"
        class="mr-4"
        dark
        @click="createEvent"
      >
        Create
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
    <!-- ② ここまでボタン -->

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
      event: {
        date: '',
        starttime: '',
        finishtime: '',
        place: '',
        remarks: '',
      },
      date: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
      time: null,
      menu1: false,
      menu2: false,
      menu3: false,
    }
  },

  methods: {
    validate () {
      this.$refs.form.validate()
    },
    reset () {
      this.$refs.form.reset()
    },
    resetValidation () {
      this.$refs.form.resetValidation()
    },
    createEvent () {
      if (!this.event.place) return;
        axios
          .post(`/api/v1/groups/${this.$route.params.id}/events`, {
            event: {           
              date: this.event.date,   
              // starttime: this.event.starttime,
              starttime: this.event.date + "T" +this.event.starttime,
              // finishtime: this.event.finishtime,
              finishtime: `${this.event.date}T${this.event.finishtime}`,
              place: this.event.place,
              lat: this.event.lat,
              lng: this.event.lng,
              remarks: this.event.remarks
            }
          })
        .then(response => {
          console.log('OK');
          console.log(this.user);
          this.$router.push({ path: `/groups/${this.$route.params.id}/events` });
        })        
        .catch(error => {
          console.log('NG');
          console.error(error);
          if(error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        })
    },
    changeMarker(latlng) {
      this.event.lat = latlng.lat;
      this.event.lng = latlng.lng;
    },
  },

}
</script>