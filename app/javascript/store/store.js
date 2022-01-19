import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({

  state: {
    // loginUser: {},
    loginUser: null,
    loggedIn: false
  },
  getters: {
    loginUser: state => state.loginUser,
    loggedIn: state => state.loggedIn
  },
  mutations : {
    storeloginUser(state, loginUser) {
        state.loginUser = loginUser;
        state.loggedIn = true
    }
  },
  actions: {
    login({commit}){
      // console.log("store_Loginを実行")
        axios
        .get('/api/v1/groups.json')
        .then(response => {
            commit('storeloginUser', response.data.current_user)
        });
    }
  },
})