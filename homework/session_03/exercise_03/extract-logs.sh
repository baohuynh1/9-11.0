#!/bin/bash
# extract-logs.sh - Trich xuat 15 dong log cuoi (kem timestamps) cua rikkei-course-service

CONTAINER_NAME="rikkei-course-service"

# Gia lap truy cap de container co du log
for i in $(seq 1 20); do
    curl -s -o /dev/null http://localhost:8081
done

# Lay 15 dong log cuoi, kem moc thoi gian
docker logs --tail 15 -t "$CONTAINER_NAME"
