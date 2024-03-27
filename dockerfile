FROM node:14
WORKDIR /usr/src/app
COPY . .
RUN npm install
EXPOSE 3000
ENV NAME World
CMD ["npm", "start"]
