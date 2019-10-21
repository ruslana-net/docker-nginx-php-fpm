#!/usr/bin/env bash

# Set script path
DIR="$(dirname "$(readlink -f "$0")")"

# Set dir for OS X
if [ "${DIR}" == "." ]
then
DIR=$PWD;
fi

# Include .env file
source <(grep -v '^#' ${DIR}/.env | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

# Include .env file for OS X
if [ "${ENVIRONMENT}" == "" ]
then
source "${DIR}/.env"
fi

# Set default docker-compose file
DOCKER_COMPOSE_FILES="-f ${DIR}/docker-compose.yml";

cd ${DIR};

# Check cmd
case $@ in
     clean) # Delete all containers
          docker rm -f $(docker ps -aq)
          ;;
     delete) # Delete all containers and images
          docker rm -f $(docker ps -aq)
          docker rmi -f $(docker images -q)
          ;;
     top) # Check CPU consumption
          docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))
          ;;
     up) # Check CPU consumption
#          git -C "${DIR}" pull origin master

          docker-compose ${DOCKER_COMPOSE_FILES} up -d --build
          docker-compose ${DOCKER_COMPOSE_FILES} ps
          ;;
     php*) # Check CPU consumption
          docker-compose ${DOCKER_COMPOSE_FILES} exec web $@
          ;;
     mysql*|mysqldump*|mysqladmin*) # Check CPU consumption
          docker-compose ${DOCKER_COMPOSE_FILES} exec mysql $@
          ;;
     web) # Check CPU consumption
          docker-compose ${DOCKER_COMPOSE_FILES} exec web bash
          ;;
     mysql) # Check CPU consumption
          docker-compose ${DOCKER_COMPOSE_FILES} exec mysql bash
          ;;
     *)
          docker-compose ${DOCKER_COMPOSE_FILES} $@
          ;;
esac







