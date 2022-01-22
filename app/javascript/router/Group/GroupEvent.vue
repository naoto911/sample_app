<template>
  <div>
 
    <v-row>
      <v-col v-if="val" cols="12">
      <!-- ① ここからイベント作成ボタン -->
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
      <!-- ① ここまでイベント作成ボタン -->
      </v-col>
    </v-row>

  <!-- ここからイベント一覧 (最終的に削除 *Calendarの中に配置する) -->
    <!-- <v-row>
      <v-col
        v-for="val in events2"
        :key="val.id"
        cols="4"
      >
        <router-link
          :to=" $route.path + '/' + (Number(val.id)) "
          active-class="link--active"
          exact
          class="link"
        >
          <v-hover 
            v-slot="{ hover }"
            close-delay="200"
          >
            <v-card
              :elevation="hover ? 16 : 2"
              :class="{ 'on-hover': hover }"
              class="mx-auto"
              max-width="344"
            >
              <v-card-title>
                {{ val.date }}
              </v-card-title>

              <v-card-subtitle>
                {{ val.starttime }} ~ {{ val.finishtime}}
              </v-card-subtitle>

              <v-card-subtitle>
                {{ val.place }}
              </v-card-subtitle>

            </v-card>
          </v-hover>
        </router-link>
      </v-col>
    </v-row> -->
  <!-- ここまでイベント一覧 (最終的に削除 *Calendarの中に配置する) -->

    <v-row class="fill-height">
      <v-col>
        <v-sheet height="64">
          <v-toolbar
            flat
          >
            <v-btn
              outlined
              class="mr-4"
              color="grey darken-2"
              @click="setToday"
            >
              Today
            </v-btn>
            <v-btn
              fab
              text
              small
              color="grey darken-2"
              @click="prev"
            >
              <v-icon small>
                mdi-chevron-left
              </v-icon>
            </v-btn>
            <v-btn
              fab
              text
              small
              color="grey darken-2"
              @click="next"
            >
              <v-icon small>
                mdi-chevron-right
              </v-icon>
            </v-btn>
            <v-toolbar-title v-if="$refs.calendar">
              {{ $refs.calendar.title }}
            </v-toolbar-title>
            <v-spacer></v-spacer>
          <!-- ② ここからカレンダー期間を変更 -->
            <v-menu
              bottom
              right
            >
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  outlined
                  color="grey darken-2"
                  v-bind="attrs"
                  v-on="on"
                >
                  <span>{{ typeToLabel[type] }}</span>
                  <v-icon right>
                    mdi-menu-down
                  </v-icon>
                </v-btn>
              </template>
              <v-list>
                <v-list-item @click="type = 'day'">
                  <v-list-item-title>Day</v-list-item-title>
                </v-list-item>
                <v-list-item @click="type = 'week'">
                  <v-list-item-title>Week</v-list-item-title>
                </v-list-item>
                <v-list-item @click="type = 'month'">
                  <v-list-item-title>Month</v-list-item-title>
                </v-list-item>
                <v-list-item @click="type = '4day'">
                  <v-list-item-title>4 days</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          <!-- ② ここまでカレンダー期間を変更 -->
          </v-toolbar>
        </v-sheet>
        <v-sheet height="600">
        <!-- ③ここからカレンダーのメインの部分 -->
          <v-calendar
            ref="calendar"
            v-model="focus"
            color="primary"
            :events="events"
            :event-color="getEventColor"
            :type="type"
            @click:event="showEvent"
            @click:more="viewDay"
            @click:date="viewDay"
            
          ></v-calendar>
        <!-- ③ここまでカレンダーのメインの部分 @change="updateRange" -->

        <!-- ④ここからイベントを触ると編集へのリンクが出せる -->
          <v-menu
            v-model="selectedOpen"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card
              color="grey lighten-4"
              min-width="350px"
              flat
            >
              <v-toolbar
                :color="selectedEvent.color"
                dark
              >

              <!-- ④-1 ここから EvnetEditへのリンク -->
                <router-link
                  :to=" $route.path + '/' + (Number(selectedEvent.id)) + '/edit'"
                  active-class="link--active"
                  exact
                  class="link"
                >
                  <v-btn icon>
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                </router-link>
              <!-- ④-1 ここまで EvnetEditへのリンク -->

                <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
                <v-spacer></v-spacer>
                <v-btn icon>
                  <v-icon>mdi-heart</v-icon>
                </v-btn>

              <!-- ④-2 ここから EvnetDetaileへのリンク -->
                <router-link
                  :to=" $route.path + '/' + (Number(selectedEvent.id)) "
                  active-class="link--active"
                  exact
                  class="link"
                >
                  <v-btn icon>
                    <v-icon>mdi-dots-vertical</v-icon>
                  </v-btn>
                </router-link>
              <!-- ④-2 ここまで EvnetDetaileへのリンク -->

              </v-toolbar>
              <v-card-text>
                <span v-html="selectedEvent.details"></span>
              </v-card-text>
              
            <!-- ④-3 ここからAnswer -->
              <v-card-actions>                
                <v-row>

                  <v-col cols="12">
                    <v-radio-group
                      v-if="eventAnswer.length == 1"
                      v-model="eventAnswer[0].answer"
                      row
                      @change="onChange"
                    >
                    <!-- <v-radio-group
                      v-model="row"
                      row
                      @change="onChange"
                    > -->
                      <v-radio
                        label="参加"
                        value="○"
                      ></v-radio>
                      <v-radio
                        label="不参加"
                        value="-"
                      ></v-radio>
                    </v-radio-group>
                  </v-col>

                  <!-- <v-col cols="12">
                    <v-btn
                      text
                      color="secondary"
                      @click="selectedOpen = false"
                    >
                      キャンセル
                    </v-btn>
                  </v-col> -->

                  <!-- <v-col cols="12">
                    <p v-if="eventAnswer.length == 1">Answer : {{ eventAnswer[0].answer }}</p>
                  </v-col> -->

                </v-row>
              </v-card-actions>
            <!-- ④-3 ここまでAnswer -->

            </v-card>
          </v-menu>
        <!-- ④ここまでイベントを触ると編集へのリンクが出せる -->
        </v-sheet>
      </v-col>
    </v-row>
    
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      focus: '',
      type: 'month',
      typeToLabel: {
        month: 'Month',
        week: 'Week',
        day: 'Day',
        '4day': '4 Days',
      },
      selectedEvent: {},
      selectedElement: null,
      selectedOpen: false,
      events: [],
      events2: [],
      colors: ['deep-purple', 'green', 'orange'],
      names: ['練習', '飲み', '試合'],
      answer: [],
      answers: [],
      // row: null,
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
        return result;
    },
  },

  created () {
    this.getEvent();
  },

  beforeUpdate(){
    this.pushEvent();
  },

  methods: {
    viewDay ({ date }) {
      this.focus = date
      this.type = 'day'
    },
    getEventColor (event) {
      return event.color
    },
    setToday () {
      this.focus = ''
    },
    prev () {
      this.$refs.calendar.prev()
    },
    next () {
      this.$refs.calendar.next()
    },
    showEvent ({ nativeEvent, event }) {
      const open = () => {
        this.selectedEvent = event
        this.selectedElement = nativeEvent.target
        requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpen = true))

        // this.row = this.eventAnswer[0].answer //ここでevnet毎のanswerをrowへ格納しウィンドウ表示時の初期値を動的に更新

      }
        if (this.selectedOpen) {
          this.selectedOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }
      nativeEvent.stopPropagation()
    },
    // rnd (a, b) {
    //   return Math.floor((b - a + 1) * Math.random()) + a
    //   // Math.floor(n) = nを切り捨て
    //   // Math.rondom() = 0以上1未満のランダムな浮動小数点を作成
    // },
    getEvent() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/events.json`)
        .then(response => {
          this.events2 = response.data.events;
          this.answers = response.data.answers;
        });
    },
    pushEvent() {
      const events = []
      const eventCount = this.events2.length
      const modifyDate = (new Date('2000-01-01')).getTime()

      for (let i = 0; i < eventCount; i++) {
        const dateTime = (new Date(this.events2[i].date)).getTime()
        const firstTimestamp = (new Date(this.events2[i].starttime)).getTime()
        const first = new Date(firstTimestamp - modifyDate + dateTime)
        const secondTimestamp = (new Date(this.events2[i].finishtime)).getTime()
        const second = new Date(secondTimestamp - modifyDate + dateTime)

      //上で求めた定数を用いて,配列にname,start,end,color,timedを追加
        events.push({
          name : this.events2[i].place,
          start: first, //表示期間中からランダムに日付+時間を選定 (イベント開始時刻)
          end: second, //表示期間中からランダムに日付+時間を選定 (イベント終了時刻)
          // color: this.colors[this.rnd(0, this.colors.length - 1)], //colorsからランダムに値を選定
          color: "green",
          timed: true, //true で時間までcarenderに反映 (day,4 days, week のみ)
          id: this.events2[i].id,
        })
      }
      // console.log(this.events);
      this.events = events
    },
    onChange() {  // クリックイベントでイベント発火
      // this.eventAnswer[0].answer = this.row  //radio変更に応じてdata内のrowも同期して更新
      this.updateAnswer();
    },
    updateAnswer() {
      // if (!this.row) return;
        this.answer = this.eventAnswer[0]
        axios
          .patch(`/api/v1/answers/${this.answer.id}`, {
            answer: {           
              answer: this.answer.answer
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