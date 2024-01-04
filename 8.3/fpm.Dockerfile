# Build with a command
# docker build -f fpm.Dockerfile -t grigori/phpextensions:8.3-fpm .

# See compose.yaml to start in a docker compose or swarm

# A single container example:
# docker run -d -e XDEBUG_MODE=debug --mount type=bind,source="$(pwd)"/etc,target=/usr/local/etc grikdotnet/phpextensions-8.3-fpm

FROM php:8.3.1-fpm-bookworm

LABEL Description="PHP 8.3 FPM + CLI with common extensions https://hub.docker.com/r/grigori/phpextensions"
MAINTAINER Grigori Kochanov public@grik.net

# Here is a great project https://github.com/mlocati/docker-php-extension-installer used to build extensions
RUN  curl -L -s -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && IPE_ICU_EN_ONLY = IPE_GD_WITHOUTAVIF = 1; \
     install-php-extensions \
        bcmath \
        gettext \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        pspell \
        zip \
        ds \
        igbinary \
        redis \
        memcached \
        gd \
        @composer \
# add xdebug extension, but don't enable it
    && pecl install xdebug \
# add browscap
    && curl -o /usr/local/lib/php/lite_php_browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI \
    && echo "browscap = /usr/local/lib/php/lite_php_browscap.ini" > /usr/local/etc/php/conf.d/docker-php-browscap.ini \
# opcache extension is already in the base image, just use it
    && docker-php-ext-enable opcache

COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# make the entrypoint
RUN chmod a+x /usr/local/bin/docker-php-entrypoint \
    && mkdir /docker-entrypoint-init.d/ \
    && cp -r /usr/local/etc/ /usr/local/etc.bak

# Force PHP FPM to run non-daemonized
CMD ["-F"]
