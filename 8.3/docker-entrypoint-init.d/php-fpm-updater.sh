#!/bin/bash
set -e
echo updating /usr/local/etc/php-fpm.d/www.conf
cp --backup=t /docker-entrypoint-init.d/www.conf /usr/local/etc/php-fpm.d/www.conf
rm /usr/local/etc/php-fpm.d/zz-docker.conf