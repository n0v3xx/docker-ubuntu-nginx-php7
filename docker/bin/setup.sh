#!/bin/bash

########################################################################################################################
### Start Docker Setup
########################################################################################################################

DIR=`dirname $(readlink -f $0)`
DOCKER_DIR=`dirname $DIR`
PROJECT_ROOT=`dirname $DOCKER_DIR`

# load docker config variables for this specific project
source "$DIR/config.sh"

# prepare environment variables which will be used by dockers variable substitution
USER_NAME=$(id -un)
USER_ID=$(id -u)
GROUP_ID=$(id -g)
GROUP_NAME=$(id -gn)
REMOTE_HOST=$(hostname -I | awk '{print $1}')
HOST_NAME=$(hostname | awk '{print $1}')

ENV_SOURCE="$PROJECT_ROOT/.env.dist"
ENV_DESTINATION="$PROJECT_ROOT/.env"

cp "$ENV_SOURCE" "$ENV_DESTINATION"

sed -i -r "s|###USER_NAME###|$USER_NAME|g" "$ENV_DESTINATION"
sed -i -r "s|###USER_ID###|$USER_ID|g" "$ENV_DESTINATION"
sed -i -r "s|###USER_HOME###|$HOME|g" "$ENV_DESTINATION"
sed -i -r "s|###GROUP_ID###|$GROUP_ID|g" "$ENV_DESTINATION"
sed -i -r "s|###GROUP_NAME###|$GROUP_NAME|g" "$ENV_DESTINATION"
sed -i -r "s|###REMOTE_HOST###|$REMOTE_HOST|g" "$ENV_DESTINATION"
sed -i -r "s|###SSH_AUTH_SOCK###|$SSH_AUTH_SOCK|g" "$ENV_DESTINATION"

# create log folder for webserver
echo "===> Create log folder"
mkdir -p log && chmod 777 log

echo "You choose: Ubuntu 16.04, PHP 7.1 with NGINX"
echo ""
sudo docker-compose -f ${DOCKER_DIR}/ubuntu/php71/docker-compose.yml up -d

########################################################################################################################
### XDEBUG - We have to replace the remote ip every time because of fail configuration of the unidev image (missing static ip)
########################################################################################################################

echo "==> Replace xdebug remote host with ipadress of docker host"
REMOTE_HOST=$(hostname -I | awk '{print $1}')
echo "Your remote host ip address is $REMOTE_HOST"
XDEBUG_INI="/etc/php/7.1/fpm/conf.d/99-docker.ini"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/xdebug\.remote_host=(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b/xdebug.remote_host=$REMOTE_HOST"/ "$XDEBUG_INI"

# restart
sudo docker-compose -f ${DOCKER_DIR}/ubuntu/php71/docker-compose.yml restart ${CONTAINER_WEB_SERVICE}

# run deplyoment
#sudo docker exec -itu "$USER_NAME" "$CONTAINER_WEB" ./docker/bin/phing.sh