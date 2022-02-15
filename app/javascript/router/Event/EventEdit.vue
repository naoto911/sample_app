<template>
  <div>
    <v-form
      ref="form"
      v-model="valid"
      lazy-validation
    >
      
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
      <v-text-field
        v-model="event.place"
        label="開催場所"
        required
      ></v-text-field>
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
        @click="UpdateEvent"
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
import axios from 'axios';

export default {
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

      time: null,
      menu1: false,
      menu2: false,
      menu3: false,
    }
  },
  
  created() {
    this.getEvent();
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
    getEvent() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/events/${this.$route.params.event_id}.json`)
        .then(response => {
          this.event = response.data.event;
          this.convetTime();
        });
    },

    convetTime() {
      const API_event =this.event
      const modifyDate = (new Date('2000-01-01')).getTime()
      const startTime = (new Date(API_event.starttime)).getTime()
      const endTime = (new Date(API_event.finishtime)).getTime()

      const start = (startTime - modifyDate)
      const end = (endTime - modifyDate)
    
      var start_MM = (start/1000) % 3600 //分
      var start_HH = ((start/1000) - start_MM) / 3600 //時間
      var end_MM = (end/1000) % 3600 //分
      var end_HH = ((end/1000) - end_MM) / 3600 //時間

      start_MM =  ( '00' + start_MM ).slice( -2 );
      end_MM =  ( '00' + start_MM ).slice( -2 );

      this.event.starttime =  String (start_HH + ":" + start_MM)
      this.event.finishtime = String (end_HH + ":" + end_MM)
    },

    UpdateEvent () {
      if (!this.event.place) return;

        axios
          .patch(`/api/v1/groups/${this.$route.params.id}/events/${this.$route.params.event_id}`, {
            event: {           
              date: this.event.date,   
              starttime: this.event.starttime,
              finishtime: this.event.finishtime,
              place: this.event.place,
              remarks: this.event.remarks
            }
          })

          .then(response => {
            console.log('OK');
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
  },

}
</script>