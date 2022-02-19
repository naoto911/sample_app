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
      YOUR_MAP_KEY: 'ここにAPIキーを入れる',
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
        const map = new window.google.maps.Map(this.$refs.map, {
          center: this.myLatLng,
          zoom: 10,
        });
        new window.google.maps.Marker({ position: this.myLatLng, map });
      }
    }, 500);
  },
};
</script>