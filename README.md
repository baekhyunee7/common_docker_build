# common_docker_build
build common docker for development on Linux

### dependency
* [yq](https://github.com/mikefarah/yq)
* jq
* docker-compose

### contains
* postgresql
* redis
* prometheus

### usage
modify ```config.json``` and execute ```setup.sh```
```
{
  "postgresql":{
    "need": true,                               // whether need install
    "container_name": "postgresql1",            // container name
    "host_port": 5433,                          // host port
    "user": "test",                             // postgresql user
    "password": "12345",                        // postgresql password
    "db": "test",                               // postgresql db
    "adminer_port": 8080                        // host port of image "adminer"
  },
  "redis":{
    "need": true,
    "container_name": "redis1",
    "host_port": 6380
  },
  "prometheus":{
    "need": true,
    "host_port": 9090,
    "container_name": "prometheus1",
    "config_dir": "./prometheus/config"         // prometheus config directory for volumes
  }
}
```
