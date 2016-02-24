#!/bin/sh

# variables $PHP_INI_DIR, $PHP_VERSION, $PHP_FILENAME are defined in the parent Dockerfile (php:7-fpm image)

#Add common system libraries
apt-get update && apt-get install -y --no-install-recommends \
        libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
        libmemcached11 libmemcachedutil2 libmemcached-dev \
        libssl-dev libcurl4-openssl-dev libreadline6-dev \
        zlib1g-dev libbz2-dev xz-utils lbzip2 git \
        postgresql-server-dev-9.4 libpq5

# opcache.so is already in the image, just add it to php.ini
docker-php-ext-enable opcache

# Build base extensions

docker-php-ext-install -j$(nproc) mbstring
docker-php-ext-install -j$(nproc) bcmath
docker-php-ext-install -j$(nproc) mysqli
docker-php-ext-install -j$(nproc) xsl
docker-php-ext-install -j$(nproc) iconv
docker-php-ext-install -j$(nproc) pdo_mysql
docker-php-ext-install -j$(nproc) pgsql
docker-php-ext-install -j$(nproc) pdo_pgsql

pecl install SPL_Types
docker-php-ext-enable spl_types

# Compile XDebug from github sources
cd /usr/src/
curl -fSL "https://xdebug.org/files/$XDEBUG_FILENAME" -o "$XDEBUG_FILENAME"
mkdir /usr/src/xdebug
tar -xf "$XDEBUG_FILENAME" --strip-components=1 -C /usr/src/xdebug
rm "$XDEBUG_FILENAME"
cd xdebug
phpize && ./configure && make -j"$(nproc)" && make install
docker-php-ext-enable xdebug

# Compile Memcached from sources
cd /usr/src/
git clone https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
git checkout php7
phpize && ./configure --disable-memcached-sasl && make -j"$(nproc)" && make install
docker-php-ext-enable memcached


# Generate a CLI version with SHM and PCNTL
cd $PHP_SOURCE_PATH
./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --with-fpm-user=www-data --with-fpm-group=www-data \
    --disable-cgi --enable-ftp --with-zlib --enable-mysqlnd --with-readline --with-openssl --with-curl \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-shmop --enable-posix --without-pear --enable-pcntl

make -j"$(nproc)" && make install && make clean

#Clean up
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
    libbz2-dev libcurl4-openssl-dev libhashkit-dev libmemcached-dev libreadline6-dev libsasl2-dev libssl-dev \
    libtinfo-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libpq-dev init-system-helpers postgresql-client-common postgresql-common postgresql-server-dev-9.4 ssl-cert ucf \
    git

rm -rf /var/lib/apt/lists/*
rm -rf /usr/src/xdebug /usr/src/php-memcached
