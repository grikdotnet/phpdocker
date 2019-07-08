# Convenient Php images with extensions

Inherited from official PHP images, common extensions added, fixed iconv.

Versions: 7.3.6 and 7.2.20

Tags:
* 7.3-fpm, 7.2-fpm - classic PHP-FPM with common extensions
* 7.3-fpm-imagemagic, 7.2-fpm - image magic added 
* 7.3-events, 7.2-events  - adapted for non-blocking and console: ReactPHP, AMPHP and Swoole
* 7.2-threads - thread-safe build with pthreads and pht extensions

### Extensions

| **7.2-fpm**, **7.3-fpm** | **7.x-events** |
|---|---|
| Bcmath | Bcmath |
| DS - [Data structures](http://php.net/manual/en/book.ds.php) for PHP 7 | DS |  
| GD with webp, freetype, jpeg, png and zlib libraries | pcntl | 
| Gettext | Gettext |
| [igbinary](https://github.com/igbinary/igbinary) - serializer for redis and memcached | igbinary |
| [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7), with igbinary and sessions support | sockets | 
| mysqli | mysqli |
| pdo_mysql | pdo_mysql |
| pgsql | [event](http://php.net/manual/en/book.event.php) for ReactPHP |
| pdo_pgsql | [ev](http://php.net/manual/en/book.ev.php) for ReactPHP |
| pspell* | [swoole](https://github.com/swoole/swoole-src) |
| [Redis](https://github.com/phpredis/phpredis) with and sessions support and igbinary |  |
| Xdebug (not enabled by default) | |
| Zend OPcache enabled | |
| zip | | 
|---|---|
| [browscap.ini](http://browscap.org/) Lite for [get_browser()](http://php.net/manual/en/function.get-browser.php) | |

 * Pspell is not added to PHP 5.6.40 image.

**7.x-fpm-imagemagic** is inherited from 7.x-fpm, plus: 
* Latest ImageMagick library, PHP extension and executable
* [WEBP](https://en.wikipedia.org/wiki/WebP) support
* [FLIF](https://en.wikipedia.org/wiki/Free_Lossless_Image_Format) support


**Extensions inherited from official images:**
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
