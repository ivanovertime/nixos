#!/usr/bin/env bash
# lf previewer: $1 = file, $2 = width, $3 = height, $4 = x, $5 = y, $6 = mode
set -f

f="$1"
w="$2"
h="$3"

mime=$(file -Lb --mime-type -- "$f" 2>/dev/null)

# archives
case "$f" in
  *.tar | *.tar.gz | *.tgz | *.tar.bz2 | *.tbz2 | *.tar.xz | *.txz | *.tar.zst)
    tar tf "$f" 2>/dev/null | head -n 80
    exit 0
    ;;
  *.zip)
    unzip -l "$f" 2>/dev/null | head -n 80
    exit 0
    ;;
esac

case "$mime" in
  # images (chafa renders with unicode symbols, no sixel needed)
  image/*)
    chafa --format symbols --size "${w}x${h}" -- "$f" 2>/dev/null
    ;;
  # text/code
  text/*)
    bat --color=always --style=plain -- "$f" 2>/dev/null | head -n 200
    ;;
  *)
    file -b -- "$f" 2>/dev/null
    ;;
esac