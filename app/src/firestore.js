import firebase from 'firebase/app'
import 'firebase/firestore'

const firebaseConfig = {
    apiKey: 'AIzaSyCa1ICgaR4u-iSow5WrpZ_RcNePOr_tEMk',
    authDomain: 'eaglelogger-194300.firebaseapp.com',
    databaseURL: 'https://eaglelogger-194300.firebaseio.com',
    projectId: 'eaglelogger-194300',
    storageBucket: 'eaglelogger-194300.appspot.com',
    messagingSenderId: '647452022142',
    appId: '1:647452022142:web:e35f1c3be5d39f212e0f2f'
}

firebase.initializeApp(firebaseConfig)

export default firebase.firestore()
