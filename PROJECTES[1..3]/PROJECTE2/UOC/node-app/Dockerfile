FROM node:20-alpine3.17
RUN mkdir -p /usr/src/app
COPY * /usr/src/app
WORKDIR /usr/src/app
RUN npm install
#RUN node /usr/src/app/server.js
CMD node server.js
EXPOSE 3000
EXPOSE 5000

