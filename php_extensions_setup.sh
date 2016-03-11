#!/bin/sh

# variables $PHP_INI_DIR, $PHP_VERSION, $PHP_FILENAME are defined in the parent Dockerfile (php:7-fpm image)

#Add common system libraries
apt-get update && apt-get install --no-install-recommends -y \
        libxml2-dev libxslt1-dev \
        libmemcached11 libmemcachedutil2 libmemcached-dev \
        libssl-dev libcurl4-openssl-dev libreadline6-dev libgeoip-dev \
        libc-client2007e-dev libkrb5-dev \
        postgresql-server-dev-9.* libpq5 \
        libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libwebp-dev \
        zlib1g-dev libbz2-dev xz-utils


# opcache.so is already in the image, just add it to php.ini
docker-php-ext-enable opcache

# Build base extensions
sh -c "docker-php-ext-install bcmath mysqli xsl mbstring" &
sh -c "docker-php-ext-install pdo_mysql pdo_pgsql pgsql" &
sh -c "docker-php-ext-configure imap --without-kerberos --with-imap-ssl && docker-php-ext-install imap" &
sh -c "docker-php-ext-configure gd  --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ --with-png-dir=/usr/include/   --enable-gd-native-ttf --with-zlib-dir \
    && docker-php-ext-install gd " &

# Compile PECL extensions
pear config-set preferred_state beta
echo no| pecl install ev
echo no| pecl install apcu
echo no| pecl install msgpack

# Download archives
mkdir /usr/src/ext
cd /usr/src/ext
curl -L https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz -o php7-memcached.tgz \
 -L https://github.com/igbinary/igbinary/archive/php7-dev-playground2.tar.gz -o php7-igbinary.tgz \
 -L https://github.com/edtechd/phpredis/archive/php7.tar.gz -o php7-redis.tgz \
 -L https://github.com/php-ds/extension/archive/master.tar.gz -o php-ds.tgz
curl -O https://xdebug.org/files/xdebug-2.4.0rc4.tgz

for a in *.tgz
do
    a_dir=$(expr $a : '\(.*\).tgz')
    mkdir -p $a_dir
    tar -xzf $a -C $a_dir --strip 1 && rm $a
done

# Compile XDebug from github sources
sh -c "cd xdebug* && phpize && ./configure && make && make install  && docker-php-ext-enable xdebug" &

# Compile Data Structures extension
sh -c "cd php-ds/ && phpize && ./configure && make && make install && docker-php-ext-enable ds" &

# Compile igbinary extension
sh -c "cd php7-igbinary/ && phpize && ./configure && make && make install && docker-php-ext-enable igbinary"
echo 'session.serialize_handler = igbinary' >>  $PHP_INI_DIR/conf.d/docker-php-ext-igbinary.ini

# Compile Redis extension
sh -c "cd php7-redis/ && phpize && ./configure --enable-redis-igbinary && make && make install && docker-php-ext-enable redis" &

# Compile Memcached from sources
sh -c "cd php7-memcached/ && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make && make install && docker-php-ext-enable memcached "
echo 'session.save_path = "memcached:11211"' >>  $PHP_INI_DIR/conf.d/docker-php-ext-memcached.ini
echo 'session.save_handler = memcached' >>  $PHP_INI_DIR/conf.d/docker-php-ext-memcached.ini

# Set up composer
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin

# Generate a CLI version with SHM, PCNTL and ZTS for pthreads
cd $PHP_SOURCE_PATH
./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --disable-cgi --enable-ftp --with-zlib --enable-mysqlnd --with-readline --with-openssl --with-curl \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-shmop --enable-posix --without-pear --enable-pcntl \
  && make -j"$(nproc)" && make install && make distclean

#Clean up
apt-get purge -y \
    libssl-dev libcurl4-openssl-dev libgeoip-dev libhashkit-dev libmemcached-dev libreadline6-dev libsasl2-dev libtinfo-dev \
    comerr-dev* libxml2-dev libxslt1-dev \
    libc-client2007e-dev krb5-multidev* libkrb5-dev libkadm5* libkdb5* libpam0g-dev \
    libpq-dev init-system-helpers postgresql-client-common postgresql-common postgresql-server-dev-9.* \
    init-system-helpers postgresql-common ssl-cert ucf \
    libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libwebp-dev libjbig-dev \
    zlib1g-dev libbz2-dev


rm -rf /var/lib/apt/lists/* /usr/src/ext /tmp/* /var/tmp/*
