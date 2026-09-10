#!/bin/bash

SRC_DIR="/data/processing"
OUT_DIR="/data/output"
LOG_FILE="/var/log/datashield/analyzer.log"
S3_BUCKET="s3://<your-bucket-name>"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

for file in "$SRC_DIR"/*; do
    [ -e "$file" ] || continue

    filename=$(basename "$file")
    line_count=$(wc -l < "$file")
    report="$OUT_DIR/${filename%.*}_report.txt"

    {
        echo "File: $filename"
        echo "Processed at: $(date)"
        echo "Line count: $line_count"
    } > "$report"

    cp "$file" "$OUT_DIR/$filename"

    log "PROCESSED $filename - $line_count lines - report generated"

    aws s3 cp "$OUT_DIR/$filename" "$S3_BUCKET/processed/"
    aws s3 cp "$report" "$S3_BUCKET/reports/"

    log "UPLOADED $filename and report to S3"

    rm "$file"
done
