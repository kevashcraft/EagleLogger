import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate('/secret/eaglelogger-194300-8b40e4cabb21.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

for doc in db.collection(u'nets').where(u'active', u'==', True).get():
  db.collection(u'nets').document(doc.id).update({'active': False})

