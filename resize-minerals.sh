#!/bin/bash
# resize-minerals.sh
#
# Resizes all JPG/JPEG images in the current folder to a maximum of 1920px
# on the longest side, at 85% JPEG quality. Output goes into ./output/
# Never enlarges images that are already smaller than 1920px.
#
# Usage:
#   1. Put this script in the folder with your images
#   2. chmod +x resize-minerals.sh
#   3. ./resize-minerals.sh

INPUT_DIR="$(pwd)"
OUTPUT_DIR="$INPUT_DIR/output"
MAX_SIZE=1920
QUALITY=85

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
files=("$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.JPG "$INPUT_DIR"/*.jpeg "$INPUT_DIR"/*.JPEG)

if [ ${#files[@]} -eq 0 ]; then
  echo "No JPG files found in $INPUT_DIR"
  exit 1
fi

echo "Found ${#files[@]} image(s). Resizing to max ${MAX_SIZE}px, quality ${QUALITY}%..."
echo "Output → $OUTPUT_DIR"
echo ""

for f in "${files[@]}"; do
  filename=$(basename "$f")
  outfile="$OUTPUT_DIR/$filename"

  magick "$f" \
    -resize "${MAX_SIZE}x${MAX_SIZE}>" \
    -quality "$QUALITY" \
    -strip \
    "$outfile"

  insize=$(du -sh "$f" | cut -f1)
  outsize=$(du -sh "$outfile" | cut -f1)
  echo "  $filename  $insize → $outsize"
done

echo ""
echo "Done. ${#files[@]} image(s) written to $OUTPUT_DIR"
