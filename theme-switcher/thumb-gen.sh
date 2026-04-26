#!/usr/bin/env bash
# thumb-gen.sh - Genera miniaturas para el selector de temas

THUMB_DIR="$HOME/.cache/theme-picker/thumbs"
mkdir -p "$THUMB_DIR"

get_thumb() {
    local src="$1"
    local hash=$(md5sum <<< "$src" | cut -c1-32)
    local thumb="$THUMB_DIR/$hash.jpg"
    
    if [[ ! -f "$thumb" || "$src" -nt "$thumb" ]]; then
        magick "$src"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 -quality 85 "$thumb" 2>/dev/null
    fi
    echo "$thumb"
}

# Si se llama con un argumento, devuelve el path del thumb
if [[ -n "${1:-}" ]]; then
    get_thumb "$1"
fi
