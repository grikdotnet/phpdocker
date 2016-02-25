#!/bin/sh

# variables $PHP_INI_DIR, $PHP_VERSION, $PHP_FILENAME are defined in the parent Dockerfile (php:7-fpm image)

#Add common system libraries
apt-get update && apt-get install --no-install-recommends -y \
        libxml2-dev libxslt1-dev \
        libmemcached11 libmemcachedutil2 libmemcached-dev \
        libssl-dev libcurl4-openssl-dev libreadline6-dev libgeoip-dev libgeoip1 \
        libc-client2007e-dev libkrb5-dev \
        postgresql-server-dev-9.* libpq5 \
        zlib1g-dev libbz2-dev xz-utils lbzip2 unzip


# opcache.so is already in the image, just add it to php.ini
docker-php-ext-enable opcache

# Build base extensions
sh -c "docker-php-ext-install bcmath" &
sh -c "docker-php-ext-install mysqli" &
sh -c "docker-php-ext-install xsl" &
sh -c "docker-php-ext-install pgsql" &
sh -c "docker-php-ext-install pdo_pgsql" &
sh -c "docker-php-ext-install mbstring" &
sh -c "docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap" &

# Compile PECL extensions
pear config-set preferred_state beta
sh -c "echo no| pecl install ev" &
sh -c "echo no| pecl install apcu" &

# Download archives
mkdir /usr/src/ext
cd /usr/src/ext
curl -L https://github.com/php-memcached-dev/php-memcached/archive/php7.zip -o php7-memcached.zip
curl -L https://github.com/igbinary/igbinary/archive/php7-dev-playground2.zip -o php7-igbinary.zip
curl -L https://github.com/edtechd/phpredis/archive/php7.zip -o php7-redis.zip
curl -O https://xdebug.org/files/xdebug-2.4.0rc4.tgz

unzip php7-memcached.zip
unzip php7-redis.zip
unzip php7-igbinary.zip
tar -xf xdebug-2.4.0rc4.tgz


# Compile XDebug from github sources
cd /usr/src/ext/xdebug-2.4.0RC4 && phpize && ./configure && make && make install \
    && docker-php-ext-enable xdebug

# Compile Memcached from sources
cd /usr/src/ext/php-memcached-php7 && phpize && ./configure --disable-memcached-sasl && make && make install \
    && docker-php-ext-enable memcached


# Compile igbinary extension
cd /usr/src/ext/igbinary-php7-dev-playground2 && phpize && ./configure && make -j"$(nproc)" && make install \
    && docker-php-ext-enable igbinary

# Compile Redis extension
cd /usr/src/ext/phpredis-php7 && phpize && ./configure && make -j"$(nproc)" && make install \
    && docker-php-ext-enable redis

# Generate a CLI version with SHM, PCNTL and ZTS for pthreads
cd /usr/src/php
./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --with-fpm-user=www-data --with-fpm-group=www-data \
    --disable-cgi --enable-ftp --with-zlib --enable-mysqlnd --with-readline --with-openssl --with-curl \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-shmop --enable-posix --without-pear --enable-pcntl
make -j"$(nproc)" && make install && make clean


#Clean up
apt-get purge -y \
    libssl-dev libcurl4-openssl-dev libgeoip-dev libhashkit-dev libmemcached-dev libreadline6-dev libsasl2-dev libtinfo-dev \
    libpython* comerr-dev* krb5-multidev* \
    libxml2-dev libxslt1-dev \
    libc-client2007e-dev libkrb5-dev libpam0g-dev \
    libpq-dev init-system-helpers postgresql-client-common postgresql-common postgresql-server-dev-9.* \
    init-system-helpers postgresql-common ssl-cert ucf \
    zlib1g-dev libbz2-dev


rm -rf /var/lib/apt/lists/* /usr/src/ext /tmp/*
