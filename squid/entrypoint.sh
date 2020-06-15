#!/bin/bash

set -ex

squid --foreground -z
squid

touch /var/spool/squid/squid_access.log
exec tail -f /var/spool/squid/squid_access.log
