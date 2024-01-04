# A conveniently configurable PHP image

Inherited from official PHP images, added common extensions, fixed iconv.

PHP version: 8.3.1

👉Note: PHP runs 30-50% faster with glibc than with Alpine-based images.
Tag:  `grigori/phpextensions:8.3-fpm`

## Features

* To enable XDEBUG extension pass an environment variable to a container
* Have pre-initialization scripts run when a container is created, before FPM is started
* Conveniently edit php configs in a local folder. Default config files are automatically created on the first run.
* Sample setup for compose with Nginx.
* Use different php.ini files in development and production with docker-compose.override.yaml and swarm.

### Docker compose and swarm

For development with XDebug:
1. Take contents of the folder 8.3 as an example
2. Run `docker-compose up`
3. Open http://localhost/ in the browser and find phpinfo() showing php.ini-development with xdebug is used 
 

For production:
1. stop docker-compose, clean containers with `docker-compose down` and folder etc with `sudo rm -rf etc/*`
2. Init the swarm with `docker swarm init`
3. Start with `docker stack deploy test --compose-file=docker-compose.yaml`

### Single container

1. Create a folder `etc` for PHP configuration files
2. To run a single container use a command like
    `docker run -d --mount type=bind,source="$(pwd)"/etc,target=/usr/local/etc grikdotnet/phpextensions-8.3-fpm`
3. The `etc` folder is filled up with default configuration files on the first run. Edit them and restart the container.
4. By default, PHP is run with `etc/php/php.ini-production` ini file.
In development environment add the environment variable  
`docker run -d -e "PHP_INI=php.ini-development" --mount type=bind,source="$(pwd)"/etc,target=/usr/local/etc grikdotnet/phpextensions-8.3-fpm`
5. To enable XDEBUG pass the environment variable XDEBUG_MODE:
   `docker run -d -e "PHP_INI=php.ini-development" -e "XDEBUG_MODE=debug" --mount type=bind,source="$(pwd)"/etc,target=/usr/local/etc grikdotnet/phpextensions-8.3-fpm`


### Extensions added

For PHP 8.3 image a brilliant tool [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) is used. 

Extensions added: bcmath, DS, GD, Gettext, Redis and Memcache with sessions support and igbinary, pdo_mysql, pgsql, pdo_pgsql, pspell and zip.
Composer and browscap are added as well.
Xdebug is enabled with an environment variable. 

The 7.4-fpm-imagemagic image is a sample how to build an image with an ImageMagick library, executable and a PHP extension.

