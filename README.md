# Convenient Php image with extensions

This image is inherited from an official PHP image plus common extensions.
Small disk size thanks to alpine linux.

### Extensions


In **:7.1-fpm**, **:7.2-fpm** and **:7.3-fpm**:

* Bcmath
* ds - [Data structures](http://php.net/manual/en/book.ds.php) for PHP 7
* GD with webp, freetype, jpeg, png and zlib libraries
* gettext
* [igbinary](https://github.com/igbinary/igbinary) - a better serializer for redis and memcached
* [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7), configured with igbinary serializer and sessions support
* mysqli
* pgsql
* pdo_mysql
* pdo_pgsql
* [Redis](https://github.com/phpredis/phpredis) with and sessions support and igbinary
* XSL
* Xdebug (not enabled by default)
* Zend OPcache enabled

Extensions from the official image:
* ctype
* curl
* date
* dom
* fileinfo
* filter
* ftp
* hash
* iconv
* json
* libxml
* mbstring
* mysqlnd
* openssl
* pcre
* PDO
* pdo_sqlite
* Phar
* posix
* readline
* Reflection
* session
* SimpleXML
* sodium
* SPL
* sqlite3
* standard
* tokenizer
* xml
* xmlreader
* xmlwriter
* zlib

In **:7.1-fpm-imagemagic
* Latest ImageMagick executable, library and PHP extension
* [WEBP](https://en.wikipedia.org/wiki/WebP) support - an efficient image format for web
* [FLIF](https://en.wikipedia.org/wiki/Free_Lossless_Image_Format) support - new efficient lossless image format

