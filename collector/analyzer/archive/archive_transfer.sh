#!/bin/bash

LOG_FILE="/var/log/datashield/archive.log"

OLD_FILES=$(find /data/validated -type f -mtime +7)

for f in $OLD_FILES; do
    scp -i /home/collector-svc/.ssh/archive_key \
    -o StrictHostKeyChecking=no \
    "$f" archive-svc@<ARCHIVE_PRIVATE_IP>:/mnt/archive/

    echo "$(date '+%Y-%m-%d %H:%M:%S') ARCHIVED $(basename $f)" >> "$LOG_FILE"

    rm "$f"
done
