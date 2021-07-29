import os
import wget
from tqdm import tqdm
from zipfile import ZipFile
from datetime import datetime

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

#  if not os.path.isdir('fcc_database'):
#    print('Downloading FCC Database')
#    os.mkdir('fcc_database')
#    wget.download('ftp://wirelessftp.fcc.gov/pub/uls/complete/l_amat.zip', out='fcc_database')
#    print()
#    print('Extracting..')
#    with ZipFile('fcc_database/l_amat.zip', 'r') as zipfile:
#      zipfile.extractall('fcc_database')
# 0=MONDAY
# but, download 3 days before
# so on Monday, download Friday
# on Thursday, Monday
days = ['fri', 'sat', 'sun', 'mon', 'tue', 'wed', 'thu']
day = days[datetime.today().weekday()]

if not os.path.isdir('fcc_database/{}'.format(day)):
  print('Downloading FCC MONDAY Database')
  os.mkdir('fcc_database/{}'.format(day))
wget.download('ftp://wirelessftp.fcc.gov/pub/uls/daily/l_am_{}.zip'.format(day), out='fcc_database/{}'.format(day))
print()
print('Extracting..')
with ZipFile('fcc_database/{}/l_am_{}.zip'.format(day, day), 'r') as zipfile:
  zipfile.extractall('fcc_database/{}'.format(day))


print('Processing HD.dat')
with open('fcc_database/{}/HD.dat'.format(day)) as file:
  HDarr = [l.split('|') for l in file.read().splitlines()]

print('Processing EN.dat')
with open('fcc_database/{}/EN.dat'.format(day)) as file:
  ENarr = [l.split('|') for l in file.read().splitlines()]

print('Filtering..')
now = datetime.now()

def is_granted(i):
  try:
    d = datetime.strptime(i[7], '%m/%d/%Y')
    if d <= now: return True
  except:
    pass
  return False

HDarrgranted = list(filter(is_granted, HDarr))

def is_active(i):
  try:
    d = datetime.strptime(i[8], '%m/%d/%Y')
    if d < now: return False
  except:
    pass
  try:
    d = datetime.strptime(i[9], '%m/%d/%Y')
    if d < now: return False
  except:
    pass
  return True

active = list(filter(is_active, HDarrgranted))

# # ULSnums = [ i[2] for i in active]

# # ULSnumcounts = {}
# # for ulsn in ULSnums:
# #   try:
# #     ULSnumcounts[ulsn] += 1
# #   except:
# #     ULSnumcounts[ulsn] = 1

# # ULSCA = dict(filter(lambda x: x[1] > 1, ULSnumcounts.items()))

enlookup = {}
for i in ENarr:
  enlookup[i[1]] = i

print('Aggregating')
callsigns = {}
for i in active:
  try:
    callsigns[i[4]] = (enlookup[i[1]][8], enlookup[i[1]][10])
  except:
    print('aa', i)

# print('caka', callsigns['KM4FPA'])

cred = credentials.Certificate('/secret/eaglelogger-194300-8b40e4cabb21.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

idx = 0
tc = 0
batch = db.batch()
print('commiting 55', len(callsigns))
for callsign, info in tqdm(callsigns.items()):
  data = {
    u'firstName': info[0],
    u'lastName': info[1]
  }
  batch.set(db.collection(u'callsigns').document(callsign), data)
  idx += 1
  tc += 1
  if idx == 500:
    idx = 0
    print('commiting', tc, len(callsigns))
    batch.commit()
batch.commit()
