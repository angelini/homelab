#!/usr/bin/env bash

set -e
shopt -s globstar

for lib in ${HADOOP_HOME}/share/hadoop/**/*.jar; do
    echo "hadoop lib ${lib}"
    export CLASSPATH="${CLASSPATH}:${lib}"
done

for lib in ${HIVE_HOME}/lib/**/*.jar; do
    echo "hive lib ${lib}"
    export CLASSPATH="${CLASSPATH}:${lib}"
done

set -x

schematool -initSchema -dbType derby

exec java org.apache.hadoop.hive.metastore.HiveMetaStore
