#!/bin/bash
set -e

# Install dependencies
apt-get install -y pandoc
npm install -g html-minifier-terser

# Build HTML
mkdir -p public

# Convert all .md files, preserve structure
find . -type f -name "*.md" \
  -not -path "./.github/*" | while read file; do
  output="public/${file#./}"
  output="${output%.md}.html"
  mkdir -p "$(dirname "$output")"
  pandoc -s "$file" \
    --template=template.html \
    -o "$output"
  html-minifier-terser --collapse-whitespace --remove-comments --minify-css true -o "$output" "$output"
done
