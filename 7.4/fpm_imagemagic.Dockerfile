FROM grigori/phpextensions:7.4-fpm

LABEL Description="This image provides PHP 7.4 FPM and CLI with Image Magic and common extensions https://hub.docker.com/r/grigori/phpextensions"
MAINTAINER Grigori Kochanov public@grik.net

#Add graphics libraries for image magic
RUN apk add --no-cache tiff jasper-libs libbz2 fontconfig openjpeg \
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

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
CMD ["php-fpm"]