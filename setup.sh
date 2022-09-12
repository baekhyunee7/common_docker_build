#!/bin/bash

# shellcheck disable=SC2002
if [ "$(cat config.json | jq -c '.postgresql.need' )" = "true" ]
then
  POSTGRES_HOST_MAP_PORT=$(cat config.json | jq -c '.postgresql.host_port' )
  POSTGRES_ENV_FILE="postgresql/.env"
  [ -e $POSTGRES_ENV_FILE ] && rm $POSTGRES_ENV_FILE
  # shellcheck disable=SC2129
  echo "# compose arguments" >> $POSTGRES_ENV_FILE
  POSTGRES_CONTAINER_NAME=$(cat config.json | jq -c '.postgresql.container_name' | sed  's/\"//g')
  [ -n "$POSTGRES_CONTAINER_NAME" ] && echo "POSTGRES_CONTAINER_NAME:$POSTGRES_CONTAINER_NAME" >> $POSTGRES_ENV_FILE
  echo "POSTGRES_HOST_MAP_PORT:$POSTGRES_HOST_MAP_PORT" >> $POSTGRES_ENV_FILE
  echo "# environments" >> $POSTGRES_ENV_FILE
  POSTGRES_USER=$(cat config.json | jq -c '.postgresql.user' | sed  's/\"//g')
  [ -n "$POSTGRES_USER" ] && echo "POSTGRES_USER:$POSTGRES_USER" >> $POSTGRES_ENV_FILE
  POSTGRES_PASSWORD=$(cat config.json | jq -c '.postgresql.password' | sed  's/\"//g')
  [ -n "$POSTGRES_PASSWORD" ] && echo "POSTGRES_PASSWORD:$POSTGRES_PASSWORD" >> $POSTGRES_ENV_FILE
  POSTGRES_DB=$(cat config.json | jq -c '.postgresql.db' | sed  's/\"//g')
  [ -n "$POSTGRES_DB" ] && echo "POSTGRES_DB:$POSTGRES_DB" >> $POSTGRES_ENV_FILE
#  docker-compose -f ./postgresql/postgresql.yml up -d
fi

if [ "$(cat config.json | jq -c '.redis.need' )" = "true" ]
then
  REDIS_HOST_MAP_PORT=$(cat config.json | jq -c '.redis.host_port' )
  REDIS_ENV_FILE="redis/.env"
  [ -e $REDIS_ENV_FILE ] && rm $REDIS_ENV_FILE
  echo "# compose arguments" >> $REDIS_ENV_FILE
  REDIS_CONTAINER_NAME=$(cat config.json | jq -c '.redis.container_name' | sed  's/\"//g')
  [ -n "$REDIS_CONTAINER_NAME" ] && echo "REDIS_CONTAINER_NAME:$REDIS_CONTAINER_NAME" >> $REDIS_ENV_FILE
  echo "REDIS_HOST_MAP_PORT:$REDIS_HOST_MAP_PORT" >> $REDIS_ENV_FILE
#  docker-compose -f ./redis/redis.yml up -d
fi
