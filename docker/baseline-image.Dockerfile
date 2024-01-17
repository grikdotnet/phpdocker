# See ../docker-compose.yaml to run with a docker compose

# To run a single container with XDEBUG:
# docker run -d -e XDEBUG_MODE=debug --mount type=bind,source="$(pwd)"/etc,target=/usr/local/etc organization/imagename:tag

FROM php:8.3.1-fpm-bookworm

LABEL Description="PHP 8.3 FPM https://hub.docker.com/r/grigori/php-baseline"
MAINTAINER Grigori Kochanov public@grik.net

# Here is a great project https://github.com/mlocati/docker-php-extension-installer to add extensions to docker images
RUN  curl -L -s -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && IPE_ICU_EN_ONLY=1 && IPE_GD_WITHOUTAVIF=1 && install-php-extensions \
        bcmath \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        zip \
        ds \
        igbinary \
        redis \
        memcached \
        gd \
        @composer \
# add xdebug extension, but don't enable it
    && pecl install xdebug \
# opcache extension is already in the base image, just use it
    && docker-php-ext-enable opcache

COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

# make the entrypoint
RUN chmod a+x /usr/local/bin/docker-php-entrypoint \
    && mkdir /docker-entrypoint-init.d/ \
    && cp -r /usr/local/etc/ /usr/local/etc.bak

# Force PHP FPM to run non-daemonized
CMD ["-F"]
