mkdir public#!/usr/bin/env bash
set -euo pipefail

# Local build script — equivalent to the GitHub Actions workflow
# Usage: ./build.sh
# Requires: pandoc, html-minifier (npm), cleancss (npm)
#
# On NixOS, run with:
#   nix-shell -p pandoc nodejs --run ./build.sh
# Or add to your shell.nix / devShell.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUBLIC_DIR="$REPO_ROOT/public"

# ── Preflight checks ────────────────────────────────────────────────────────
check_dep() {
  if ! command -v "$1" &>/dev/null; then
    echo "❌  Missing dependency: $1"
    echo "    On NixOS: nix-shell -p $2"
    exit 1
  fi
}

check_dep pandoc     "pandoc"
check_dep html-minifier "nodePackages.html-minifier" 2>/dev/null || \
  check_dep html-minifier "nodejs (then: npm install -g html-minifier clean-css-cli)"
check_dep cleancss   "nodePackages.clean-css-cli"

# ── Build HTML ───────────────────────────────────────────────────────────────
echo "🔨  Building HTML..."
rm -rf "$PUBLIC_DIR"
mkdir -p "$PUBLIC_DIR"

find "$REPO_ROOT" -type f -name "*.md" \
  -not -path "$REPO_ROOT/.github/*" \
  -not -path "$PUBLIC_DIR/*" | while read -r file; do

  relative="${file#"$REPO_ROOT"/}"
  output="$PUBLIC_DIR/${relative%.md}.html"
  mkdir -p "$(dirname "$output")"

  pandoc -s "$file" \
    --template="$REPO_ROOT/template.html" \
    -o "$output"
done

# ── Minify HTML ──────────────────────────────────────────────────────────────
echo "🗜   Minifying HTML..."
find "$PUBLIC_DIR" -type f -name "*.html" | while read -r file; do
  html-minifier \
    --collapse-whitespace \
    --remove-comments \
    --remove-optional-tags \
    --remove-redundant-attributes \
    --remove-script-type-attributes \
    --minify-css true \
    --minify-js true \
    "$file" -o "$file"
done

# ── Minify CSS ───────────────────────────────────────────────────────────────
CSS="$PUBLIC_DIR/assets/css/styles.css"
if [[ -f "$CSS" ]]; then
  echo "🎨  Minifying CSS..."
  cleancss -o "$CSS" "$CSS"
else
  echo "⚠️   No CSS found at $CSS — skipping CSS minification."
fi

# ── Copy assets ──────────────────────────────────────────────────────────────
if [[ -d "$REPO_ROOT/assets" ]]; then
  echo "📁  Copying assets..."
  cp -r "$REPO_ROOT/assets" "$PUBLIC_DIR/assets"
fi

echo ""
echo "✅  Build complete → $PUBLIC_DIR"
echo "    To preview locally:"
echo "      cd $PUBLIC_DIR && python3 -m http.server 8080"
