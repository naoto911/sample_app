<template>
  <div>
    <v-row>
    <!-- ここから ① 検索系 -->
      <v-col cols="3"></v-col>
    <!-- ここから ①-1 文字列検索 -->
      <v-col cols="6">
        <v-text-field
          outlined
          v-model.lazy="keyword"
          label="グループを検索"
          append-icon="mdi-magnify"
        ></v-text-field>
      </v-col>
    <!-- ここまで ①-1 文字列検索 -->

    <!-- ここから ①-2 人数検索 -->
      <v-col cols="3">
        <v-btn
          icon
          @click="show = !show"
        >
          <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
        </v-btn>
      </v-col>

      <v-col cols="12" v-show="show">
        <v-expand-transition>
          <v-card>
            <v-divider></v-divider>

            <v-card-text>
              <v-row>
                <v-col cols="12">
                  <v-slider
                    v-model="min"
                    :max="100"
                    label="以上"
                    class="align-center"
                  >
                    <template v-slot:append>
                      <v-text-field
                        v-model="min"
                        class="mt-0 pt-0"
                        type="number"
                        style="width: 60px"
                      ></v-text-field>
                    </template>
                  </v-slider>
                </v-col>

                <v-col cols="12">
                  <v-slider
                    v-model="max"
                    :max="100"
                    label="以下"
                    class="align-center"
                  >
                    <template v-slot:append>
                      <v-text-field
                        v-model="max"
                        class="mt-0 pt-0"
                        type="number"
                        style="width: 60px"
                      ></v-text-field>
                    </template>
                  </v-slider>
                </v-col>
              </v-row>
            </v-card-text>

          </v-card>
        </v-expand-transition>
      </v-col>
    <!-- ここまで ①-2 人数検索 -->
    <!-- ここまで ① 検索系 -->

    <!-- ここから ② Group-card一覧 -->
      <v-col
        v-for="val in SerchGroups"
        :key="val.id"
        cols="12" sm="6" md="4" lg="3"
      >
        <router-link
          :to=" '/groups/' + (Number(val.id)) + '/detail'"
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
              max-width="260"
            >

              <v-img
                :src= "val.image.url"
                height="200px"
              ></v-img>

              <v-card-title>
                {{ val.name }}
              </v-card-title>

              <v-card-subtitle>
                <!-- {{ val.introduction | omittedText(10) }}  -->
                人数:{{ getGroupLength(val.id).count }}
              </v-card-subtitle>

            </v-card>
          </v-hover>
        </router-link>
      </v-col>
    <!-- ここまで ② Group-card一覧 -->

    <!-- ここから  ページネーション -->
      <v-col cols="12">
        <v-pagination
          v-model="page"
          :length="length"
          @input = "pageChange"
        ></v-pagination>
      </v-col>
    <!-- ここまで ページネーション -->

    </v-row>
  </div>
</template>


<script>

export default {
  data() {
    return {
      show: false,
      val: [],
      keyword: '',
      text: "0123456789101112",

      min: 0,
      max: 100,
      show: false,

      page: 1,
      length:0,
      lists: [],
      displayLists: [],
      pageSize: 3,
    }
  },

  props: {
    vals: {
      type: Array
    },
    groups_length: {
      type: Array
    },
  },

  watch:{
    Watch_data() {
      console.log('検知')
      this.page = 1
    },
  },

  computed: {
    Watch_data(){
      return [this.keyword,this.min, this.max];
    },
    SerchGroups () {
      var vals = [];
      var vals2 = [];
      for(var i in this.groups_length) {
          var groups_length = this.groups_length[i];
          if(groups_length.count >= this.min && groups_length.count <= this.max) {
              var group2 = this.getGroupForLength(groups_length.id)
              vals.push(group2);
          }
      }

      for(var i in vals) {
          var group = vals[i];
          if(group.name.indexOf(this.keyword) !== -1) {
              vals2.push(group);
          }
      }

    this.lists = vals2
    this.length = Math.ceil(this.lists.length/this.pageSize);
    this.displayLists = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));

    return this.displayLists;
    },
  },

  filters: {
    omittedText(text,count) {
     // count文字目以降は"…"
     return text.length > count ? text.slice(0, count) + "…" : text;
    }
  },

  methods: {
    getGroupLength(key_id) {
      const data = this.groups_length;
      const result = data.filter(x => x.id === key_id);
      return result[0];
    },
    getGroupForLength(key_id) {
      const data = this.vals;
      const result = data.filter(x => x.id === key_id);
      return result[0];
    },
    pageChange(pageNumber){
      this.displayLists = this.lists.slice(this.pageSize*(pageNumber -1), this.pageSize*(pageNumber));
    },
  },

};
</script>