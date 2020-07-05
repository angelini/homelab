#!/usr/bin/env bash

set -e
shopt -s globstar

function database_exists() {
  psql -h localhost -p 8002 -lqt | cut -d \| -f 1 | grep -wq $1
}

export CLASSPATH="${CLASSPATH}:$(hadoop classpath)"

for lib in ${HIVE_HOME}/lib/**/*.jar; do
    echo "hive lib ${lib}"
    export CLASSPATH="${CLASSPATH}:${lib}"
done

set -x

if ! database_exists metastore; then
    createdb -h localhost -p 8002 metastore
    schematool -initSchema -dbType postgres
fi

# exec bash

# hiveserver2 start &
exec hiveserver2 --service metastore
# exec java org.apache.hadoop.hive.metastore.HiveMetaStore
