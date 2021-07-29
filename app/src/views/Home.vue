<template>
  <v-container fluid style="height: 100%; padding: 0; overflow-y: scroll">
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>Welcome to EagleLogger</h3></v-card-title>
          <v-card-text class="std-txt">
            <p>Hello and welcome to EagleLogger!</p>
            <p><strong>EagleLogger is a tool for ham radio nets</strong> - tracking checkins, license lookups, and real-time chat. It's made by <a href="https://www.km4fpa.com" title="Kevin Ashcraft (KM4FPA)" target="_blank">KM4FPA</a> and usually used for the EagleNet on Tuesday nights at 8:30pm on the <a href="https://ni4ce.org/ni4ce-repeater-map-frequencies/" title="West Central Florida Repeater System (NI4CE)" target="_blank">NI4CE</a> repeater system.</p>
            <p>There {{ activeNetText(activeNets) }} right now, and <router-link to="/completed-nets">{{ counts.nets.toLocaleString() }} completed nets</router-link>.</p>
            <p>EagleLogger has logged <strong>over {{ counts.checkins.toLocaleString() }} total checkins</strong>.</p>
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title>
            <h3 v-show="activeNets.length > 0">Active Nets <small style="font-weight: 400; font-size: 14px">(click one to open)</small></h3>
            <h3 v-show="activeNets.length === 0">No Active Nets Right Now</h3>
          </v-card-title>
          <v-card-text>
            <v-list>
              <v-list-item v-for="net in activeNets" :key="net.netId" @click="openNet(net.netId)">
                <v-list-item-icon>
                  <v-avatar size="36" color="green">
                    <span class="white--text headline">{{ net.name.slice(0, 1) }}</span>
                  </v-avatar>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title>{{ netTitle(net) }}</v-list-item-title>
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

<style lang="scss" scoped>
.std-txt {
  font-size: 21px;
  font-weight: 400;
  line-height: 28px;

}
</style>

<script>
  import { firestore } from '@/plugins/firestore'
  import { mapState } from 'vuex'
  import moment from 'moment'

  export default {
    data () {
      return {
        newNet:{
          name: '',
          checkinCount: 0,
          active: true
        },
        newNetDialogOpened: false,
        currentTime: moment(),
      }
    },
    computed: mapState(['counts', 'activeNets', 'isNCS']),
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
      },
      activeNetText(activeNets) {
        if (!activeNets.length) return 'are no active nets'
        if (activeNets.length === 1) return 'is 1 active net'
        return 'are ' + activeNets.length + ' active nets'
      },
      netTitle(net) {
        return net.name + ' - ' + moment(net.createdAt.seconds, 'X').format('dddd, MMMM Do, YYYY') + ' - ' + net.checkinCount + ' checkins'
      }
    }
  }
</script>

