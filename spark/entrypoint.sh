#!/usr/bin/env bash

set -ex

export SPARK_DIST_CLASSPATH=$(hadoop classpath)

exec spark-shell --driver-memory 2g
