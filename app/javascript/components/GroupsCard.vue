<template>
<div>
  <!-- <v-app> -->
    <v-main>
      <v-container>
        <v-row>
          <v-col
            v-for="val in vals"
            :key="val.id"
            cols="4"
          >
          <!-- ここから -->
          <router-link
            :to=" 'groups/' + (Number(val.id))"
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

                <v-card-actions>
                  <v-btn
                    color="orange lighten-2"
                    text
                  >
                    LEARN MORE
                  </v-btn>

                  <v-spacer></v-spacer>

                  <v-btn
                    icon
                    @click="show = !show"
                  >
                    <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
                  </v-btn>
                </v-card-actions>

                <v-expand-transition>
                  <div v-show="show">
                    <v-divider></v-divider>

                    <v-card-text>
                      ここに,グループ説明を表示
                    </v-card-text>
                  </div>
                </v-expand-transition>
              </v-card>
            </v-hover>
            </router-link>
            <!-- ここまで -->
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  <!-- </v-app> -->
</div>
</template>


<script>

export default {
  data() {
    return {
      show: false,
    }
  },
  props: {
    val: {
      type: Array
    },
    vals: {
      type: Array
    }
  } 
};
</script>

<style scoped>

</style>