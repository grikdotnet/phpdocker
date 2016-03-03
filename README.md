# Php with extensions

Based on the official PHP 7-fpm image, added commonly used extensions and Composer.phar

The [Dockerfile](https://github.com/grikdotnet/phpdocker/blob/master/Dockerfile-php) is in a [Github repository](https://github.com/grikdotnet/phpdocker).

Usage:

1. Create folders etc\ and logs\ in your project
2. Run a container mounting the etc\ folder to /usr/local/etc, it will init the configs in it
3. Edit configs and disable unused extensions
4. Run FPM
5. Commit configs to your VCS

Example:
```
mkdir etc logs upload_tmp
docker run --rm -v $(pwd)/etc:/usr/local/etc grigori/phpextensions
vi ./etc/php/php.ini
cd ./etc/php/conf.d/
rm docker-php-ext-xdebug.ini docker-php-ext-pdo_pgsql.ini docker-php-ext-igbinary.ini docker-php-ext-redis.ini
docker run -d --name=php7 -v $(pwd)/etc:/usr/local/etc \
    -v $(pwd)/logs:/var/log/php \
    -v $(pwd)/upload_tmp:/var/upload_tmp \
    grigori/phpextensions php-fpm > logs/fpm.log 2>&1
git add etc/
```

Extensions added to the FPM SAPI:
* Apcu (beta)
* Bcmath
* [Data Structures](https://medium.com/@rtheunissen/efficient-data-structures-for-php-7-9dda7af674cd)
* [Ev](http://docs.php.net/ev) (beta)
* IMAP
* [igbinary](https://github.com/igbinary/igbinary) (beta) - a serializer for redis and memcached
* Kerberos
* Mbstring
* [memcached](https://github.com/php-memcached-dev/php-memcached/tree/php7) (beta)
* [Msgpack](https://pecl.php.net/package/msgpack) (beta)
* mysqli
* Pdo_mysql
* Pdo_pgsql
* Pgsql
* [Redis](https://github.com/phpredis/phpredis) (beta)
* XSL
* Xdebug (beta)
* Zend OPcache


Additional extensions added to CLI version:
* FTP
* [sockets](php.net/manual/ru/book.sockets.php)
* sysvsem, sysvshm, [shmop](http://php.net/manual/book.shmop.php)
* [PCNTL](http://php.net/manual/book.pcntl.php)
* [POSIX](http://php.net/manual/book.posix.php)

Additional disk consumption: 140 MB
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
phpextensions       latest              6a506ccc4b69        About an hour ago   635.1 MB
php                 7-fpm               e6e0357f88cd        8 days ago          495 MB
```
