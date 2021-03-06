# docker build -f events.Dockerfile -t grigori/phpextensions:7.3-events .
FROM php:7.3-zts-alpine

LABEL Description="This image provides PHP 7.3 fpm and cli with common extensions https://hub.docker.com/r/grigori/phpextensions"
MAINTAINER Grigori Kochanov public@grik.net

ARG EVENT_VER=event-2.5.3
ARG EV_VER=ev-1.0.6

# allow editing php config files in the mounted volume
COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# install build environment
RUN apk add --no-cache gettext icu-libs libevent gnu-libiconv \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils \
        libressl-dev icu-dev gettext-dev libevent-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext sockets pcntl mysqli pdo_mysql \
# make sockets extension load first
    && cd /usr/local/etc/php/conf.d/ && mv docker-php-ext-sockets.ini 1-docker-php-ext-sockets.ini \
    && cd /usr/src \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes no| pecl install ds sync igbinary xdebug swoole \
    && pecl download $EVENT_VER $EV_VER \
        && tar -xf $EVENT_VER.tgz && cd $EVENT_VER && phpize \
            && ./configure --with-event-core --with-event-pthreads --with-event-extra --with-event-openssl \
            && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf $EV_VER.tgz && cd $EV_VER && phpize && ./configure && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable ds sync event ev swoole \
# cleanup
    && apk del ext-dev-dependencies \
    && rm -rf event* ev* /tmp/pear ~/.pearrc \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl

# Fix iconv lib
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]