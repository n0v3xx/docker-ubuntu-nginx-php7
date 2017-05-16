#!/bin/bash
#########################################
############## Docker Config ############
#########################################

# Alias
DOCKER_ALIAS="base_"

# WEB
CONTAINER_WEB="base_web"
CONTAINER_WEB_SERVICE="base_web"

# MEMCACHE
CONTAINER_MEM="base_memcached"
CONTAINER_MEM_IMAGE="memcached:1.4"

# MONGO DB
CONTAINER_MONGO="base_mongo"
CONTAINER_MONGO_IMAGE="mongo"

# dbCore
CONTAINER_DBCORE="base_mysql"
CONTAINER_DBCORE_IMAGE="mysql:5.6"