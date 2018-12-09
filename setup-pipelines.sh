#!/usr/bin/env bash

SECONDS=0
while [ $(curl -I -o /dev/null -w "%{http_code}" http://localhost:9200) != 200 ]
do
  if [ $SECONDS -gt 300 ]
  then
    echo "Tired of waiting. I don't think elasticsearch is coming up..."
    exit 1
  fi
  echo "Doesn't look like elasticsearch is up yet. Waiting 5 seconds before trying again..."
  sleep 5s
done

for filename in ./pipelines/*.json; do
  pipeline=$(basename -- "$filename")
  pipeline=${filename%.*}
  curl -vX PUT http://localhost:9200/_ingest/pipeline/$pipeline -d @$filename --header "Content-Type: application/json"
done