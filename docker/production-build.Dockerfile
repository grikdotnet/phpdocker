FROM grigori/php-baseline:8.3-fpm

LABEL Description="A sample of a production image build with PHP runtime and an application"
MAINTAINER Grigori Kochanov public@grik.net

COPY ./src /opt/www