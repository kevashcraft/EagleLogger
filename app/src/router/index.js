import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/views/Home'
import Net from '@/views/Net'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  }, {
    path: '/net/:netId',
    name: 'Net',
    component: Net
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
