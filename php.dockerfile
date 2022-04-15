FROM php:8.1.4-fpm-alpine3.15

RUN apk update

RUN touch /var/log/error_log

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 wp && adduser -G wp -g wp -s /bin/sh -D wp

RUN mkdir -p /usr/share/nginx/html

RUN chown -R wp:wp /usr/share/nginx/html

RUN chown wp:wp /var/log/error_log

WORKDIR /usr/share/nginx/html

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# RUN chown -R nginx:nginx /var/www
# RUN chmod -R 755 /var/www
