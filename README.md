# Phpdocker

Based on the official PHP 7-fpm image, added commonly used extensions and Composer.phar

Extensions added to the FPM SAPI:
* apcu
* bcmath
* ev
* imap
* [igbinary](https://github.com/igbinary/igbinary) used with redis
* kerberos
* mbstring
* [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7)
* mysqli
* pdo_mysql
* pdo_pgsql
* pdo_pgsql
* pgsql
* [redis](https://github.com/phpredis/phpredis)
* xsl
* Xdebug
* Zend OPcache


Additional extensions added to CLI version:
* ftp
* [sockets](php.net/manual/ru/book.sockets.php)
* sysvsem, sysvshm, [shmop](http://php.net/manual/book.shmop.php)
* [pcntl](http://php.net/manual/book.pcntl.php)
* [posix](http://php.net/manual/book.posix.php)

Additional disk size consumption: 144 MB
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
phpextensions       latest              a35f94b9311b        12 minutes ago      638.9 MB
php                 7-fpm               e6e0357f88cd        8 days ago          495 MB
```