<template>
  <v-container fluid style="height: 100%; padding: 0; overflow-y: scroll">
    <v-card flat color="blue darken-3" class="v-card-parent" style="margin: 35px auto; max-width: 650px">
      <v-card-text>
        <v-card class="v-card-child">
          <v-card-title><h3>More Info About EagleLogger</h3></v-card-title>
          <v-card-text class="std-txt">
            <p>EagleLogger is a cross-platform tool used to log checkins on amateur radio nets.</p>
            <p>It's backed by a Firestore NoSQL-style database that's populated with the <a href="https://www.fcc.gov/uls/transactions/daily-weekly?job=transaction&page=weekly" title="FCC ULS Daily & Weekly Transaction Files" target="_blank">FCC ULS Transaction Files</a>.</p>
          </v-card-text>
        </v-card>
      </v-card-text>
    </v-card>
    <div class="copyright-info">
      <v-row justify-space-between style="margin: 0">
        <v-col class="d-flex align-end" style="padding: 0 5px">
          Copyright &copy; 2021 <a style="margin-left: 3px" href="https://www.km4fpa.com" target="_blank">Kevin Ashcraft (KM4FPA)</a>
        </v-col>
        <v-row class="flex-column align-end justify-center flex-grow-0" style="margin: 0">
          <span><a href="https://eaglelogger.com/licenses" target="_blank">Licenses</a></span>
          <span><a href="https://eaglelogger.com/privacy-policy" target="_blank">Privacy Policy</a></span>
          <span><a href="https://eaglelogger.com/terms-of-service" target="_blank">Terms and Conditions</a></span>
        </v-row>
      </v-row>
    </div>
  </v-container>
</template>

<style lang="scss" scoped>
.std-txt {
  font-size: 21px;
  font-weight: 400;
  line-height: 28px;

}
.copyright-info {
  font-size: 12px;
  margin: 65px auto;
  @media (max-width: 800px) {
    margin: 0 10px 25px 5px;
  }
}
</style>

<script>
  export default {
    data () {
      return {
        nets: [],
      }
    }
  }
</script>
