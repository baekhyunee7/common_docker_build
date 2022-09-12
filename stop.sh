#!/bin/bash

docker-compose -f ./postgresql/postgresql.yml stop
docker-compose -f ./postgresql/postgresql.yml rm
docker-compose -f ./redis/redis.yml stop
docker-compose -f ./redis/redis.yml rm