FROM nginx:stable-alpine

ARG NGINX_CONF=./nginx.conf

RUN sed -i '1idaemon off;' /etc/nginx/nginx.conf

COPY ${NGINX_CONF} /etc/nginx/conf.d/default.conf

CMD ["nginx"]
