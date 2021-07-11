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