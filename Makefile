HADOOP_VERSION ?= 3.2.1
AWS_SDK_VERSION ?= 1.11.811
GUAVA_VERSION ?= 29.0
HIVE_VERSION ?= 3.1.2
PRESTO_VERSION ?= 0.235.1
ES_VERSION ?= 7.7.0
SPARK_VERSION ?= 3.0.0
MINIO_VERSION ?= 2020-06-22T03-12-50Z
MC_VERSION ?= 2020-06-20T00-18-43Z

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
MC_PATH := ${MIRROR_ROOT}/client/mc/release/linux-amd64/archive

TAXI_DATA_PATH := ${MIRROR_ROOT}/nyc-tlc/trip+data

define download_file
	mkdir -p "$(1)"
	curl -Lfso "$(1)/$(2)" "$(3)"
endef

${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz:
	$(call download_file,${HADOOP_PATH},hadoop-${HADOOP_VERSION}.tar.gz,http://apache.mirror.iphh.net/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz)

${HADOOP_AWS_PATH}/hadoop-aws-${HADOOP_VERSION}.jar:
	$(call download_file,${HADOOP_AWS_PATH},hadoop-aws-${HADOOP_VERSION}.jar,https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar)

${AWS_SDK_PATH}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar:
	$(call download_file,${AWS_SDK_PATH},aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar,https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar)

${GUAVA_PATH}/guava-${GUAVA_VERSION}-jre.jar:
	$(call download_file,${GUAVA_PATH},guava-${GUAVA_VERSION}-jre.jar,https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA_VERSION}-jre/guava-${GUAVA_VERSION}-jre.jar)

${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz:
	$(call download_file,${HIVE_PATH},apache-hive-${HIVE_VERSION}-bin.tar.gz,http://apache.mirror.iphh.net/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz)

${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz:
	$(call download_file,${PRESTO_PATH},presto-server-${PRESTO_VERSION}.tar.gz,https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz)

${PRESTO_CLI_PATH}/presto-cli-${PRESTO_VERSION}-executable.jar:
	$(call download_file,${PRESTO_CLI_PATH},presto-cli-${PRESTO_VERSION}-executable.jar,https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar)

${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz:
	$(call download_file,${ES_PATH},elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz,https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz)

${SPARK_PATH}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz:
	$(call download_file,${SPARK_PATH},spark-${SPARK_VERSION}-bin-without-hadoop.tgz,http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz)

${MINIO_PATH}/minio.RELEASE.${MINIO_VERSION}:
	$(call download_file,${MINIO_PATH},minio.RELEASE.${MINIO_VERSION},https://dl.min.io/server/minio/release/linux-amd64/archive/minio.RELEASE.${MINIO_VERSION})

${MC_PATH}/mc.RELEASE.${MC_VERSION}:
	$(call download_file,${MC_PATH},mc.RELEASE.${MC_VERSION},https://dl.min.io/client/mc/release/linux-amd64/archive/mc.RELEASE.${MC_VERSION})

${TAXI_DATA_PATH}:
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-01.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-01.csv)
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-02.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-02.csv)
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-03.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-03.csv)
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-04.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-04.csv)
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-05.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-05.csv)
	$(call download_file,${TAXI_DATA_PATH},yellow_tripdata_2019-06.csv,https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2019-06.csv)

update-mirror: ${HADOOP_PATH}/hadoop-${HADOOP_VERSION}.tar.gz \
	${HADOOP_AWS_PATH}/hadoop-aws-${HADOOP_VERSION}.jar \
	${AWS_SDK_PATH}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar \
	${GUAVA_PATH}/guava-${GUAVA_VERSION}-jre.jar \
	${HIVE_PATH}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
	${PRESTO_PATH}/presto-server-${PRESTO_VERSION}.tar.gz \
	${PRESTO_CLI_PATH}/presto-cli-${PRESTO_VERSION}-executable.jar \
	${ES_PATH}/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
	${SPARK_PATH}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
	${MINIO_PATH}/minio.RELEASE.${MINIO_VERSION} \
	${MC_PATH}/mc.RELEASE.${MC_VERSION} \
	${TAXI_DATA_PATH}

.PHONY: create-pod start-mirror
.PHONY: build-base build-jdk-8 build-jdk-11 build-postgresql build-hadoop build-hive build-elasticsearch build-presto build-presto-cli build-spark build-minio build-mc
.PHONY: run-base run-jdk-8 run-jdk-11 run-postgresql run-hadoop run-hive run-elasticsearch run-presto run-presto-cli run-spark run-minio run-mc
.PHONY: attach-base attach-hive attach-spark attach-minio

start-mirror: update-mirror
	dnf -y makecache --setopt=cachedir=/opt/dnfcache
	python -m http.server 8080 --directory ${MIRROR_ROOT}

create-pod:
	podman pod create -n local -p 8002:8002 -p 8004:8004 -p 8005:8005

define build
	podman build --file "./$(1)/Containerfile" --tag "$(1)" --network host $(2)
endef
# TODO: Fix dnf metadata cache
# --volume /opt/dnfcache:/var/cache/dnf:O

build-test:
	$(call build,test,)

build-base:
	$(call build,base,)

build-jdk-8: build-base
	$(call build,jdk-8,)

build-jdk-11: build-base
	$(call build,jdk-11,)

build-postgresql: build-base
	$(call build,postgresql,)

build-hadoop: build-jdk-8
	$(call build,hadoop, \
		--build-arg "MIRROR=localhost:8080" --build-arg "HADOOP_VERSION=${HADOOP_VERSION}" --build-arg "AWS_SDK_VERSION=${AWS_SDK_VERSION}")

build-hive: build-hadoop
	$(call build,hive, \
		--build-arg "MIRROR=localhost:8080" --build-arg "HIVE_VERSION=${HIVE_VERSION}")

build-elasticsearch: build-jdk-11
	$(call build,elasticsearch, \
		--build-arg "MIRROR=localhost:8080" --build-arg "ES_VERSION=${ES_VERSION}")

build-presto: build-jdk-11
	$(call build,presto, \
		--build-arg "MIRROR=localhost:8080" --build-arg "PRESTO_VERSION=${PRESTO_VERSION}")

build-presto-cli: build-presto
	$(call build,presto-cli, \
		--build-arg "MIRROR=localhost:8080")

build-spark: build-hadoop
	$(call build,spark, \
		--build-arg "MIRROR=localhost:8080" --build-arg "SPARK_VERSION=${SPARK_VERSION}")

build-minio: build-base
	$(call build,minio, \
		--build-arg "MIRROR=localhost:8080" --build-arg "MINIO_VERSION=${MINIO_VERSION}")

build-mc: build-base
	$(call build,mc, \
		--build-arg "MIRROR=localhost:8080" --build-arg "MC_VERSION=${MC_VERSION}")

define run
	podman run --name $(1) --pod local $(2) --rm -it localhost/$(1)
endef
comma := ,

run-base:
	$(call run,base,)

run-jdk-8:
	$(call run,jdk-8,)

run-jdk-11:
	$(call run,jdk-11,)

run-postgresql:
	$(call run,postgresql, \
		--mount type=tmpfs$(comma)tmpfs-size=4G$(comma)destination=/mnt/data$(comma)tmpfs-mode=777)

run-hadoop:
	$(call run,hadoop,)

run-hive:
	$(call run,hive, \
		--mount type=tmpfs$(comma)tmpfs-size=4G$(comma)destination=/mnt/data)

run-elasticsearch:
	$(call run,elasticsearch,)

run-presto:
	$(call run,presto, \
		--mount type=tmpfs$(comma)tmpfs-size=4G$(comma)destination=/mnt/data)

run-presto-cli:
	$(call run,presto-cli,)

run-spark:
	$(call run,spark,)

run-minio:
	$(call run,minio, \
		--mount type=volume$(comma)source=minio-data$(comma)target=/mnt/data)

run-mc:
	$(call run,mc,)

define attach
	podman exec -it $(1) bash
endef

attach-base:
	$(call attach,base)

attach-hive:
	$(call attach,hive)

attach-spark:
	$(call attach,spark)

attach-minio:
	$(call attach,minio)
