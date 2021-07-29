FROM node:12.3.1-stretch as builder

RUN apt-get update
RUN apt-get install -y default-jdk-headless
RUN apt-get install -y android-sdk
RUN apt-get install -y imagemagick

RUN cd /tmp && \
  git clone https://github.com/Shadowstyler/android-sdk-licenses.git && \
  cp -a android-sdk-licenses/*-license /usr/lib/android-sdk/licenses && \
  rm -rf android-sdk-licenses

RUN npm i -g @vue/cli cordova
RUN npm i -g cordova-res --unsafe-perm

RUN mkdir -p /cordova
WORKDIR /cordova
RUN cordova create eaglelogger com.eaglelogger.app EagleLogger

WORKDIR /cordova/eaglelogger
RUN cordova telemetry off
RUN cordova platform add android
RUN cordova plugin add cordova-plugin-device
RUN cordova plugin add cordova-plugin-android-permissions
RUN cordova plugin add cordova-plugin-purchase
RUN cordova plugin add cordova-plugin-screen-orientation
RUN cordova plugin add cordova-plugin-whitelist
RUN cordova build; exit 0

RUN mkdir -p /dist # mounted volume
RUN mkdir -p /secret # mounted volume
RUN mkdir -p /app/src # mounted volume
RUN mkdir -p /app/public # mounted volume

WORKDIR /app
COPY ./app/package.json .
COPY ./app/package-lock.json .
RUN npm ci

COPY ./app/babel.config.js .
COPY ./app/vue.config.js .

WORKDIR /cordova/birder

COPY ./build/build-app /bin/
COPY ./build/build-apk /bin/
COPY ./build/build-resources /bin/
COPY ./build/build-cordova-ios /bin/
