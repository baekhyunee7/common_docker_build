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
  ADMINER_HOST_MAP_PORT=$(cat config.json | jq -c '.postgresql.adminer_port' )
  echo "ADMINER_HOST_MAP_PORT:$ADMINER_HOST_MAP_PORT" >> $POSTGRES_ENV_FILE
  echo "# environments" >> $POSTGRES_ENV_FILE
  POSTGRES_USER=$(cat config.json | jq -c '.postgresql.user' | sed  's/\"//g')
  [ -n "$POSTGRES_USER" ] && echo "POSTGRES_USER:$POSTGRES_USER" >> $POSTGRES_ENV_FILE
  POSTGRES_PASSWORD=$(cat config.json | jq -c '.postgresql.password' | sed  's/\"//g')
  [ -n "$POSTGRES_PASSWORD" ] && echo "POSTGRES_PASSWORD:$POSTGRES_PASSWORD" >> $POSTGRES_ENV_FILE
  POSTGRES_DB=$(cat config.json | jq -c '.postgresql.db' | sed  's/\"//g')
  [ -n "$POSTGRES_DB" ] && echo "POSTGRES_DB:$POSTGRES_DB" >> $POSTGRES_ENV_FILE
  docker-compose -f ./postgresql/postgresql.yml up -d
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
  docker-compose -f ./redis/redis.yml up -d
fi

if [ "$(cat config.json | jq -c '.prometheus.need' )" = "true" ]
then
  PROMETHEUS_HOST_MAP_PORT=$(cat config.json | jq -c '.prometheus.host_port' )
  PROMETHEUS_ENV_FILE="prometheus/.env"
  [ -e $PROMETHEUS_ENV_FILE ] && rm $PROMETHEUS_ENV_FILE
  echo "# compose arguments" >> $PROMETHEUS_ENV_FILE
  PROMETHEUS_CONTAINER_NAME=$(cat config.json | jq -c '.prometheus.container_name' | sed  's/\"//g')
  [ -n "$PROMETHEUS_CONTAINER_NAME" ] && echo "PROMETHEUS_CONTAINER_NAME:$PROMETHEUS_CONTAINER_NAME" >> $PROMETHEUS_ENV_FILE
  echo "PROMETHEUS_HOST_MAP_PORT:$PROMETHEUS_HOST_MAP_PORT" >> $PROMETHEUS_ENV_FILE
  PROMETHEUS_CONFIG_RELATIVE_PATH=$(cat config.json | jq -c '.prometheus.config_dir' | sed  's/\"//g')
  if [ -e "$PROMETHEUS_CONFIG_RELATIVE_PATH" ]
  then
    # shellcheck disable=SC2016
    V="$(realpath "$PROMETHEUS_CONFIG_RELATIVE_PATH"):/etc/prometheus" yq -i '.services.prometheus.volumes = [strenv(V)]'  prometheus/prom.yml
  fi
  docker-compose -f ./prometheus/prom.yml up -d
fi
