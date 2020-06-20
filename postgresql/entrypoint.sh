#!/usr/bin/env bash

set -ex

mkdir -p /mnt/data/db

if [[ -z "$(ls -A /mnt/data/db)" ]]; then
    initdb /mnt/data/db
fi

cp ./postgresql.conf /mnt/data/db/postgresql.conf

exec postgres -D /mnt/data/db
