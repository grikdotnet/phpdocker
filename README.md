# Php with extensions

Based on the official PHP 7-fpm image, added commonly used extensions and Composer.phar

The [Dockerfile](https://github.com/grikdotnet/phpdocker/blob/master/Dockerfile-php) is in a [Github repository](https://github.com/grikdotnet/phpdocker).

Before using docker it is better to have the user and group ID inside the docker container synchronized with the user and group ID in your system. Check www-data id in your system, and add yourself to the www-data group.
```
$ id www-data
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ sudo usermod -a -G www-data $(whoami)
```
The value "33" is hard-coded by maintainers of official docker images. It does not matter and can be changed, just make sure it is synchronized to avoid permissions issues. Keep in mind that docker runs with the host filesystem.

Usage:

1. Create folders etc\ and logs\ in your project, set the group ownership
2. Run the phpextensions container with the etc\ folder mounted, the container will init the php config files
3. Edit configs and disable unused extensions
6. Run docker-compose
7. Commit your configs to your project VCS

Example:
```
mkdir etc logs upload_tmp
chgrp www-data logs etc
chmod g+rwx logs etc
docker run --rm -v $(pwd)/etc:/usr/local/etc grigori/phpextensions
vi ./etc/php/php.ini
cd ./etc/php/conf.d/
rm docker-php-ext-xdebug.ini docker-php-ext-pdo_pgsql.ini docker-php-ext-redis.ini
cd ../..
vi nginx/conf.d/default.conf
cd ../../..
docker-compose up
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
