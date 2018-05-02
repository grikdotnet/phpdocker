#!/bin/sh


if [ ! -f "/var/lock/phpinit" ]; then

    for f in /docker-entrypoint-init.d/*; do
        case "$f" in
            *.sh)     echo "$0: running $f"; . "$f" ;;
            *.php)    echo "$0: running $f"; php -f "$f"; echo ;;
            *)        echo "$0: ignoring $f" ;;
        esac
        echo
    done

    touch /var/lock/phpinit
fi

set -e


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
