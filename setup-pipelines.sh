#!/usr/bin/env bash

CODE=0
while [ $CODE != 200 ]
do
  if [ $SECONDS > 300 ] then
    echo "Tired of waiting. I don't think elasticsearch is coming up..."
    exit 1
  fi
  echo "Received $CODE response from elasticsearch. Waiting 5 seconds then trying again..."
  sleep 5s
  CODE=`curl -I -o /dev/null -w "%{http_code}" http://localhost:9200`
done

for filename in ./pipelines/*.json; do
  pipeline=$(basename -- "$filename")
  pipeline=${filename%.*}
  curl -vX PUT http://localhost:9200/_ingest/pipeline/$pipeline -d @$filename --header "Content-Type: application/json"
done