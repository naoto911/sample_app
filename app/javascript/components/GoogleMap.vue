<template>
  <div>
    <!-- ここから ①-1 検索ウィンドウ -->
    <v-row>
      <v-col cols="6">
        <v-text-field
          outlined
          v-model.lazy="keyword"
          label="名称検索"
          append-icon="mdi-magnify"
        ></v-text-field>
      </v-col>
      <v-col cols="6">
        <v-btn @click="searchCordinate(map)">
          検索
        </v-btn>
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
      myLatLng: { lat: 35.689614, lng: 139.691585 },
      
      // YOUR_MAP_KEY: 'ここにAPIキーを入れる',
      map: {},
      marker: {},

      keyword: '',
    };
  },
  
  mounted() {
    if (!window.mapLoadStarted) {
      window.mapLoadStarted = true;
      let script = document.createElement('script');
      script.src =
        `https://maps.googleapis.com/maps/api/js?key=${this.YOUR_MAP_KEY}&callback=initMap`;
      script.async = true;
      document.head.appendChild(script);
    }

    window.initMap = () => {
      window.mapLoaded = true;
    };

    let timer = setInterval(() => {
      if (window.mapLoaded) {
        clearInterval(timer);
        this.map = new window.google.maps.Map(this.$refs.map, {
        // const map = new window.google.maps.Map(this.$refs.map, {
          center: this.myLatLng,
          zoom: 10,
        });

        // クリックイベントを追加
        google.maps.event.addListener(this.map, 'click', event => this.clickAction(event, this.map));
      }
    }, 500);
  },

  methods: {
    clickAction(event, map) {
      const lat = event.latLng.lat();
      const lng = event.latLng.lng();

      this.deleteMakers();
      
      this.marker = new google.maps.Marker({
        position: {lat, lng},
        map
      });
      console.log("ここで緯度経度を試す");
      console.log(lat);
      console.log(lng);
    },
    deleteMakers() { //マーカーを削除する
        if(Object.keys(this.marker).length) {
        this.marker.setMap(null);
      }
        this.marker = null;
    },
    searchCordinate(map) {
          var place = this.keyword;
          var geocoder = new google.maps.Geocoder(); // geocoderのコンストラクタ

          geocoder.geocode(
            { 
              address: place, 
            }, 
            function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) {
                for (var i in results) {
                  if (results[0].geometry) {
                    var latlng = results[0].geometry.location; // 緯度経度を取得
                    // var address = results[0].formatted_address; // 住所を取得
                    map.setCenter(latlng); // 変換した緯度・経度情報を地図の中心に表示
                    map.setZoom(15); //縮尺を調整
                  }
                }
              } else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
                alert("見つかりません");
              } else {
                console.log(status);
                alert("エラー発生");
              }
            }
          );
      },

  }

};
</script>