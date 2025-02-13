FROM node:18.19.1-alpine as build
WORKDIR /app

RUN npm install -g @angular/cli

COPY ./package.json .
RUN npm install 
RUN cat package-lock.json
COPY . .
RUN npm run build

FROM nginx:alpine as runtime
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist/demo-angular-docker/browser /usr/share/nginx/html

EXPOSE 80 443
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]