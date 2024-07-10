FROM node:20-alpine3.17

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app
COPY * /usr/src/app
RUN npm install

CMD node server.js
EXPOSE 3000

