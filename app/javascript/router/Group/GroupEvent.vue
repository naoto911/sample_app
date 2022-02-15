<template>
  <div>
 
   <!-- ① ここからイベント作成ボタン -->
      <v-row>
        <v-col v-if="val" cols="12">    
          <router-link 
            :to=" '/groups/' + (Number(this.$route.params.id)) +'/events/new' "
            active-class="link--active"
            exact
            class="link"
          >
            <v-btn
              depressed
              rounded
              text
            >
              event作成
            </v-btn>
          </router-link>
        </v-col>
      </v-row>
    <!-- ① ここまでイベント作成ボタン -->

    <!-- ここから ② カレンダー表示 -->
      <Calender :events="events" :answers="answers" @onChange="updateAnswer"></Calender>
    <!-- ここまで ② カレンダー表示 -->
  
  </div>
</template>

<script>
import Calender from '../../components/Calender.vue';
import axios from 'axios';

export default {

  components: { 
    Calender,
  },

  data() {
    return {
      events: [],

      API_events: [],
      answers: [],
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  created () {
    this.getEvent();
  },

  beforeUpdate(){
    this.pushEvent();
  },

  methods: {
    getEvent() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/events.json`)
        .then(response => {
          this.API_events = response.data.events;
          this.answers = response.data.answers;
        });
    },
    pushEvent() {
      const events = []
      const eventCount = this.API_events.length
      const modifyDate = (new Date('2000-01-01')).getTime()
      const modifyTime = 9*3600*1000

      for (let i = 0; i < eventCount; i++) {
        const API_event =this.API_events[i]
        const dateTime = (new Date(API_event.date)).getTime()
        const startTime = (new Date(API_event.starttime)).getTime()
        const endTime = (new Date(API_event.finishtime)).getTime()

        // 以下は全てmsec
        // dateTime = 1970/01/01 ~ イベント日付
        // startTime,endTime = 2000-01-01 イベント開/終 時間
        // modfiDate = 1970 1/1 ~ 2000 1/1
        // modifyTime = UTC→JST 換算を無効化させるための定数
        const start = new Date((dateTime +  ( startTime - modifyDate) ) - modifyTime)
        const end = new Date(( dateTime +  ( endTime - modifyDate) )- modifyTime)

        events.push({
          name : API_event.place,
          start: start,
          end: end,
          color: "green",
          timed: true, //true で時間までcarenderに反映 (day,4 days, week のみ)
          id: API_event.id,
          group_id: API_event.group_id,
        })
      }
      this.events = events
    },

    updateAnswer(updateAnswer) {
        axios
          .patch(`/api/v1/answers/${updateAnswer.id}`, {
            answer: {           
              answer: updateAnswer.answer
            }
          })

        .then(response => {
          console.log('OK');
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