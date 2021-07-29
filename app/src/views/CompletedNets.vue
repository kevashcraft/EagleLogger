<template>
  <v-container fluid style="height: 100%; padding: 0; overflow-y: scroll">
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
    </v-card>
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>Completed Nets</h3></v-card-title>
          <v-card-text>
            <v-list>
              <v-list-item v-for="net in nets" :key="net.netId" @click="openNet(net.netId)">
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
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
  import { firestore } from '@/plugins/firestore'
  import moment from 'moment'

  export default {
    data () {
      return {
        nets: [],
      }
    },
    async mounted () {
      const doc = await firestore.collection('meta').doc('completedNets').get()
      const data = doc.data()
      this.nets = data.nets
    },
    methods: {
      openNet(netId) {
        this.$router.push({ name: 'Net', params: { netId }})
      },
      netTitle(net) {
        return net.name + ' - ' + moment(net.createdAt.seconds, 'X').format('dddd, MMMM Do, YYYY') + ' - ' + net.checkinCount + ' checkins'
      }
    }
  }
</script>

