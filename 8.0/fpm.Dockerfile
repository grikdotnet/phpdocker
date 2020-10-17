# docker build -f fpm.Dockerfile -t grigori/phpextensions:7.3-fpm .
FROM php:8.0-rc-fpm-alpine

LABEL Description="This image provides PHP 8.0 fpm and cli with common extensions https://hub.docker.com/r/grigori/phpextensions"
MAINTAINER Grigori Kochanov public@grik.net

# allow editing php config files in the mounted volume
COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# install build environment
RUN apk add --no-cache freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs aspell-libs libzip gnu-libiconv \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev icu-dev \
        postgresql-dev cyrus-sasl-dev libxml2-dev libmemcached-dev aspell-dev libzip-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
    && export CPU_COUNT=$(grep -c processor /proc/cpuinfo) \
    && cd /usr/src/ \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext mysqli pdo_mysql pdo_pgsql pgsql pspell zip \
# build standard extensions with options
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$CPU_COUNT gd \
    && docker-php-ext-enable opcache \
# install pickle and docker-php-extension-installer that replace PECL for PHP8
    && wget -O /usr/local/bin/pickle https://github.com/FriendsOfPHP/pickle/releases/latest/download/pickle.phar \
    && wget -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    && chmod u+x /usr/local/bin/pickle /usr/local/bin/install-php-extensions \
# build and install extensions
    && pickle install ds \
    && install-php-extensions igbinary xdebug redis memcached \
# cleanup
    && apk del ext-dev-dependencies \
    && rm -rf redis* memcached* /tmp/pear \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
    && mkdir /docker-entrypoint-init.d/ \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl

# Fix iconv lib
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]
