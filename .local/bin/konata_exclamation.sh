#!/bin/bash

FILE=~/downloads/exclamation.mp3

if [ ! -f "$FILE" ]; then
  echo "Error: File '$FILE' not found!"
  exit 1
fi

ffplay -nodisp -autoexit "$FILE"
