FROM php:7.2-zts-alpine

# allow editing php config files in the mounted volume
COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# install build environment
RUN apk add --no-cache freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs libzip gnu-libiconv \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev git \
        icu-dev postgresql-dev cyrus-sasl-dev libxml2-dev freetype-dev \
        libjpeg-turbo-dev libpng-dev libwebp-dev libmemcached-dev libzip-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && docker-php-ext-install -j$CPU_COUNT pcntl bcmath gettext mysqli pdo_mysql pdo_pgsql pgsql zip \
# build standard extensions
    && docker-php-ext-configure gd  --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ --with-png-dir=/usr/include/ --with-zlib-dir \
    && docker-php-ext-install -j$CPU_COUNT gd \
    && docker-php-ext-enable opcache \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes no| pecl install igbinary xdebug \
    && pecl download redis memcached \
        && tar -xf redis* && cd redis* && phpize && ./configure --enable-redis-igbinary && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf memcached* && cd memcached* && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable igbinary redis memcached xdebug \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.off \
# build pthreads from github
    && git clone https://github.com/krakjoe/pthreads && cd pthreads/ \
        && phpize && ./configure && make && make install \
        && echo "extension=pthreads" > /usr/local/etc/php/conf.d/docker-php-ext-pthreads.ini \
# cleanup
    && apk del ext-dev-dependencies \
    && rm -rf redis* memcached* pthreads /tmp/pear ~/.pearrc \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl

# Fix iconv lib
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]