FROM php:7.2-fpm-alpine

# install build environment
RUN apk add --no-cache openssl freetype libjpeg-turbo libpng libwebp gettext icu-libs libmemcached postgresql-libs \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils gettext-dev icu-dev postgresql-dev cyrus-sasl-dev \
         libxml2-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libmemcached-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && docker-php-ext-install -j$CPU_COUNT bcmath gettext iconv mysqli pdo_mysql pdo_pgsql pgsql \
# build standard extensions
    && docker-php-ext-configure gd  --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ --with-png-dir=/usr/include/   --enable-gd-native-ttf --with-zlib-dir \
    && docker-php-ext-install -j$CPU_COUNT gd \
    && docker-php-ext-enable opcache \
# build and install PECL extensions
    && pecl channel-update pecl.php.net \
    && yes no| pecl install apcu igbinary xdebug \
    && pecl download redis memcached \
        && tar -xf redis* && cd redis* && phpize && ./configure --enable-redis-igbinary && make -j$CPU_COUNT && make install && cd .. \
        && tar -xf memcached* && cd memcached* && phpize && ./configure --disable-memcached-sasl --enable-memcached-igbinary && make -j$CPU_COUNT && make install && cd .. \
    && docker-php-ext-enable igbinary apcu redis memcached xdebug \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.off \
# create a default php.ini file to edit it in a mouted volume
    && docker-php-source extract && cp /usr/src/php/php.ini-development /usr/local/etc/php/php.ini \
# back up the default ini files
    && cp -R /usr/local/etc/ /usr/src/ \
# cleanup
    && docker-php-source delete \
    && apk del ext-dev-dependencies \
    && rm -rf redis* memcached* /tmp/pear \
# make the entrypoint executable
    && chmod a+x /usr/local/bin/docker-php-entrypoint \
# restrict console commands execution for web scripts
    && chmod o-rx /bin/busybox /usr/bin/curl /usr/local/bin/pecl \
# Imagemagick
    && apk add --no-cache tiff libbz2 fontconfig openjpeg \
    && apk add --no-cache --virtual ext-dev-dependencies $PHPIZE_DEPS binutils bash zlib-dev bzip2-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev jasper-dev tiff-dev openjpeg-dev fontconfig-dev \
    && export CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && wget -O FLIF.tar.gz https://github.com/FLIF-hub/FLIF/archive/v0.3.tar.gz \
        && tar -xf FLIF.tar.gz && cd FLIF-0.3/src && make -j$CPU_COUNT libflif.so \
        && cp library/*.h /usr/include && cp libflif.so libflif.so.0 /usr/lib && cd ../.. \
    && wget http://www.imagemagick.org/download/ImageMagick.tar.xz \
        && tar -xf ImageMagick.tar.xz && cd ImageMagick* \
        && ./configure  --disable-docs --without-x --without-magick-plus-plus --with-gslib=yes --with-wmf=no \
        && make -j$CPU_COUNT && make install && ldconfig /usr/local/lib && cd .. \
    && rm -rf ImageMagick* FLIF* \
    && yes no| pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del ext-dev-dependencies && rm -rf /tmp/pear
    
# Install Aspell for spell checking
	RUN apk --update add \
		aspell-dev \
		aspell \
		aspell-ru \
		aspell-en

	RUN	apk update 
	RUN	docker-php-ext-install pspell
		
CMD ["php-fpm"]
