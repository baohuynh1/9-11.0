#!/bin/bash
# run-course-service.sh - Chay container rikkei-course-service tu image nginxdemos/hello
set -e

CONTAINER_NAME="rikkei-course-service"
IMAGE="nginxdemos/hello"

# Xoa container cu cung ten (neu co) de tranh loi Conflict khi chay lai
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# -d: chay ngam | --name: dat ten | -p 8081:80: cong host 8081 -> cong 80 cua container
docker run -d --name "$CONTAINER_NAME" -p 8081:80 "$IMAGE"

# Kiem tra container dang chay
docker ps --filter name="$CONTAINER_NAME"

# Doi nginx khoi dong roi goi thu
sleep 2
curl http://localhost:8081
