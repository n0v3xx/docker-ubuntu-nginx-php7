# docker-ubuntu-nginx-php7
Docker config to create PHP 7.1, NGINX container

**Ubuntu 16.04  with NGINX (1.10.0) and PHP (7.1)**

Ready to use docker container.

Webserver Packages:
* nginx

PHP Packages:
* mysql-client
* supervisor
* php7.1
* php7.1-fpm
* php7.1-common
* php7.1-curl
* php7.1-mysql
* php7.1-dev
* php7.1-xdebug

Modify docker/ubuntu/php71/Dockerfile if you want more packages.

!!! Modify the last line in "docker/bin/setup.sh" if you want to run a deployment.

**Run**

    chmod +x ./docker/bin/setup.sh
    ./docker/bin/setup.sh
    
Visit http://localhost:8180/info.php or https://localhost:8181/info.php
    
**Connect to Container**

    # Root
    sudo docker exec -it base_web /bin/bash
    
    # User
    sudo docker exec -itu myName base_web /bin/bash
    
**Restart or Stop**

    # Restart
    sudo docker-compose -f ./docker/ubuntu/php71/docker-compose.yml restart
    
    # Stop
    sudo docker-compose -f ./docker/ubuntu/php71/docker-compose.yml stop