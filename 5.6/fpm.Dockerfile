FROM php:5.6-fpm-alpine

# allow editing php config files in the mounted volume
COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# install build environment
RUN apk add --no-cache freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs libzip \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev icu-dev postgresql-dev cyrus-sasl-dev \
        libxml2-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libmemcached-dev zlib-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext mysqli pdo_mysql pdo_pgsql pgsql \
# build standard extensions
    && docker-php-ext-configure gd  --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/   --enable-gd-native-ttf --with-zlib-dir \
    && docker-php-ext-install -j$CPU_COUNT gd zip \
    && docker-php-ext-enable opcache \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes | pecl install igbinary-2.0.8 xdebug-2.5.5 \
    && pecl download redis-4.3.0 memcached-2.2.0 \
        && tar -xf redis* && cd redis* && phpize && ./configure --enable-redis-igbinary && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf memcached* && cd memcached* && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable igbinary redis memcached \
    && wget -O /usr/local/lib/php/lite_php_browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI \
    && echo "browscap = /usr/local/lib/php/lite_php_browscap.ini" > /usr/local/etc/php/conf.d/docker-php-browscap.ini \
# cleanup
    && docker-php-source delete \
    && apk del ext-dev-dependencies \
    && rm -rf redis* memcached* /tmp/pear \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
    && mkdir /docker-entrypoint-init.d/ \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]
