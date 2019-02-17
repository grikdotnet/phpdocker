# Convenient Php image with extensions

This image is inherited from an official PHP image, having common extensions added.
Small disk size thanks to alpine linux.

Tags:
* 7.3-fpm, 7.2-fpm - classic PHP-FPM
* 7.3-events, 7.2-events  - adapted for non-blocking and console: ReactPHP, AMPHP and Swoole
* 7.2-threads - thread-safe build with pthreads and pht extensions
* 5.6-fpm-alpine - old PHP 5.6 image

### Extensions

| **:7.x-fpm** | **7.x-events** |
|---|---| 
| Bcmath | Bcmath |
| ds - [Data structures](http://php.net/manual/en/book.ds.php) for PHP 7 | ds |  
| GD with webp, freetype, jpeg, png and zlib libraries | pcntl |
| gettext | gettext |
| [igbinary](https://github.com/igbinary/igbinary) - a better serializer for redis and memcached | igbinary |
| [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7), with igbinary and sessions support | sockets | 
| mysqli | mysqli |
| pdo_mysql | pdo_mysql |
| pgsql | [event](http://php.net/manual/en/book.event.php) for ReactPHP |
| pdo_pgsql | [ev](http://php.net/manual/en/book.ev.php) also for ReactPHP |
| [Redis](https://github.com/phpredis/phpredis) with and sessions support and igbinary | [swoole](https://github.com/swoole/swoole-src) |
| Xdebug (not enabled by default) | |
| Zend OPcache enabled | |


In **:7.x-fpm-imagemagic**
* Latest ImageMagick executable, library and PHP extension
* [WEBP](https://en.wikipedia.org/wiki/WebP) support - an efficient image format for web
* [FLIF](https://en.wikipedia.org/wiki/Free_Lossless_Image_Format) support - new efficient lossless image format


Inherited from the official image:
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

