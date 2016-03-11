FROM php:7-fpm

LABEL Description="This image provides PHP-fpm with common extensions"
MAINTAINER Grigori Kochanov <public@grik.net>

# php source code path is hardcoded in the parent Dockerfile
ENV PHP_SOURCE_PATH /usr/src/php

ADD php_extensions_setup.sh /php_extensions_setup.sh
ADD php.ini /usr/local/etc/php/php.ini

RUN ["/bin/sh", "/php_extensions_setup.sh"]

RUN mkdir /var/tmp/upload /var/sessions \
    && cp -R /usr/local/etc/ /usr/local/etc-init

CMD test "$(ls -A /usr/local/etc/php* 2>/dev/null)" || cp -R /usr/local/etc-init/* /usr/local/etc/