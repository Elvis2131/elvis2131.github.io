## Stage 1
#Pulling the alpine image for building the application.
FROM node:alpine as builder
WORKDIR /app
COPY package.json .
COPY yarn.lock .
# RUN apk add --no-cache git
RUN yarn install && yarn global add typescript
COPY . .
RUN yarn build
## Stage 2
# Running the application using pm2.
FROM node:alpine
#Creating a user to run the application.
ARG USER=pragma
ENV HOME /home/$USER
WORKDIR /app
COPY package.json .
RUN yarn install --only=production
COPY --from=builder /app/dist .
#Granting the created user ownership of the working directory.
RUN adduser -D $USER && chown $USER:$USER .
RUN yarn global add pm2
ENV DB_QUERY_STRING='ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@pragma-cosmosdb@'
#Switching to the created user
USER $USER
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000 || exit 1
  
CMD ["pm2-runtime", "index.js"]