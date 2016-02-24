#!/bin/sh

# variables $PHP_INI_DIR, $PHP_VERSION, $PHP_FILENAME are defined in the parent Dockerfile (php:7-fpm image)

#Add common system libraries
apt-get update && apt-get install -y --no-install-recommends \
        libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
        libmemcached11 libmemcachedutil2 libmemcached-dev \
        libssl-dev libcurl4-openssl-dev libreadline6-dev libgeoip-dev libgeoip1 \
        libc-client2007e libkrb5-3 libc-client2007e-dev libkrb5-dev \
        zlib1g-dev libbz2-dev xz-utils lbzip2 git wget

# opcache.so is already in the image, just add it to php.ini
docker-php-ext-enable opcache

# Build base extensions

docker-php-ext-install -j$(nproc) mbstring
docker-php-ext-install -j$(nproc) bcmath
docker-php-ext-install -j$(nproc) mysqli
docker-php-ext-install -j$(nproc) xsl
docker-php-ext-install -j$(nproc) iconv
docker-php-ext-install -j$(nproc) pdo_mysql
docker-php-ext-configure imap --with-kerberos --with-imap-ssl
docker-php-ext-install imap

# Build Postgres extensions
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  apt-key add -
apt-get update && apt-get install -y --no-install-recommends postgresql-server-dev-9.5 libpq5
docker-php-ext-install -j$(nproc) pgsql
docker-php-ext-install -j$(nproc) pdo_pgsql


# Compile XDebug from github sources
cd /usr/src/
wget https://xdebug.org/files/xdebug-2.4.0rc4.tgz
mkdir /usr/src/xdebug
tar -xf xdebug-2.4.0rc4.tgz --strip-components=1 -C /usr/src/xdebug
rm xdebug-2.4.0rc4.tgz
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


# Generate a CLI version with SHM, PCNTL and ZTS for pthreads
cd $PHP_SOURCE_PATH
./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --with-fpm-user=www-data --with-fpm-group=www-data \
    --disable-cgi --enable-ftp --with-zlib --enable-mysqlnd --with-readline --with-openssl --with-curl \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-shmop --enable-posix --without-pear --enable-pcntl
make -j"$(nproc)" && make install && make clean

# Compile PECL extensions
pear config-set preferred_state beta
echo no| pecl install ev
echo no| pecl install apcu


#Clean up
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
    libbz2-dev libcurl4-openssl-dev libhashkit-dev libmemcached-dev libreadline6-dev libsasl2-dev libssl-dev \
    libtinfo-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libc-client2007e-dev libkrb5-dev \
    libpq-dev init-system-helpers postgresql-client-common postgresql-common postgresql-server-dev-9.5 ssl-cert ucf \
    git

rm -rf /var/lib/apt/lists/* /usr/src/xdebug /usr/src/php-memcached /tmp/*
