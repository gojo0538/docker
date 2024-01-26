FROM node:16-alpine as build-step

WORKDIR /app

COPY package*.json /app/

RUN npm install --legacy-peer-deps

COPY ./ /app/

RUN npm run build:qa

# production environment

FROM nginx:1.21.6-alpine

COPY --from=build-step /app/build/ /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

#COPY ./nginx.conf /etc/nginx/conf.d

COPY --from=build-step /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


