#!/bin/bash

set -e

# if the empty /usr/local/etc folder was mounted to the container, fill it with default configuration files
if [ -z "$(ls /usr/local/etc/)" ]; then
    cp -r /usr/local/etc.bak/* /usr/local/etc
fi

# run init scripts before starting FPM
if [ ! -f "/var/lock/phpinit" ]; then
    touch /var/lock/phpinit
    if [ -n "$(ls -A /docker-entrypoint-init.d/)" ]; then
        for f in /docker-entrypoint-init.d/*; do
            case "$f" in
                *.sh)     echo "$0: running $f"; . "$f" ;;
                *.php)    echo "$0: running $f"; php -f "$f"; echo ;;
                *)        echo "$0: ignoring $f" ;;
            esac
            echo
        done
    fi
fi

#enable xdebug extension if the XDEBUG environment variable is set
if [[ -n "${XDEBUG_MODE}" ]] && [ "${XDEBUG_MODE,,}" != "off" ]; then
	docker-php-ext-enable xdebug
fi

# run PHP FPM if the command line argument is missing, `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

# just execute the command given to a container without running PHP FPM
exec "$@"
