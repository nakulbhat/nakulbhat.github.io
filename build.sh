#!/bin/bash
set -e

# Install Pandoc (no root needed)
PANDOC_VERSION="3.9"
curl -sSL "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz" \
  | tar -xz -C /tmp
export PATH="/tmp/pandoc-${PANDOC_VERSION}/bin:$PATH"

# Install html-minifier-terser
npm install html-minifier-terser

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
  ./node_modules/.bin/html-minifier-terser --collapse-whitespace --remove-comments --minify-css true -o "$output" "$output"
done
