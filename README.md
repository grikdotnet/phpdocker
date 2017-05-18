# Convenient Php image with extensions

This image is designed for convenient development. Store PHP configs in your application CVS and mount to a container.
Added commonly used PHP extensions and libraries to official PHP-fpm images.
Small disk size thanks to alpine linux.

### Windows Example
```
mkdir etc
docker run --rm -d -v c:\\www\\etc:/usr/local/etc grikdotnet/php:7.1-fpm-alpine 
... edit configs
docker-compose up
```

### Usage:
Assuming your document root folder is called wwroot\ and is located in your application folder.
1. Create a local "etc" folder within your project
2. Start a container with etc folder mounted, php configs will appear in a mounted folder
3. Edit php.ini and fpm configs, enable or disable extensions by renaming files in etc/php/conf.d 
5. Restart the php-extensions container
6. Commit php configs to the project VCS

If you use docker in Linux for development, it is convenient to have the user and group ID inside a docker container synchronized with the user and group ID in your system. Check www-data id in your system, and add yourself to the www-data group.
```
$ id www-data
uid=82(www-data) gid=82(www-data) groups=82(www-data),82(www-data)
$ sudo usermod -a -G www-data $(whoami)
```
The value is [hard-coded](https://github.com/docker-library/php/blob/master/7.1/fpm/alpine/Dockerfile#L28) by official image maintainers. It can be changed by extending the image.

### Extensions added

List of extensions and dependent libraries added to the official PHP image.

In **:5.6-fpm-alpine** and **:7.1-fpm-alpine** :

* Apcu
* Bcmath
* GD, with webp support in php 7
* [igbinary](https://github.com/igbinary/igbinary) - a serializer for redis and memcached
* [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7), configured with igbinary serializer and sessions support
* mysqli
* pgsql
* pdo_mysql
* pdo_pgsql
* [Redis](https://github.com/phpredis/phpredis) with and sessions support and igbinary seralizer 
* XSL
* Xdebug (disabled)
* Zend OPcache enabled

In **:7.1-fpm-imagemagic
* Latest ImageMagick executable, library and PHP extension
* [WEBP](https://en.wikipedia.org/wiki/WebP) support - an efficient image format for web
* [FLIF](https://en.wikipedia.org/wiki/Free_Lossless_Image_Format) support - new efficient lossless image format

Disk consumption: 
* 104 MB for PHP 5.6
* 118 MB for PHP 7.1
* 175 MB for PHP 7.1 with ImageMagic
