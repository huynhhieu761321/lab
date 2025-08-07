FROM nginx:alpine

COPY apps/base/index.html /usr/share/nginx/html/index.html

EXPOSE 80
