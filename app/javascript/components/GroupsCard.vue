<template>
  <div>
    <v-row>

    <!-- ここから ① 検索ウィンドウ -->
      <v-col cols="12">
        <!-- <v-text-field
          outlined
          v-bind="keyword2"
          @keyup.enter="submitText"
          label="グループを検索"
          append-outer-icon="mdi-map-marker"
        ></v-text-field> -->

        <v-text-field
          outlined
          v-model.lazy="keyword"
          label="グループを検索"
          append-icon="mdi-magnify"
        ></v-text-field>
      </v-col>
    <!-- ここまで ① 検索ウィンドウ -->

    <!-- ここから ② Group-card一覧 -->
      <v-col
        v-for="val in SerchGroups"
        :key="val.id"
        cols="4"
      >
        <router-link
          :to=" 'groups/' + (Number(val.id)) + '/detail'"
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

              <v-img
                :src= "val.image.url"
                height="200px"
              ></v-img>

              <v-card-title>
                {{ val.name }}
              </v-card-title>

              <v-card-subtitle>
                {{ val.introduction }}
              </v-card-subtitle>

            </v-card>
          </v-hover>
        </router-link>
      </v-col>
    <!-- ここまで ② Group-card一覧 -->

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
    }
  },

  props: {
    vals: {
      type: Array
    }
  },

  computed: {
    SerchGroups () {
      console.log("検索実行");
      var vals = [];
      for(var i in this.vals) {
          var group = this.vals[i];
          if(group.name.indexOf(this.keyword) !== -1) {
          // if(group.name.indexOf(this.keyword) !== -1 || user.email.indexOf(this.keyword) !== -1) {
              vals.push(group);
          }
      }
      return vals;
    },
  },

  // methods: {
  //   submitText() {
  //       this.keyword = this.keyword2;
  //   },
  // },

};
</script>