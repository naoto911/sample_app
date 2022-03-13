<template>
  <div>
    <!-- ここから ①-1 検索ウィンドウ -->
    <v-row>
      <v-col cols="6">
        <v-text-field
          outlined
          v-model.lazy="keyword"
          append-icon="mdi-magnify"
          id="pac-input"
        ></v-text-field>
      </v-col>
      <v-col cols="6">
        <!-- <v-btn @click="searchCordinate(map)">
          検索
        </v-btn> -->
      </v-col>
    </v-row>
    <!-- ここまで ①-1 検索ウィンドウ -->
    <div ref="map" style="height: 500px; width: 800px"></div>
  </div>
</template>



<script>
export default {
  data() {
    return {
      // myLatLng: { lat: 35.689614, lng: 139.691585 },
      myLatLng: { lat: 34.98586155776129, lng: 135.75780520290223 },
      
      // YOUR_MAP_KEY: 'ここにAPIキーを入れる',
      map: {},
      marker: {},

      keyword: '',
      LatLng: {},
    };
  },

  props: {
    group: {
      type: Object
    }
  },

 watch: {
   group: function (val) {
    //  console.log(this.group.lat);
    //  console.log(val.lat);
     this.getGoogleMap(val, this.map);
   },
    // '$route' (to, from) {
    //   console.log("ここでテスト");
    //   console.log(this.group.id);
    //   // this.getGoogleMap();
    // }
  },

  mounted() {
      if (!window.mapLoadStarted) {
        window.mapLoadStarted = true;
        let script = document.createElement('script');
        script.src =
          // `https://maps.googleapis.com/maps/api/js?key=${this.YOUR_MAP_KEY}&callback=initMap`; //検索候補実装前
          `https://maps.googleapis.com/maps/api/js?key=${this.YOUR_MAP_KEY}&callback=initAutocomplete&libraries=places&v=weekly`;

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

      //  クリックイベントを追加
      google.maps.event.addListener(this.map, 'click', event => this.clickAction(event, this.map));

      // ここから検索候補実装用のコード
      const input = document.getElementById("pac-input");
      const searchBox = new google.maps.places.SearchBox(input);

      // // マップを拡大しても検索ウィンドウを表示させるための処理 (検索ウィンドウはマップ上に設置の前提)
      // this.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

      // // 検索ウィンドウをマップ上に設置した場合の調整用の処理?
      // this.map.addListener("bounds_changed", () => { 
      //   searchBox.setBounds(this.map.getBounds());
      // });

      searchBox.addListener("places_changed", () => {

        const places = searchBox.getPlaces();

        if (places.length == 0) {
          return;
        }
        const bounds = new google.maps.LatLngBounds();

        places.forEach((place) => {
          if (!place.geometry) {  //"geometry"はplaceライブラリのメソッド。
            console.log("Returned place contains no geometry");
            return;
          }

          if (place.geometry.viewport) {  //viewport"メソッド
            bounds.union(place.geometry.viewport);
          } else {
            bounds.extend(place.geometry.location);
          }
        });
        this.map.fitBounds(bounds);
      });

      // // 検索候補実装前のコード
      // window.initAutocomplete = () => {
      // window.initMap = () => {
      //   window.mapLoaded = true;
      // };

      //   let timer = setInterval(() => {
      //     if (window.mapLoaded) {
      //       clearInterval(timer);
      //       this.map = new window.google.maps.Map(this.$refs.map, {
      //       // const map = new window.google.maps.Map(this.$refs.map, {
      //         center: this.myLatLng,
      //         zoom: 10,
      //       });

      //       // クリックイベントを追加
      //       google.maps.event.addListener(this.map, 'click', event => this.clickAction(event, this.map));

      //     }
      //   }, 500);
    },
    clickAction(event, map) {
      const lat = event.latLng.lat();
      const lng = event.latLng.lng();
      const position = {lat, lng};
      this.deleteMakers();
      
      this.marker = new google.maps.Marker({
        position: {lat, lng},
        map
      });
      this.$emit('latlng', position) // <=== 親コンポーネントに緯度経度情報をを渡すイベント
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
    // searchCordinate(map) {
    //       var place = this.keyword;
    //       var geocoder = new google.maps.Geocoder(); // geocoderのコンストラクタ

    //       geocoder.geocode(
    //         { 
    //           address: place, 
    //         }, 
    //         function(results, status) {
    //           if (status == google.maps.GeocoderStatus.OK) {
    //             for (var i in results) {
    //               if (results[0].geometry) {
    //                 var latlng = results[0].geometry.location; // 緯度経度を取得
    //                 // var address = results[0].formatted_address; // 住所を取得
    //                 map.setCenter(latlng); // 変換した緯度・経度情報を地図の中心に表示
    //                 map.setZoom(15); //縮尺を調整
    //               }
    //             }
    //           } else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
    //             alert("見つかりません");
    //           } else {
    //             console.log(status);
    //             alert("エラー発生");
    //           }
    //         }
    //       );
    //   },

  }

};
</script>