CURRENT_IP := $(shell ip -o -4 addr list wlp37s0 | awk '{print $$4}' | cut -d/ -f1)

HADOOP_VERSION ?= 3.2.1
HIVE_VERSION ?= 3.1.2
PRESTO_VERSION ?= 0.235.1
ES_VERSION ?= 7.7.0

MIRROR_ROOT := /opt/mirror

HADOOP_PATH := ${MIRROR_ROOT}/hadoop/common/hadoop-${HADOOP_VERSION}
HIVE_PATH := ${MIRROR_ROOT}/hive/hive-${HIVE_VERSION}
PRESTO_PATH := ${MIRROR_ROOT}/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}
ES_PATH := ${MIRROR_ROOT}/downloads/elasticsearch/

${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz:
	mkdir -p "${HADOOP_PATH}"
	curl -Lso "${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz" \
		"http://apache.mirror.iphh.net/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz:
	mkdir -p "${HIVE_PATH}"
	curl -Lso "${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz" \
		"http://apache.mirror.iphh.net/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"

${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz:
	mkdir -p "${PRESTO_PATH}"
	curl -Lso "${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz" \
		"https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz"

${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz:
	mkdir -p "${ES_PATH}"
	curl -Lso "${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz" \
		"https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.7.0-linux-x86_64.tar.gz"

update-mirror: ${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz \
	${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
	${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz \
	${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz

.PHONY: create-pod start-mirror
.PHONY: build-base build-jdk-8 build-jdk-11 build-hive build-beeline build-elasticsearch build-presto
.PHONY: run-base run-jdk-8 run-jdk-11 run-hive run-beeline run-elasticsearch run-presto

start-mirror: update-mirror
	mkdir -p ${MIRROR_ROOT}
	python -m http.server 8080 --directory ${MIRROR_ROOT}

create-pod:
	podman pod create -n local

build-base:
	podman build -f ./base/Containerfile -t base --network host

build-jdk-8: build-base
	podman build -f ./jdk-8/Containerfile -t jdk-8 --network host

build-jdk-11: build-base
	podman build -f ./jdk-11/Containerfile -t jdk-11 --network host

build-hive: build-jdk-8
	podman build -f ./hive/Containerfile -t hive --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080" --build-arg "HADOOP_VERSION=${HADOOP_VERSION}" --build-arg "HIVE_VERSION=${HIVE_VERSION}"

build-beeline: build-hive
	podman build -f ./beeline/Containerfile -t beeline --network host

build-elasticsearch: build-jdk-11
	podman build -f ./elasticsearch/Containerfile -t elasticsearch --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

build-presto: build-jdk-11
	podman build -f ./presto/Containerfile -t presto --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

run-base:
	podman run --pod local \
		-it localhost/base

run-jdk-8:
	podman run --pod local \
		-it localhost/jdk-8

run-jdk-11:
	podman run --pod local \
		-it localhost/jdk-11

run-hive:
	podman run --pod local \
		--mount type=tmpfs,tmpfs-size=4G,destination=/mnt/data \
		-it localhost/hive

run-beeline:
	podman run --pod local \
		-it localhost/beeline

run-elasticsearch:
	podman run --pod local \
		-it localhost/elasticsearch

run-presto:
	podman run --pod local --init \
		--mount type=tmpfs,tmpfs-size=4G,destination=/mnt/data \
		-it localhost/presto bash
