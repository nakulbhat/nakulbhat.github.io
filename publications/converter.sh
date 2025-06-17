#!/bin/bash

# Usage: ./extract_first_page.sh input.pdf output.jpg

# Check if correct number of arguments provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.pdf output.jpg"
    exit 1
fi

INPUT_PDF="$1"
OUTPUT_JPG="$2"

# Extract the first page and convert it to JPEG
pdftoppm -jpeg -f 1 -l 1 "$INPUT_PDF" temp_page

# Rename the output to desired output file
mv temp_page-1.jpg "$OUTPUT_JPG"

echo "First page extracted to $OUTPUT_JPG"
