<template>
  <div>
    <!-- ここから 検索ウィンドウ -->
    <v-card-text>
      <v-text-field
        v-if="checkURL"
        v-model="address"
        label="練習場所"
        prepend-inner-icon="mdi-map-marker"
        filled
        id="pac-input"
      ></v-text-field>
    <!-- ここまで 検索ウィンドウ -->

    <!-- ここから Map本体 -->
      <v-row>
        <v-col>
          <v-responsive :aspect-ratio="16/9">
            <div ref="map" style="height: 100%; width: 100%"></div>
          </v-responsive>
        </v-col>
      </v-row>
     <!-- ここまで Map本体 -->
    </v-card-text>
  </div>
</template>

<script>
export default {
  data() {
    return {
      // myLatLng: { lat: 35.689614, lng: 139.691585 },
      myLatLng: { lat: 34.98586155776129, lng: 135.75780520290223 },
      YOUR_MAP_KEY: 'AIzaSyB1OGlg4o4pvW8vvEzhIOsfGhjhOZMvplE',
      map: {},
      marker: {},

      keyword: '',
      LatLng: {},

      address: ''
    };
  },

  props: {
    parent_object: {
      type: Object
    }
  },

 watch: {
   parent_object: function (val) {
    //  console.log("propsのgroup変化を検知");
     this.getGoogleMap(val, this.map);
   },
  },

  computed: {
    checkURL() {
      var result = false;
      var url = this.$route.path;
      if (url.indexOf('new') != -1 || url.indexOf('edit') != -1) {
        result = true
        if(Object.keys(this.map).length) {
          // console.log('this.mapが空でない時=initGoogleMap()完了後')
          this.addGogleMap();
        }
      }
      return result;
    }
  },


  mounted() {
      if (!window.mapLoadStarted) {
        window.mapLoadStarted = true;
        let script = document.createElement('script');
        script.src = `https://maps.googleapis.com/maps/api/js?key=${this.YOUR_MAP_KEY}&callback=initAutocomplete&libraries=places&v=weekly`;
        script.async = true;
        document.head.appendChild(script);
      }else {
        this.initGooleMap();
      }
      window.initAutocomplete = () => {
        this.initGooleMap();
      }
  },

  methods: {
    initGooleMap() {
      //マップの初期設定
      this.map = new window.google.maps.Map(this.$refs.map, {
        center: this.myLatLng,
        zoom: 13,
      });
    },
    addGogleMap(){
      var lat = null
      var lng = null
      var address = null

      // ここから検索候補実装用のコード
      const input = document.getElementById("pac-input");
      if (!input) return; 
      const searchBox = new google.maps.places.SearchBox(input);
      searchBox.addListener("places_changed", () => {
        const places = searchBox.getPlaces();
         if (places.length == 0) return;
        const bounds = new google.maps.LatLngBounds();

        places.forEach((place) => {
          if (!place.geometry) {  //"geometry"はplaceライブラリのメソッド。
            console.log("Returned place contains no geometry");
            return;
          }

          address = place.formatted_address // 住所取得
          lat = place.geometry.location.lat(); //緯度取得
          lng = place.geometry.location.lng(); //経度取得

          if (place.geometry.viewport) {  //viewport"メソッド
            bounds.union(place.geometry.viewport);
          } else {
            bounds.extend(place.geometry.location);
          }
        });
        this.map.fitBounds(bounds);
        this.address = address;
        this.deleteMakers();
        this.createMakers(lat, lng, address, this.map);
      });
    },
    createMakers(lat, lng, address, map){
      this.marker = new google.maps.Marker({
        position: {lat, lng},
        map
      });
      this.$emit('latlng',  {lat, lng, address}) // <=== 親コンポーネントに緯度経度情報をを渡すイベント
    },
    deleteMakers() { //マーカーを削除する
        if(Object.keys(this.marker).length) {
        this.marker.setMap(null);
      }
        this.marker = null;
    },
    getGoogleMap(val, map) {
      if (val.lat && val.lng) {
        this.LatLng = {lat: val.lat, lng: val.lng }
        this.deleteMakers();
        this.marker = new google.maps.Marker({
          position: this.LatLng,
          map
        });
      }
      else {
        this.LatLng = this.myLatLng;
      }
      this.map.setCenter(this.LatLng);
    },
  }

};
</script>