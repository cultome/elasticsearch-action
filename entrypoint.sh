#!/bin/sh

docker network create elastic

docker_run="docker run"
docker_run="$docker_run --network elastic -e 'node.name=es1' -e 'cluster.name=docker-elasticsearch' -e 'cluster.routing.allocation.disk.threshold_enabled=false' -e 'bootstrap.memory_lock=true' -e 'ES_JAVA_OPTS=-Xms1g -Xmx1g' --ulimit nofile=65536:65536 --ulimit memlock=-1:-1 --name='es1' -d -p $INPUT_HOST_PORT:$INPUT_CONTAINER_PORT -e discovery_type="single-node" docker.elastic.co/elasticsearch/elasticsearch-oss::$INPUT_ELASTICSEARCH_VERSION"

sh -c "$docker_run"

docker run --network elastic --rm appropriate/curl --max-time 120 --retry 120 --retry-delay 1 --retry-connrefused --show-error --silent http://es1:9200
