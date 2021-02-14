#!/bin/bash

# # https://docs.docker.com/compose/startup-order/
# set -e
# until PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "postgres" -c '\q'; do
#   >&2 echo "Postgres is unavailable - sleeping"
#   sleep 1
# done
#
# >&2 echo "Postgres is up - executing command"

asterisk -vvvvvgc
