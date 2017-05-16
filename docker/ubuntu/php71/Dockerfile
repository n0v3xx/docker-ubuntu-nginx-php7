########################################################################################################################
### Define base image
########################################################################################################################

FROM ubuntu:16.04

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive

########################################################################################################################
### Install base packages and basic php extensions
########################################################################################################################

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# prepare and install php7.1 repo
RUN apt-get install -y software-properties-common python-software-properties
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update

# install all
RUN apt-get update && apt-get install -y --allow-unauthenticated \
        git \
        unzip \
        vim \
        nano \
        # for bz2 extension
        libbz2-dev \
        # for intl extension
        libicu-dev \
        # for mcrypt extension
        libmcrypt-dev \
        # for zip extension
        libzip-dev \
        mysql-client \
        libxml2-dev \
        supervisor \
        nginx \
        php7.1 \
        php7.1-fpm \
        php7.1-common \
        php7.1-curl \
        php7.1-mbstring \
        php7.1-xml \
        php7.1-mysql \
        php7.1-dev \
        php7.1-bz2 \
        php7.1-intl \
        php7.1-xdebug \
        php7.1-ldap \
        php7.1-memcached \
        php7.1-soap \
        php7.1-memcache

# cleanup
RUN apt-get clean -y

# ldap cert fix
RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

########################################################################################################################
### php settings
########################################################################################################################

# copy docker.ini to the php-fpm configuration
COPY ./docker/ubuntu/template/php-fpm/docker.ini /etc/php/7.1/fpm/conf.d/99-docker.ini

# create a symlink from the php-fpm configuration to the php-cli configuration
RUN ln -s /etc/php/7.1/fpm/conf.d/99-docker.ini /etc/php/7.1/cli/conf.d/99-docker.ini

########################################################################################################################
### php-fpm configuration
########################################################################################################################

COPY ./docker/ubuntu/template/php-fpm/pool/www.conf /etc/php/7.1/fpm/pool.d/www.conf
RUN service php7.1-fpm start

########################################################################################################################
### Nginx configuration
########################################################################################################################

COPY ./docker/ubuntu/template/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/ubuntu/template/nginx/vhost/default.conf /etc/nginx/sites-available/default

########################################################################################################################
### Install MongoDb & Tideways Ext & XHGui - ACHTUNG nur mit PHP 5.5 und höher
########################################################################################################################

# MongoDB
# https://github.com/mongodb/mongo-php-driver/issues/138
RUN apt-get install -y libssl-dev mongodb pkg-config \
    && pecl install mongodb \
    && echo "extension=mongodb.so" >> /etc/php/7.1/mods-available/mongo.ini \
    && ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/fpm/conf.d/20-mongo.ini \
    && ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/cli/conf.d/20-mongo.ini

# Tideways PHP Profiling Ext
# Github: https://github.com/tideways/php-profiler-extension
RUN apt-get install -y libcurl4-openssl-dev libpcre3-dev \
    && cd /usr/local/ \
    && git clone https://github.com/tideways/php-profiler-extension.git \
    && cd php-profiler-extension \
    && /usr/bin/phpize \
    && ./configure --with-php-config=/usr/bin/php-config \
    && make && make install

# copy tideways ext config
COPY ./docker/ubuntu/template/tideways/tideways.ini /etc/php/7.1/mods-available/tideways.ini

# enable extension
RUN ln -s /etc/php/7.1/mods-available/tideways.ini /etc/php/7.1/fpm/conf.d/20-tideways.ini \
    && ln -s /etc/php/7.1/mods-available/tideways.ini /etc/php/7.1/cli/conf.d/20-tideways.ini

# install xhgui
RUN mkdir -p /var/www/xhgui \
    && chown -R www-data:www-data /var/www/xhgui \
    && git clone https://github.com/perftools/xhgui.git /var/www/xhgui

# copy vhost template and symlink to activate the vhost
COPY ./docker/ubuntu/template/nginx/vhost/xhgui.conf /etc/nginx/sites-available/xhgui
RUN ln -s /etc/nginx/sites-available/xhgui /etc/nginx/sites-enabled/xhgui

# copy xhgui config template
COPY ./docker/ubuntu/template/xhgui/xhgui.config.php /var/www/xhgui/config/config.php

WORKDIR /var/www/xhgui
RUN php install.php

########################################################################################################################
### Install NodeJs and NPM
########################################################################################################################

#RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
#    apt-get install -y --allow-unauthenticated nodejs && \
#    npm install -g newman

########################################################################################################################
### modified ssh_config
########################################################################################################################

COPY ./docker/ubuntu/template/ssh/ssh_config /etc/ssh/ssh_config

########################################################################################################################
#### Listen on Port 80
########################################################################################################################
EXPOSE 80 81 443

########################################################################################################################
### Supervisor
########################################################################################################################

# copy supvisor config to /etc
COPY ./docker/ubuntu/template/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# see http://tiborsimko.org/docker-running-multiple-processes.html
CMD ["/usr/bin/supervisord"]