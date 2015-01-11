#! /bin/sh

docker build -t headlinie_api:tests .
docker run headlinie_api:tests /headlinie/scripts/run-tests-locally.sh
