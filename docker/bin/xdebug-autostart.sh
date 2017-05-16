#!/bin/bash

BIN_DIR=`dirname $(readlink -f $0)`
DOCKER_DIR=`dirname $BIN_DIR`
ROOT_DIR=`dirname $DOCKER_DIR`

XDEBUG_CONFIG_FILE_PHP_71="/etc/php/7.1/fpm/conf.d/99-docker.ini"

cd "$ROOT_DIR"

# load docker config variables for this specific project
source "$BIN_DIR/config.sh"

echo ""
echo "+---------------------------------+"
echo "| Xdebug remote autotstart helper |"
echo "+---------------------------------+"
echo ""
read -p "Enter 1 to enable or 0 to disable > " enable

if [ "$enable" == 1 ]
    then
        sudo docker exec -it "$CONTAINER_WEB" sed -i -r "s/xdebug\.remote_autostart=[0-1]{1}/xdebug.remote_autostart=1/" "$XDEBUG_CONFIG_FILE_PHP_71"
elif [ "$enable" == 0 ]
    then
        sudo docker exec -it "$CONTAINER_WEB" sed -i -r "s/xdebug\.remote_autostart=[0-1]{1}/xdebug.remote_autostart=0/" "$XDEBUG_CONFIG_FILE_PHP_71"
fi

echo ""
echo "==> Verify your new settings"
echo ""
sudo docker exec -it "$CONTAINER_WEB" cat "$XDEBUG_CONFIG_FILE_PHP_71"
echo ""
echo "==> Restarting apache to ensure that your new settings take effect"
echo ""
sudo docker exec -it "$CONTAINER_WEB" apachectl restart
echo ""
echo "==> Done"