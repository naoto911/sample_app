<template>
  <div>
 
  <!-- ここからイベント作成ボタン -->
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
  <!-- ここまでイベント作成ボタン -->

  <!-- ここからイベント一覧 (最終的に削除 *Calendarの中に配置する) -->
    <v-row>
      <v-col
        v-for="val in events2"
        :key="val.id"
        cols="4"
      >
      <!-- ここから -->
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
      <!-- ここまで -->
      </v-col>
    </v-row>
  <!-- ここまでイベント一覧 (最終的に削除 *Calendarの中に配置する) -->

  <!-- ここからCalendar -->
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
          <!-- ここからカレンダー期間を変更 -->
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
          <!-- ここまでカレンダー期間を変更 -->
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
            @change="updateRange"
          ></v-calendar>
        <!-- ③ここまでカレンダーのメインの部分 -->

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

            <!-- ④-3 ここからCancelボタン -->
              <v-card-actions>
                <v-btn
                  text
                  color="secondary"
                  @click="selectedOpen = false"
                >
                  Cancel
                </v-btn>
              </v-card-actions>
            <!-- ④-3 ここまでCancelボタン -->

            </v-card>
          </v-menu>
        <!-- ④ここまでイベントを触ると編集へのリンクが出せる -->
        </v-sheet>
      </v-col>
    </v-row>
  <!-- ここまでCalendar -->
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data: () => ({
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
    // colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
    // names: ['Meeting', 'Holiday', 'PTO', 'Travel', 'Event', 'Birthday', 'Conference', 'Party'],
  }),

  // beforeMount() {
  //   this.getEvent();
  // },

  mounted () {
    this.getEvent();
    this.$refs.calendar.checkChange();
    // this.getEvent();
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
      }

      if (this.selectedOpen) {
        this.selectedOpen = false
        requestAnimationFrame(() => requestAnimationFrame(() => open()))
      } else {
        open()
      }

      nativeEvent.stopPropagation()
    },
    //画面変化毎に実行 (カレンダー周期変更毎にランダムにイベントを作成)
    updateRange ({ start, end }) {
      const events = []

      const min = new Date(`${start.date}T00:00:00`) //min = 開始日の00:00:00
      const max = new Date(`${end.date}T23:59:59`) //min = 終了日の00:00:00
      const days = (max.getTime() - min.getTime()) / 86400000 //max-min (秒→日換算)
      // const eventCount = this.rnd(days, days + 20) //表示期間(日)+20を最大としたランダム値を取得し,これをイベント生成個とする
      const eventCount = this.events2.length

      //上で定まったイベント生成個分for文を回す
      //後で配列へ追加するための定数を毎loop算出

    //パターンA (作業実施箇所)
      const modifyDate = (new Date('2000-01-01')).getTime()

      for (let i = 0; i < eventCount; i++) {
        const dateTime = (new Date(this.events2[i].date)).getTime()
        const firstTimestamp = (new Date(this.events2[i].starttime)).getTime()
        const first = new Date(firstTimestamp - modifyDate + dateTime)
        const secondTimestamp = (new Date(this.events2[i].finishtime)).getTime()
        const second = new Date(secondTimestamp - modifyDate + dateTime)
    //

    //パターンB (defaultの設定)
      // for (let i = 0; i < eventCount; i++) {
      //   const allDay = this.rnd(0, 3) === 0
      //   const firstTimestamp = this.rnd(min.getTime(), max.getTime())
      //   const first = new Date(firstTimestamp - (firstTimestamp % 900000))
      //   const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000
      //   const second = new Date(first.getTime() + secondTimestamp)
      //

      //上で求めた定数を用いて,配列にname,start,end,color,timedを追加
        events.push({
          // name: this.names[this.rnd(0, this.names.length - 1)],// namesからランダムに値を選定
          name : this.events2[i].place,
          start: first, //表示期間中からランダムに日付+時間を選定 (イベント開始時刻)
          end: second, //表示期間中からランダムに日付+時間を選定 (イベント終了時刻)
          color: this.colors[this.rnd(0, this.colors.length - 1)], //colorsからランダムに値を選定
          // timed: !allDay, //0~3の乱数が0になったら(this.rnd(0, 3) === 0 ) true
          timed: true, //true で時間までcarenderに反映 (day,4 days, week のみ)
          id: this.events2[i].id,
        })
      }

      this.events = events
    },
    //ここでランダムにeventsから取得
    rnd (a, b) {
      return Math.floor((b - a + 1) * Math.random()) + a
      // Math.floor(n) = nを切り捨て
      // Math.rondom() = 0以上1未満のランダムな浮動小数点を作成
    },

    getEvent() {
      axios
        .get(`/api/v1/groups/${this.$route.params.id}/events.json`)
        .then(response => {
          this.events2 = response.data.events;
          // this.users = response.data.users;
        });
    },

  },
}
</script>