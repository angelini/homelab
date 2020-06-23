#!/usr/bin/env bash

set -ex

mkdir -p /mnt/data/minio

exec minio server --address :8005 /mnt/data/minio
