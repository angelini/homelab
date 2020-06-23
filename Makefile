CURRENT_IP := $(shell ip -o -4 addr list wlp37s0 | awk '{print $$4}' | cut -d/ -f1)

HADOOP_VERSION ?= 3.2.1
AWS_SDK_VERSION ?= 1.11.807
GUAVA_VERSION ?= 29.0
HIVE_VERSION ?= 3.1.2
PRESTO_VERSION ?= 0.235.1
ES_VERSION ?= 7.7.0
SPARK_VERSION ?= 3.0.0
MINIO_VERSION ?= 2020-06-22T03-12-50Z

MIRROR_ROOT := /opt/mirror

HADOOP_PATH := ${MIRROR_ROOT}/hadoop/common/hadoop-${HADOOP_VERSION}
HADOOP_AWS_PATH := ${MIRROR_ROOT}/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}
AWS_SDK_PATH := ${MIRROR_ROOT}/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}
GUAVA_PATH := ${MIRROR_ROOT}/maven2/com/google/guava/guava/${GUAVA_VERSION}-jre
HIVE_PATH := ${MIRROR_ROOT}/hive/hive-${HIVE_VERSION}
PRESTO_PATH := ${MIRROR_ROOT}/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}
PRESTO_CLI_PATH := ${MIRROR_ROOT}/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}
ES_PATH := ${MIRROR_ROOT}/downloads/elasticsearch
SPARK_PATH := ${MIRROR_ROOT}/spark/spark-${SPARK_VERSION}
MINIO_PATH := ${MIRROR_ROOT}/server/minio/release/linux-amd64/archive

TAXI_DATA_PATH := ${MIRROR_ROOT}/nyc-tlc/trip+data

${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz:
	mkdir -p "${HADOOP_PATH}"
	curl -Lso "${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz" \
		"http://apache.mirror.iphh.net/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

${HADOOP_AWS_PATH}/hadoop-aws-${HADOOP_VERSION}.jar:
	mkdir -p "${HADOOP_AWS_PATH}"
	curl -Lso "${HADOOP_AWS_PATH}/hadoop-aws-${HADOOP_VERSION}.jar" \
		"https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar"

${AWS_SDK_PATH}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar:
	mkdir -p "${AWS_SDK_PATH}"
	curl -Lso "${AWS_SDK_PATH}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar" \
		"https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar"

${GUAVA_PATH}/guava-${GUAVA_VERSION}-jre.jar:
	mkdir -p "${GUAVA_PATH}"
	curl -Lso "${GUAVA_PATH}/guava-${GUAVA_VERSION}-jre.jar" \
		"https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA_VERSION}-jre/guava-${GUAVA_VERSION}-jre.jar"

${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz:
	mkdir -p "${HIVE_PATH}"
	curl -Lso "${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz" \
		"http://apache.mirror.iphh.net/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"

${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz:
	mkdir -p "${PRESTO_PATH}"
	curl -Lso "${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz" \
		"https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz"

${PRESTO_CLI_PATH}/presto-cli-${PRESTO_VERSION}-executable.jar:
	mkdir -p "${PRESTO_CLI_PATH}"
	curl -Lso "${PRESTO_CLI_PATH}/presto-cli-${PRESTO_VERSION}-executable.jar" \
		"https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar"

${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz:
	mkdir -p "${ES_PATH}"
	curl -Lso "${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz" \
		"https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz"

${SPARK_PATH}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz:
	mkdir -p "${SPARK_PATH}"
	curl -Lso "${SPARK_PATH}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz" \
	    "http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz"

${MINIO_PATH}/minio.RELEASE.${MINIO_VERSION}:
	mkdir -p "${MINIO_PATH}"
	curl -Lso "${MINIO_PATH}/minio.RELEASE.${MINIO_VERSION}" \
		"https://dl.min.io/server/minio/release/linux-amd64/archive/minio.RELEASE.${MINIO_VERSION}"

${TAXI_DATA_PATH}:
	mkdir -p "${TAXI_DATA_PATH}"
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-01.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-01.csv
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-02.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-02.csv
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-03.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-03.csv
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-04.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-04.csv
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-05.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-05.csv
	curl -Lso "${TAXI_DATA_PATH}/yellow_tripdata_2019-06.csv" https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-06.csv

update-mirror: ${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz \
	${HADOOP_AWS_PATH}/hadoop-aws-${HADOOP_VERSION}.jar \
	${AWS_SDK_PATH}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar \
	${GUAVA_PATH}/guava-${GUAVA_VERSION}-jre.jar \
	${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
	${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz \
	${PRESTO_CLI_PATH}/presto-cli-${PRESTO_VERSION}-executable.jar \
	${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
	${SPARK_PATH}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz \
	${MINIO_PATH}/minio.RELEASE.${MINIO_VERSION} \
	${TAXI_DATA_PATH}

.PHONY: create-pod start-mirror
.PHONY: build-base build-jdk-8 build-jdk-11 build-postgresql build-hive build-elasticsearch build-presto build-presto-cli build-spark build-minio
.PHONY: run-base run-jdk-8 run-jdk-11 run-postgresql run-hive run-elasticsearch run-presto run-presto-cli run-spark run-minio
.PHONY: attach-base attach-spark attach-minio

start-mirror: update-mirror
	python -m http.server 8080 --directory ${MIRROR_ROOT}

create-pod:
	podman pod create -n local -p 8002:8002 -p 8004:8004 -p 8005:8005

build-base:
	podman build -f ./base/Containerfile -t base --network host

build-jdk-8: build-base
	podman build -f ./jdk-8/Containerfile -t jdk-8 --network host

build-jdk-11: build-base
	podman build -f ./jdk-11/Containerfile -t jdk-11 --network host

build-postgresql: build-base
	podman build -f ./postgresql/Containerfile -t postgresql --network host

build-hive: build-jdk-8
	podman build -f ./hive/Containerfile -t hive --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080" --build-arg "HADOOP_VERSION=${HADOOP_VERSION}" --build-arg "HIVE_VERSION=${HIVE_VERSION}"

build-elasticsearch: build-jdk-11
	podman build -f ./elasticsearch/Containerfile -t elasticsearch --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

build-presto: build-jdk-11
	podman build -f ./presto/Containerfile -t presto --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

build-presto-cli: build-presto
	podman build -f ./presto-cli/Containerfile -t presto-cli --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

build-spark: build-jdk-11
	podman build -f ./spark/Containerfile -t spark --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

build-minio: build-base
	podman build -f ./minio/Containerfile -t minio --network host \
		--build-arg "MIRROR=${CURRENT_IP}:8080"

run-base:
	podman run --name base --pod local \
		--rm -it localhost/base

run-jdk-8:
	podman run --name jdk-8 --pod local \
		--rm -it localhost/jdk-8

run-jdk-11:
	podman run --name jdk-11 --pod local \
		--rm -it localhost/jdk-11

run-postgresql:
	podman run --name postgresql --pod local \
		--mount type=tmpfs,tmpfs-size=4G,destination=/mnt/data,tmpfs-mode=777 \
		--rm -it localhost/postgresql

run-hive:
	podman run --name hive --pod local \
		--mount type=tmpfs,tmpfs-size=4G,destination=/mnt/data \
		--rm -it localhost/hive

run-elasticsearch:
	podman run --name elasticsearch --pod local \
		--rm -it localhost/elasticsearch

run-presto:
	podman run --name presto --pod local --init \
		--mount type=tmpfs,tmpfs-size=4G,destination=/mnt/data \
		--rm -it localhost/presto

run-presto-cli:
	podman run --name presto-cli --pod local \
		--rm -it localhost/presto-cli

run-spark:
	podman run --name spark --pod local \
		--rm -it localhost/spark

run-minio:
	podman run --name minio --pod local \
		--mount type=volume,source=minio-data,target=/mnt/data \
		--rm -it localhost/minio

attach-base:
	podman exec -it base bash

attach-spark:
	podman exec -it spark bash

attach-minio:
	podman exec -it minio bash
