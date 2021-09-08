<template>
  <div>
    <v-row>
      <v-col
        v-for="val in vals"
        :key="val.id"
        cols="4"
      >
      <!-- ここから ① Group-card一覧 -->
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
      <!-- ここまで ① Group-card一覧 -->
      </v-col>
    </v-row>

    <div>{{ token }}</div>

  </div>
</template>


<script>

export default {
  data() {
    return {
      show: false,
      val: []
    }
  },

  props: {
    vals: {
      type: Array
    }
  },

  computed: {
    token () {
      return this.$store.state.token
    }
  },

};
</script>