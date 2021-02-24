<template>
  <v-app>
    <v-navigation-drawer
      fixed
      v-model="drawer"
      class="grey darken-3"
      light
      app
      style="height: 100vh; display: flex; flex-direction: column; padding-bottom: 0"
    >
      <v-card class="blue-grey darken-1 white--text">
        <v-card-title>
          <v-row class="justify-center">
            <h1 style="font-size: 21px">EagleLogger</h1>
            <h4 style="font-weight: normal; font-size: 16px">An Amateur Radio Net Logger</h4>
          </v-row>
        </v-card-title>
      </v-card>
      <v-list dense class="main-menu" style="flex: 1" two-line>
        <router-link to="/" :class="{'current-page': $route.path === '/'}">
          <v-list-item @click="closeNavDrawer">
            <v-list-item-action>
              <v-icon>mdi-home</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>Home</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </router-link>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app class="blue darken-3">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" dark></v-app-bar-nav-icon>
      <v-spacer></v-spacer>
        <v-toolbar-title class="white--text">EagleLogger</v-toolbar-title>
      <v-spacer></v-spacer>
      <span v-show="isAuthed" class="capitalize white--text" style="margin-right: 25px">
        Hello {{ user.firstName }}!
      </span>
      <v-btn text outlined @click="loginDialogOpened=true" class="white--text" v-show="!isAuthed"><v-icon left>mdi-radio-handheld</v-icon> Login</v-btn>
      <v-btn text outlined @click="logout" class="white--text" v-show="isAuthed">Logout <v-icon right>mdi-logout-variant</v-icon></v-btn>
    </v-app-bar>

    <v-main>
      <router-view></router-view>
    </v-main>
    <v-dialog v-model="loginDialogOpened" width="350">
      <v-card>
        <v-card-title>Login</v-card-title>
        <v-card-text>
          <p>It's pretty easy right now, you just need your callsign.</p>
          <form @submit.prevent="login">
            <v-text-field v-model="loginCallsign" label="Callsign" autofocus></v-text-field>
          </form>
        </v-card-text>
        <v-card-actions>
          <v-btn text outlined @click="loginDialogOpened=false">Close</v-btn>
          <v-spacer></v-spacer>
          <v-btn raised color="primary" @click="login">Login</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-app>
</template>


<style>

  #app {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    display: flex;
    flex-direction: column;
  }
  .main-menu {
    margin-top: 25px;
  }
  .main-menu a {
    text-decoration: none;
    color: white !important;
    font-size: 16px !important;
  }
  .main-menu .v-list-item div {
    color: white !important;
    font-size: 16px !important;
  }
  .hover-white {
    transition: color .2s ease;
  }
  .hover-white:hover {
    color: white !important;
  }
  .current-page .v-list-item div {
    color: rgb(21, 101, 192) !important;
  }
  .main-menu li > a:hover {
    background-color: rgba(255,255,255,.14) !important;
  }
  .main-menu li > a:hover i {
    color: rgb(21, 101, 192) !important;
  }
  .main-menu .current-page li > a:hover {
    background-color: initial !important;
  }
  .main-menu .current-page li > a:hover i {
    color: white !important;
  }
  .main-menu i {
    font-size: 28px !important;
    color: white !important;
  }
  .main-menu li:hover a {
    /*color: blue !important;*/
  }
  .snackbar-text {

  }
</style>


<script>

import { mapGetters, mapMutations, mapState } from 'vuex'

import firestore from './firestore'

export default {
  name: 'App',

  mounted () {
    firestore.collection('nets').where('active', '==', true).orderBy('createdAt', 'asc').onSnapshot(snapshot => {
      const activeNets = []
      snapshot.forEach(doc => {
        const net = doc.data()
        net.netId = doc.id
        activeNets.push(net)
      })
      this.setGeneric({prop: 'activeNets', value: activeNets})
    })
    const urlParams = new URLSearchParams(window.location.search)
    const isNCS = urlParams.get('isNCS')
    if (this.isNCS) {
      if (isNCS === "false") {
        this.setGeneric({ prop: 'isNCS', value: false })
      }
    } else {
      if (isNCS) {
        this.setGeneric({ prop: 'isNCS', value: true })
      }
    }
  },
  computed: {
    ...mapGetters(['isAuthed']),
    ...mapState(['user', 'isNCS'])
  },
  watch: {
    loginCallsign (callsign) {
      const ucc = callsign.toUpperCase()
      if (callsign !== ucc) {
        this.loginCallsign = ucc
      }
    }
  },
  data: () => ({
    drawer: true,
    loginDialogOpened: false,
    loginCallsign: ''
  }),
  methods: {
    ...mapMutations(['setGeneric']),
    async login () {
      const doc = await firestore.collection('callsigns').doc(this.loginCallsign).get()
      const user = doc.data()
      user.callsign = doc.id
      this.setGeneric({prop: 'user', value: user})
      this.loginDialogOpened = false
    },
    logout () {
      this.setGeneric({prop: 'user', value: {}})
    },
    closeNavDrawer() {}
  },
};
</script>
