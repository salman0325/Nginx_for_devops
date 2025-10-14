FROM nginx:latest

WORKDIR /app

COPY . /usr/share/nginx/html

EXPOSE 7000

CMD ["nginx", "-g", "daemon off;"]

