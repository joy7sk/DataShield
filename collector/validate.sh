#!/bin/bash

SRC_DIR="/data/incoming"
VALID_DIR="/data/validated"
REJECT_DIR="/data/rejected"
LOG_FILE="/var/log/datashield/collector.log"

ALLOWED_EXT="csv|txt|json"
MAX_SIZE_KB=10240

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

for file in "$SRC_DIR"/*; do
    [ -e "$file" ] || continue

    filename=$(basename "$file")
    ext="${filename##*.}"
    size_kb=$(du -k "$file" | cut -f1)

    if [[ ! "$ext" =~ ^($ALLOWED_EXT)$ ]]; then
        log "REJECTED $filename - invalid extension .$ext"
        mv "$file" "$REJECT_DIR/"
        continue
    fi

    if [ "$size_kb" -gt "$MAX_SIZE_KB" ]; then
        log "REJECTED $filename - exceeds max size ($size_kb KB)"
        mv "$file" "$REJECT_DIR/"
        continue
    fi

    if [ ! -s "$file" ]; then
        log "REJECTED $filename - empty file"
        mv "$file" "$REJECT_DIR/"
        continue
    fi

    mv "$file" "$VALID_DIR/"
    log "ACCEPTED $filename - moved to validated"
done
