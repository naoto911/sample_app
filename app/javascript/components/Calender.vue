<template>
  <div>
  
    <!-- ここから ② カレンダー表示 -->
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

                <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
                <v-spacer></v-spacer>

              <!-- ④-2 ここから EvnetDetaileへのリンク -->
                <router-link
                  :to=" '/groups/' +(selectedEvent.group_id) + '/events/' + (Number(selectedEvent.id)) "
                  active-class="link--active"
                  exact
                  class="link"
                >
                  <v-btn icon>
                    <v-icon>mdi-credit-card-search-outline</v-icon>
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
                      v-if="eventAnswer"
                      v-model="eventAnswer.answer"
                      row
                      @change="$emit('onChange', eventAnswer)"
                    >
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

                </v-row>
              </v-card-actions>
            <!-- ④-3 ここまでAnswer -->

            </v-card>
          </v-menu>
        <!-- ④ここまでイベントを触ると編集へのリンクが出せる -->
        </v-sheet>
      </v-col>
    </v-row>
  <!-- ここまで ② カレンダー表示 -->
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
      colors: ['deep-purple', 'green', 'orange'],
    }
  },

  props: {
    events: {
      type: Array
    },
    answers: {
      type: Array
    }
  },

  computed: {
    eventAnswer(){
        const data = this.answers;
        const result = data.filter(x => x.event_id === this.selectedEvent.id);
        return result[0];
    },
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
  },
}
</script>