import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import CardView from '../views/CardView.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/card/:id',
    name: 'CardView',
    component: CardView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

