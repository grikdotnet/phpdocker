# docker build -f fpm.Dockerfile -t grigori/phpextensions:7.3-fpm .
FROM php:7.4-fpm-alpine

LABEL Description="This image provides PHP-fpm 7.4 with common extension"
MAINTAINER Grigori Kochanov public@grik.net

# allow editing php config files in the mounted volume
COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# install build environment
RUN apk add --no-cache freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs aspell-libs libzip gnu-libiconv \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev icu-dev \
        postgresql-dev cyrus-sasl-dev libxml2-dev libmemcached-dev aspell-dev libzip-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && cd /usr/src/ \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext mysqli pdo_mysql pdo_pgsql pgsql pspell zip \
# build standard extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$CPU_COUNT gd \
    && docker-php-ext-enable opcache \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes no| pecl install igbinary ds xdebug \
    && pecl download redis memcached \
        && tar -xf redis* && cd redis* && phpize && ./configure --enable-redis-igbinary && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf memcached* && cd memcached* && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable igbinary redis memcached ds \
# add browscap.ini
    && wget -O /usr/local/lib/php/lite_php_browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI \
    && echo "browscap = /usr/local/lib/php/lite_php_browscap.ini" > /usr/local/etc/php/conf.d/docker-php-browscap.ini \
# cleanup
    && apk del ext-dev-dependencies \
    && rm -rf redis* memcached* /tmp/pear \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
    && mkdir /docker-entrypoint-init.d/ \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl

# Fix iconv lib
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]