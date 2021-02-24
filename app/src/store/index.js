import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'

Vue.use(Vuex)

const vuexLocal = new VuexPersistence({
  storage: window.localStorage
})

export default new Vuex.Store({
  state: {
    activeNets: [],
    user: {},
    isNCS: false
  },
  mutations: {
    setGeneric (state, {prop, value}) {
      console.log("prop", prop)
      console.log("value", value)
      state[prop] = value
    }
  },
  actions: {
  },
  getters: {
    isAuthed (state) {
      return !!state.user.callsign
    }
  },
  modules: {
  },
  plugins: [vuexLocal.plugin]
})
