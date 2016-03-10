# Php with extensions

Based on the official PHP 7-fpm image, added commonly used extensions and Composer.phar.

Intended to deploy a PHP stack and switch versions very fast, having configs stored in CVS with your application.

The [Dockerfile](https://github.com/grikdotnet/phpdocker/blob/master/Dockerfile-php) is in a [Github repository](https://github.com/grikdotnet/phpdocker).

Before using docker it is better to have the user and group ID inside the docker container synchronized with the user and group ID in your system. Check www-data id in your system, and add yourself to the www-data group.
```
$ id www-data
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ sudo usermod -a -G www-data $(whoami)
```
The value 33 is hard-coded by the official image maintainers. It [can be changed](https://github.com/phpdocker-io/base-images/blob/master/php-fpm/7.0/Dockerfile#L23) by extending the phpextensions image.

If you are using Docker Machine in Windows or MacOS, mount the folder with your project to your virtual machine, using the same path. You can find how to do it on [StackOverflow](http://stackoverflow.com/questions/30040708/how-to-mount-local-volumes-in-docker-machine/32030385#32030385).

Usage:
Assuming your document root folder is called wwroot\ and is located in your application folder.
1. Init config and log folders, set the group ownership
2. Init php configurations files from container
3. Edit configs and disable unused extensions
4. Preare a database initial dump file
5. Run docker-compose
6. Commit your configs to your project VCS

Example to launch Nginx/PHP/MariaDB/Memcached without XDebug:
```
cd /path/to/application
# init etc/ and logs/ folders
wget https://raw.githubusercontent.com/grikdotnet/phpdocker/master/init_lnpm.tar.gz -O - |tar -x
chgrp -R www-data .
chmod g+rwx logs etc
# init php configs in ./etc folder from an image
docker run --rm -v $(pwd)/etc:/usr/local/etc grigori/phpextensions
cd ./etc/php/conf.d/
# disable extensions you don't want to have enabled
rm docker-php-ext-xdebug.ini docker-php-ext-ev.ini docker-php-ext-imap.ini
cd ../../..
# edit configs
vi ./etc/php/php.ini
vi ./etc/nginx/conf.d/default.conf
vi ./etc/my.custom.cnf
# prepare a database init dump, should contain a `create database` command
mv myapp.dump.sql init.sql
# add lnpm stack configs to your git repo
git add ./etc ./docker-compose.yml && git commit -m "Adding php/nginx/mysql/docker-compose configs"
# edit docker-compose.ym per taste and start
wget https://raw.githubusercontent.com/grikdotnet/phpdocker/master/docker-compose.ym
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
