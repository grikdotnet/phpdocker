# Convenient PHP images with extensions

Inherited from official PHP images, common extensions added, fixed iconv.

Versions: 7.4.11, 7.3.23, 7.2.34, 5.6.20

Tags:
* PHP-FPM and CLI non-threadsafe with common extensions: `grigori/phpextensions:7.4-fpm`, `grigori/phpextensions:7.3-fpm`, `grigori/phpextensions:7.2-fpm`, `grigori/phpextensions:5.6-fpm`
* FPM/CLI + Image Magic: `grigori/phpextensions:7.4-fpm-imagemagic`, `grigori/phpextensions:7.3-fpm-imagemagic`, `grigori/phpextensions:7.2-fpm-imagemagic`
* `grigori/phpextensions:7.3-events`, `grigori/phpextensions:7.2-events` - thread-safe, with event extensions, for non-blocking applications such as ReactPHP, AMPHP and Swoole
* `grigori/phpextensions:7.2-threads` - pthreads and pht extensions, thread-safe

### Extensions

| **fpm** | **events** |
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
| pspell | [swoole](https://github.com/swoole/swoole-src) |
| [Redis](https://github.com/phpredis/phpredis) with and sessions support and igbinary |  |
| Xdebug (disabled by default) | |
| Zend OPcache enabled | |
| zip | |
|---|---|
| [browscap.ini](http://browscap.org/) Lite for [get_browser()](http://php.net/manual/en/function.get-browser.php) | |

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
