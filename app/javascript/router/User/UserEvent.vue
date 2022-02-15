<template>
  <div>

  <!-- ここから 表示切り替えボタン -->
    <p>表示方法を選択</p>
    <v-btn-toggle v-model="list">
      <v-btn>
        <v-icon>mdi-format-align-justify</v-icon>
      </v-btn>
      <v-btn>
        <v-icon>mdi-calendar-text</v-icon>
      </v-btn>
    </v-btn-toggle>
  <!-- ここまで 表示切り替えボタン -->

  <!-- ここから ① 一覧表示 -->
    <div v-if="list==0">
      <v-card 
        v-for="API_event in API_events"
        :key="API_event.id"
        class="my-8"
      >
        <v-container>

        <router-link
          v-for="event_group in getEvnetGgroup(API_event.group_id)"
          :key="event_group.id"
          :to=" '/groups/' +(event_group.id) + '/events/' + (Number(API_event.id)) "
          active-class="link--active"
          exact
          class="link"
        >
          <v-row 
            justify="space-around"
            align="center"
          >

            <v-col cols=4>
                {{ API_event.date }}
            </v-col>

            <v-col cols=4>
                {{ event_group.name }}
            </v-col>

            <v-col cols=4>
              <v-card-title>
                {{ API_event.place }}
              </v-card-title>
            </v-col>

          </v-row>
        </router-link>

        </v-container>
      </v-card>
    </div>
  <!-- ここまで ① 一覧表示 -->

  <!-- ここから ② カレンダー表示 -->
    <Calender v-else :events="events" :answers="answers" @onChange="updateAnswer"></Calender>
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
      colors: ['green', 'orange', 'blue', 'indigo', 'deep-purple', 'cyan', 'grey darken-1'],
      events: [],
      list: 1,

      user_groups: [],
      user: {},
      API_events: [],
      answers: [],
    }
  },

  props: {
    val: {
      type: Boolean
    }
  },

  computed: {
    eventAnswer(){
        const data = this.answers;
        const result = data.filter(x => x.event_id === this.selectedEvent.id);
        return result[0];
    },
  },

  created () {
    this.getUser();
  },

  beforeUpdate(){
    this.pushEvent();
  },

  methods: {
    getUser() {
      axios
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => {
        this.user_groups = response.data.user_groups;
        this.user = response.data.user;
        this.API_events = response.data.join_events;
        this.answers = response.data.user_join_answers;
      });
    },
    pushEvent() {
      const events = []
      const eventCount = this.API_events.length
      const modifyDate = (new Date('2000-01-01')).getTime()
      const modifyTime = 9*3600*1000
      const group_ids = []

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

        if (!group_ids.includes(API_event.group_id)) {
          group_ids.push(API_event.group_id)
        }

        const color_num = group_ids.indexOf(API_event.group_id)

        events.push({
          name : API_event.place,
          start: start,
          end: end,
          color: this.colors[color_num],
          timed: true, //true で時間までcarenderに反映 (day,4 days, week のみ)
          id: API_event.id,
          group_id: API_event.group_id,
        })
      }
      this.events = events
    },

    getEvnetGgroup(key_id){
      const data = this.user_groups;
      const result = data.filter(x => x.id === key_id);
      return result;
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