import Vue from 'vue'
import ActionCableVue from 'actioncable-vue';
import App from './App.vue'
import router from './router'
import store from './store'
import './registerServiceWorker'

Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: 'ws://localhost:3000/cable',
  connectImmediately: true
});

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
