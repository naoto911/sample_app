<template>
  <div>
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
    // test(event){
    //   this.marker = new window.google.maps.Marker({ 
    //     position: this.map.getCenter(),
    //     map: this.map 
    //   });
    // },
  }

};
</script>