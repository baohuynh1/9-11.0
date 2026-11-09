#!/bin/bash
# exec-frontend.sh - Chay rikkei-frontend-qa voi bien moi truong va mo bash ben trong container

CONTAINER_NAME="rikkei-frontend-qa"

# Xoa container cu cung ten (neu co)
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# -e: truyen bien moi truong vao container
docker run -d --name "$CONTAINER_NAME" \
  -e API_ENDPOINT=https://qa-api.rikkei.edu.vn \
  nginx

# Mo bash shell tuong tac ben trong container
# (Ben trong go: echo $API_ENDPOINT, sau do: exit)
docker exec -it "$CONTAINER_NAME" bash
