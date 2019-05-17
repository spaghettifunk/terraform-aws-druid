#!/bin/sh
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER druid WITH PASSWORD 'druid';
    CREATE DATABASE druid;
    GRANT ALL PRIVILEGES ON DATABASE druid TO druid;
EOSQL