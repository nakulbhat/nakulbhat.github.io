#!/usr/bin/env bash
set -e

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
  html-minifier --collapse-whitespace --remove-comments --minify-css true -o "$output" "$output"
done
