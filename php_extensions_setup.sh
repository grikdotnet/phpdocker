#!/bin/sh

#Add system libraries
apt-get update && apt-get install -y --no-install-recommends \
        git libfreetype6-dev  libjpeg62-turbo-dev  libpng12-dev libmagickcore-dev libmagickwand-dev imagemagick libmagick++-dev \
        libmemcached-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
        zlib1g-dev

# Compile basic extensions
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install -j$(nproc) gd
docker-php-ext-install -j$(nproc) mbstring
docker-php-ext-install -j$(nproc) bcmath
docker-php-ext-install -j$(nproc) mysqli
docker-php-ext-install -j$(nproc) xsl
docker-php-ext-install -j$(nproc) iconv

cd /usr/src/

# Compile XDebug from github sources
curl -fSL "https://xdebug.org/files/$XDEBUG_FILENAME" -o "$XDEBUG_FILENAME"
mkdir -p /usr/src/xdebug
tar -xf "$XDEBUG_FILENAME" --strip-components=1 -C /usr/src/xdebug
rm "$XDEBUG_FILENAME"
cd /usr/src/xdebug
phpize && ./configure && make && make install


# Compile Memcached from sources
git clone https://github.com/php-memcached-dev/php-memcached.git \
    && cd php-memcached \
    && git checkout php7 \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make && make install \
    && cd .. && rm -rf php-memcached \
    && docker-php-ext-enable memcached \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
        libmemcached-dev


#Clean up
rm -rf /usr/src/xdebug

rm -rf /var/lib/apt/lists/* \

apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
        libfreetype6-dev  libjpeg62-turbo-dev  libpng12-dev libmagickcore-dev libmagickwand-dev libmagick++-dev \
        libxml2-dev libxslt1-dev zlib1g-dev \
        git
