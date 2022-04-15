FROM nginx:stable-alpine

ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf
ADD ./nginx/certs /etc/nginx/certs/self-signed

RUN apk update

# RUN chown -R nginx:nginx /usr/share/nginx/html
# RUN chmod -R 755 /usr/share/nginx/html
