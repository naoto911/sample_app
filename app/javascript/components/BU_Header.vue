      <!-- ②ここから展開ボタン -->
        <v-menu
          bottom
          left
        >
          <template v-slot:activator="{ on, attrs }">
            <!-- <v-btn
              icon
              v-bind="attrs"
              v-on="on"
            > -->
             <!-- <v-icon>mdi-dots-vertical</v-icon> -->
              <v-avatar
                v-bind="attrs"
                v-on="on"
              >
                <v-img
                  :src= "val.image.url"
                  alt="John"
                ></v-img>
              </v-avatar>
            <!-- </v-btn> -->
          </template>

          <v-list>
            <v-list-item
              v-for="(item, i) in items"
              :key="i"
              :to="item.url" exact
            >
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item>

            <v-list-tile-action>
              <v-btn 
                @click.stop="Logout(val.id)"
                v-if="val"
              >
                <v-icon @click.stop="Logout(val.id)">
                  Logout
                </v-icon>
              </v-btn>
            </v-list-tile-action>
          </v-list>
          
        </v-menu>
      <!-- ②ここまで展開ボタン -->

      <!-- <router-link
        v-if="val"
        :to=" 'users/' + (Number(val.id))"
        active-class="link--active"
        exact
        class="link"
      >
        <v-avatar>
          <v-img
            :src= "val.image.url"
            alt="John"
          ></v-img>
        </v-avatar>
      </router-link> -->

      <router-link
        v-if="val"
        :to=" 'users/' + (Number(val.id))"
        active-class="link--active"
        exact
        class="link"
      >

      </router-link>

          //画面変化毎に実行 (カレンダー周期変更毎にランダムにイベントを作成)
    updateRange ({ start, end }) {
      // console.log(start);
      // console.log(end);

      const events = []

      // const min = new Date(`${start.date}T00:00:00`) //min = 開始日の00:00:00
      // const max = new Date(`${end.date}T23:59:59`) //min = 終了日の00:00:00
      // const days = (max.getTime() - min.getTime()) / 86400000 //max-min (秒→日換算)
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