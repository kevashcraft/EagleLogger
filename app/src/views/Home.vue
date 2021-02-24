<template>
  <v-container fluid style="height: 100%; padding: 0; overflow-y: scroll">
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>Welcome to EagleLogger</h3></v-card-title>
          <v-card-text>
            <p>Active Nets</p>
            <v-list>
              <v-list-item v-for="net in activeNets" :key="net.netId" @click="openNet(net.netId)">
                <v-list-item-icon>
                  <v-avatar>
                    <span class="white--text headline">{{ net.name.slice(0, 1) }}</span>
                  </v-avatar>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title>{{ net.name }}</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
            <v-btn fab absolute bottom right outlined @click="newNetDialogOpened=true" color="orange" v-if="isNCS" icon><v-icon>mdi-table-column-plus-after</v-icon></v-btn>
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
    <v-dialog v-model="newNetDialogOpened" width="350">
      <v-card>
        <v-card-title>Start a Net</v-card-title>
        <v-card-text>
          <form @submit.prevent="addNet">
            <v-text-field v-model="newNet.name" label="Net Name"></v-text-field>
          </form>
        </v-card-text>
        <v-card-actions>
          <v-btn text outlined @click="newNetDialogOpened=false">Close</v-btn>
          <v-spacer></v-spacer>
          <v-btn raised color="primary" @click="addNet">Start</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
  // import Page from '@/components/Mixins/Page'
  // import NetsList from '../Nets/NetsList.vue'
  import firestore from '@/firestore'
  import { mapState } from 'vuex'

  export default {
    // mixins: [Page],
    data () {
      return {
        newNet:{
          name: '',
          active: true
        },
        newNetDialogOpened: false,
      }
    },
    computed: mapState(['activeNets', 'isNCS']),
    watch: {
      activeNets () {
        console.log("this.activeNets", JSON.stringify(this.activeNets))
      }
    },
    mounted () {
      this.newNetTemplate = JSON.stringify(this.newNet)
    },
    methods: {
      async addNet() {
        this.newNet.createdAt = new Date()
        const result = await firestore.collection('nets').add(this.newNet)
        this.newNet = JSON.parse(this.newNetTemplate)
        this.$router.push({name: 'Net', params: { netId: result.id }})
      },
      openNet(netId) {
        this.$router.push({ name: 'Net', params: { netId }})
      }
    }
  }
</script>

