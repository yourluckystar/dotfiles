#!/bin/bash

ART_DIR="$HOME/art"

EXTRACT_DIR="/tmp/kra_extract"
mkdir -p "$EXTRACT_DIR"

extract_time() {
    kra_file="$1"

    local temp_dir="$EXTRACT_DIR/$(basename "$kra_file")"
    mkdir -p "$temp_dir"
    unzip -q "$kra_file" -d "$temp_dir"

    local time_spent=0
    if [ -f "$temp_dir/documentinfo.xml" ]; then
        time_spent=$(grep -oP '(?<=<editing-time>)[0-9]+(?=</editing-time>)' "$temp_dir/documentinfo.xml")
    fi

    rm -rf "$temp_dir"
    echo "$time_spent"
}

for kra_file in $(find "$ART_DIR" -type f -iname "*.kra"); do
    file_time=$(extract_time "$kra_file")
    drawing_time=$((drawing_time + file_time))
done

hours=$((drawing_time / 3600))
minutes=$(((drawing_time % 3600) / 60))
seconds=$((drawing_time % 60))

echo "$hours hours, $minutes minutes"
