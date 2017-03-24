#!/usr/bin/env bash

if [ "$SERVER" = "couchdb-master" ]; then
  # Install CouchDB Master
  docker build -t couchdb docker/couchdb
  docker run -d -p 3001:5984 -e master --name couchdb couchdb
  COUCH_PORT=3001
elif [ "$SERVER" = "couchdb-2.0" ]; then
  # Install CouchDB Master
  docker build -t couchdb docker/couchdb
  docker run -d -p 3002:5984 -e 2.0.0 --name couchdb couchdb
  COUCH_PORT=3002
else
  # Install CouchDB Stable
  docker run -d -p 3000:5984 klaemo/couchdb:1.6.1
  COUCH_PORT=3000
fi

# wait for couchdb to start, add cors
npm install add-cors-to-couchdb
while [ '200' != $(curl -s -o /dev/null -w %{http_code} http://127.0.0.1:${COUCH_PORT}) ]; do
  echo waiting for couch to load... ;
  sleep 1;
done
./node_modules/.bin/add-cors-to-couchdb http://127.0.0.1:${COUCH_PORT}
