// document.addEventListener('DOMContentLoaded', () => {
//   const el = document.body.appendChild(document.createElement('hello'))
//   const app = new Vue({
//     el,
//     render: h => h(App)
//   })

//   console.log(app)
// })

import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue';
import App from '../app.vue';
import router from '../router';
import vuetify from './vty'
import store  from '../store/store.js'

Vue.use(TurbolinksAdapter)

// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     router,
//     render: h => h(App)
//   }).$mount()
//   document.body.appendChild(app.$el)

//   console.log(app)
// })

Vue.config.productionTip = false;

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app');