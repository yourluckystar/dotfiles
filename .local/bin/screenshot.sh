#!/bin/bash

SCREENSHOT_DIR=~/screenshots

FILENAME=$(date +"screenshot_%Y%m%d_%H%M%S.png")
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

grim -g "$(slurp -d)" "$FILEPATH"
wl-copy < "$FILEPATH"

notify-send "Screenshot saved to $FILEPATH" "Also copied it to clipboard"
