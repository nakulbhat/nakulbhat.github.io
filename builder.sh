mkdir public

  # convert all .md files, preserve structure
  find . -type f -name "*.md" \
      -not -path "./.github/*" | while read file; do

  output="public/${file#./}"
  output="${output%.md}.html"

  mkdir -p "$(dirname "$output")"

  pandoc -s "$file" \
      --template=template.html \
      -o "$output"
  done
