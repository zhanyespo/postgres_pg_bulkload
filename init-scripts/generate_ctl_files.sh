#!/bin/bash

CSV_DIR="/csv_files"
CTL_DIR="./ctls"

mkdir -p "$CTL_DIR"

declare -A CSV_TABLE_MAP=(
    ["authors.csv"]="authors"
    ["comments.csv"]="comments"
    ["submissions.csv"]="submissions"
    ["subreddits.csv"]="subreddits"
)

for CSV_FILE in "${!CSV_TABLE_MAP[@]}"; do
    TABLE_NAME="${CSV_TABLE_MAP[$CSV_FILE]}"
    CTL_FILE="$CTL_DIR/${TABLE_NAME}.ctl"

    cat > "$CTL_FILE" <<EOL
INPUT = $CSV_DIR/$CSV_FILE
OUTPUT = $TABLE_NAME
DELIMITER = ,
SKIP = 1
EOL

    dos2unix "$CTL_FILE" 2>/dev/null || sed -i 's/\r$//' "$CTL_FILE"
done
