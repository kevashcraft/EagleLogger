import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/views/Home'
import Net from '@/views/Net'
import About from '@/views/About'
import CompletedNets from '@/views/CompletedNets'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  }, {
    path: '/about',
    name: 'About',
    component: About
  }, {
    path: '/net/:netId',
    name: 'Net',
    component: Net
  }, {
    path: '/completed-nets',
    name: 'CompletedNets',
    component: CompletedNets
  }, {
    path: '*',
    redirect: '/'
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
