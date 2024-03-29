import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import store from './plugins/store'
import router from './plugins/router'

import '@mdi/font/css/materialdesignicons.css'
import './style.scss'

Vue.config.productionTip = false

new Vue({
  vuetify,
  store,
  router,
  render: h => h(App)
}).$mount('#app')
