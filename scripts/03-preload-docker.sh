#!/usr/bin/env bash
set -uo pipefail
systemctl start docker
IMAGES="hello-world:latest nginx:latest httpd:latest ubuntu:22.04 ubuntu:24.04
debian:stable alpine:latest busybox:latest python:3.12 node:20 mysql:8
postgres:16 redis:7 mongo:7 grafana/grafana:latest prom/prometheus:latest
jenkins/jenkins:lts"
for img in $IMAGES; do
  docker pull "$img" || echo "FAILED: $img" >> /root/failed-items.txt
done
docker images