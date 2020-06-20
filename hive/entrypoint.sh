#!/usr/bin/env bash

set -e
shopt -s globstar

function database_exists() {
  psql -h localhost -p 8002 -lqt | cut -d \| -f 1 | grep -wq $1
}

for lib in ${HADOOP_HOME}/share/hadoop/**/*.jar; do
    echo "hadoop lib ${lib}"
    export CLASSPATH="${CLASSPATH}:${lib}"
done

for lib in ${HIVE_HOME}/lib/**/*.jar; do
    echo "hive lib ${lib}"
    export CLASSPATH="${CLASSPATH}:${lib}"
done

set -x

if ! database_exists metastore; then
    createdb -h localhost -p 8002 metastore
    schematool -initSchema -dbType postgres
fi

exec java org.apache.hadoop.hive.metastore.HiveMetaStore
