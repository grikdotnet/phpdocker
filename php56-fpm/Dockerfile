FROM php:5.6-fpm-alpine

# allow editing php config files in the mounted volume
VOLUME /usr/local/etc
COPY docker-php-entrypoint /usr/local/bin/

# install build environment
RUN apk add --no-cache openssl freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev icu-dev postgresql-dev cyrus-sasl-dev \
        openssl-dev libxml2-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libmemcached-dev zlib-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext iconv mysqli pdo_mysql pdo_pgsql \
# build standard extensions
    && docker-php-ext-configure gd  --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/   --enable-gd-native-ttf --with-zlib-dir \
    && docker-php-ext-install -j$CPU_COUNT gd \
    && docker-php-ext-enable opcache \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes | pecl install apcu-4.0.11 igbinary xdebug \
    && pecl download redis memcached-2.2.0 \
        && tar -xf redis* && cd redis* && phpize && ./configure --enable-redis-igbinary && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf memcached* && cd memcached* && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable igbinary apcu redis memcached xdebug \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.off \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl \
# create a default php.ini file to edit it in a mouted volume
    && docker-php-source extract && cp /usr/src/php/php.ini-development /usr/local/etc/php/php.ini \
# back up the default ini files
    && cp -R /usr/local/etc/ /usr/src/ \
# cleanup
    && apk del ext-dev-dependencies \
    && docker-php-source delete \
    && rm -rf redis* memcached* /tmp/pear \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint

ENTRYPOINT ["docker-php-entrypoint"]