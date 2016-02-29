# Phpdocker

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
docker run --rm -v $(pwd)/etc:/usr/local/etc phpextensions
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

Time to build - about 5 minutes.
