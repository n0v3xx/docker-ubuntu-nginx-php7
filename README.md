# docker-ubuntu-nginx-php7
Docker config to create PHP 7.1, NGINX container

**Ubuntu 16.04  with NGINX (1.10.0), PHP (7.1.5), OPcache and Xdebug (2.5.1)**

Ready to use docker container.

System Packages:
* git
* unzip
* vim
* nano
* libbz2-dev
* libicu-dev
* libmcrypt-dev
* libzip-dev
* libxml2-dev
* mysql-client
* supervisor
* nginx

PHP Packages:
* php7.1
* php7.1-fpm
* php7.1-common
* php7.1-curl
* php7.1-mbstring
* php7.1-xml
* php7.1-mysql
* php7.1-dev
* php7.1-bz2
* php7.1-intl
* php7.1-xdebug
* php7.1-ldap
* php7.1-memcached
* php7.1-soap
* php7.1-memcache

Modify docker/ubuntu/php71/Dockerfile if you want more packages.

!!! Modify the last line in "docker/bin/setup.sh" if you want to run a deployment.

**Run**

    sudo docker run -t -i blackjack777/ubuntu-nginx-php71:1.0 /bin/bash