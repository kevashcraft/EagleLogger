<template>
  <v-container fluid style="height: 100%; padding: 0; overflow-y: scroll">
    <div>
      <h1>{{ net.name }}</h1>
    </div>
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>Checkins</h3></v-card-title>
          <v-card-text>
            <div style="max-height: 200px; overflow-y: auto" id="checkins">
              <v-list>
                <v-list-item v-for="checkin in checkins" :key="checkin.checkindId">
                  <v-list-item-content>
                    <v-list-item-title>{{ formatCheckin(checkin) }}<v-btn v-if="isNCS" @click="deleteCheckin(checkin.checkinId)" icon><v-icon>mdi-delete</v-icon></v-btn></v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
            </div>
            <div v-if="isNCS">
              <form @submit.prevent="addCheckin">
                <v-text-field ref="checkinInput" v-model="newCheckinCallsign" label="New Checkin"></v-text-field>
              </form>
            </div>
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin-top: 15px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>Chat</h3></v-card-title>
          <v-card-text>
            <div style="max-height: 200px; overflow-y: auto" id="chat">
              <v-list>
                <v-list-item v-for="message in chat" :key="message.messageId">
                  <v-list-item-content>
                    <v-list-item-title>{{ message.sender }} - {{ message.message }}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
            </div>
            <div v-if="isAuthed">
              <form @submit.prevent="addChat">
                <v-text-field ref="chatInput" v-model="newChatMessage" label="New Message"></v-text-field>
              </form>
            </div>
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
  import { mapGetters, mapState } from 'vuex'
  import { firestore, increment } from '@/plugins/firestore'

  export default {
    mounted () {
      this.netId = this.$route.params.netId
      this.unsubscribeNet = firestore.collection('nets').doc(this.netId).onSnapshot(doc => {
        const net = doc.data()
        net.netId = doc.id
        this.net = net
      })

      this.unsubscribeCheckins = firestore.collection('nets').doc(this.netId).collection('checkins').orderBy('createdAt', 'asc').onSnapshot(snapshot => {
        const checkins = []
        let lineNum = 0
        snapshot.forEach(doc => {
          lineNum++
          const checkin = doc.data()
          checkin.checkinId = doc.id
          checkin.lineNum = lineNum
          checkins.push(checkin)
        })

        this.checkins = checkins
        setTimeout(this.scrollCC, 250)
      })

      this.unsubscribeChat = firestore.collection('nets').doc(this.netId).collection('chat').orderBy('createdAt', 'asc').onSnapshot(snapshot => {
        const chat = []
        snapshot.forEach(doc => {
          const message = doc.data()
          message.messageId = doc.id
          chat.push(message)
        })
        this.chat = chat
        setTimeout(this.scrollCC, 250)
      })

      document.addEventListener ('keydown', this.autoFocus)

    },
    beforeUnmount () {
      this.unsubscribeNet()
      this.unsubscribeCheckins()
      this.unsubscribeChat()
      document.removeEventListener ('keydown', this.autoFocus)
    },
    computed: {
      ...mapState(['user', 'isNCS']),
      ...mapGetters(['isAuthed']),
      netStartTime () {
        return 't'
      }
    },
    watch: {
      newCheckinCallsign (callsign) {
        const ucc = callsign.toUpperCase()
        if (callsign !== ucc) {
          this.newCheckinCallsign = ucc
        }
      }
    },
    data () {
      return {
        net: {},
        netId: '',
        checkins: [],
        chat: [],
        newCheckinCallsign: '',
        newChatMessage: ''
      }
    },
    methods: {
      async addCheckin() {
        let checkin
        try {
          const doc = await firestore.collection('callsigns').doc(this.newCheckinCallsign).get()
          checkin = doc.data()
          checkin.callsign = doc.id
        } catch (error) {
          checkin = { callsign: this.newCheckinCallsign }
        }

        checkin.createdAt = new Date()
        this.newCheckinCallsign = ''
        firestore.collection('nets').doc(this.netId).collection('checkins').add(checkin)
        firestore.collection('nets').doc(this.netId).update({checkinCount: increment})
      },
      async addChat() {
        const message = {
          message: this.newChatMessage,
          sender: this.user.callsign,
          createdAt: new Date()
        }
        firestore.collection('nets').doc(this.netId).collection('chat').add(message)
        this.newChatMessage = ''
      },
      async deleteCheckin(checkinId) {
        firestore.collection('nets').doc(this.netId).collection('checkins').doc(checkinId).delete()
      },
      autoFocus (event) {
        if (event.altKey) {
          if (event.key === 'c') {
            this.$refs['chatInput'].focus()
          }
          else if (event.key === 'x') {
            this.$refs['checkinInput'].focus()
          }
        }
      },
      scrollCC () {
        const chat = document.getElementById('chat')
        chat.scrollTop = chat.scrollHeight;        
        const checkins = document.getElementById('checkins')
        checkins.scrollTop = checkins.scrollHeight;        
      },
      formatCheckin(checkin) {
        let r = `${checkin.lineNum} - ${checkin.callsign}`
        if (checkin.firstName) {
          r += ` (${checkin.firstName})`
        }
        if (checkin.checkins) {
          r += ` - ${checkin.checkins} `
        }
        return r
      }
    }

  }
</script>

