#!/bin/bash

POSTGRES=${POSTGRES_HOST:-appartment_searchs_db}
POSTGRES_PORT=5432

echo "Waiting for $POSTGRES:$POSTGRES_PORT"
./deploy/waitforit.sh $POSTGRES:$POSTGRES_PORT -t 0 -- echo "$POSTGRES:$POSTGRES_PORT is up"


echo "Executing migrations" && rake db:migrate || \
  ( echo "No migrations found, setting up database" && rake db:setup ) && \
echo "Executing rails" &&  \

exec rails server -b '0.0.0.0' -p 3005