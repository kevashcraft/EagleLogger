FROM node:14.15.5-buster-slim

RUN npm i -g @vue/cli

RUN mkdir -p /app
RUN chown 1000:1000 /app

RUN mkdir -p /secret
RUN chown 1000:1000 /secret

USER 1000
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY babel.config.js ./
COPY vue.config.js ./

CMD ["npm", "run", "serve"]
