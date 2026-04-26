#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/theme-switcher"
THEME="${1:-}"
THEME_PATH="$BASE/themes/$THEME"

COLORS="$THEME_PATH/colors.json"
THEME_JSON="$THEME_PATH/theme.json"
TPL="$THEME_PATH/templates/hyprland.conf.tpl"
OUT="$HOME/.config/hypr/generated-theme.conf"

# Set theme. This will allow all components load the theme earlier.
[[ -z "$THEME" ]] && { echo "Usage: apply-theme.sh <theme>"; exit 1; }
[[ ! -d "$THEME_PATH" ]] && { echo "Theme not found: $THEME_PATH"; exit 1; }

[[ ! -f "$THEME_JSON" ]] && { echo "Missing: $THEME_JSON"; exit 1; }
[[ ! -f "$TPL" ]] && { echo "Missing: $TPL"; exit 1; }

# --------- Matugen: Dynamic theme ----------
if [[ "$THEME" == "dynamic" ]]; then
  WP="${2:-}"

  if [[ -z "$WP" ]]; then
    WP_DIR="$HOME/Imágenes/wallpapers"
    [[ ! -d "$WP_DIR" ]] && WP_DIR="$HOME/Imágenes"

    # Graphical selector (inspired by Super+W wallpaper-picker)
    mapfile -d '' -t files < <(
      find "$WP_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%f\0' | sort -z
    )

    if [[ ${#files[@]} -eq 0 ]]; then
      echo "No wallpapers found in $WP_DIR"
      exit 1
    fi

    input_data=""
    for f in "${files[@]}"; do
      input_data+="${f}\0icon\x1f${WP_DIR}/${f}\n"
    done

    ROFI_GRID_THEME="$HOME/.config/rofi/wallpaper-grid.rasi"
    ROFI_CMD="rofi -dmenu -i -p Wallpaper"
    [[ -f "$ROFI_GRID_THEME" ]] && ROFI_CMD="rofi -dmenu -theme $ROFI_GRID_THEME -p Wallpaper"

    WP_NAME=$(printf '%b' "$input_data" | $ROFI_CMD)

    [[ -z "${WP_NAME:-}" ]] && exit 0  # user cancelled
    WP="$WP_DIR/$WP_NAME"
  fi

  # Apply wallpaper immediately so user can see it
  swww img "$WP" --transition-type wipe --transition-duration 0.8

  # Generate colors.json via Matugen
  echo "Generando paleta desde wallpaper..."
  echo "" | matugen image "$WP" -m dark -t scheme-tonal-spot --source-color-index 0 --old-json-output

  # Save the wallpaper path for reference
  echo "$WP" > "$THEME_PATH/current-wallpaper.txt"
fi

[[ ! -f "$COLORS" ]] && { echo "Missing: $COLORS"; exit 1; }


# Color converters
hex_to_rgba_ff() {
  local h="${1#\#}"
  [[ "$h" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  echo "rgba(${h}ff)"
}

hex_to_rgba_css() {
  local hex="${1#\#}"
  local alpha="${2:-1}"
  [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  printf "rgba(%d,%d,%d,%s)" \
    $((16#${hex:0:2})) \
    $((16#${hex:2:2})) \
    $((16#${hex:4:2})) \
    "$alpha"
}

hex_to_rgb_css() {
  local hex="${1#\#}"
  [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]] || { echo "Invalid hex: $1" >&2; exit 1; }
  printf "rgb(%d,%d,%d)" \
    $((16#${hex:0:2})) \
    $((16#${hex:2:2})) \
    $((16#${hex:4:2}))
}

ensure_swww() {
  if ! pgrep -x swww-daemon >/dev/null 2>&1; then
    swww-daemon >/dev/null 2>&1 &
  fi

  # daemon ready wait (max ~1s)
  for _ in {1..20}; do
    swww query >/dev/null 2>&1 && return 0
    sleep 0.05
  done

  echo "Warning: swww-daemon not ready" >&2
  return 1
}

# ---------------- Extract JSON data (Robust eval approach) ----------------

# colors.json
# ---------------- Extract JSON data (Robust eval approach) ----------------

# colors.json
eval "$(jq -r '
  [
    ["bg", .bg // ""],
    ["bg_alt", .bg_alt // ""],
    ["surface", .surface // ""],
    ["surface2", .surface2 // ""],
    ["overlay", .overlay // ""],
    ["fg", .fg // ""],
    ["fg_dim", .fg_dim // ""],
    ["accent", .accent // ""],
    ["accent_alt", .accent_alt // ""],
    ["red", .red // ""],
    ["orange", .orange // ""],
    ["yellow", .yellow // ""],
    ["green", .green // ""],
    ["teal", .teal // ""],
    ["blue", .blue // ""],
    ["sky", .sky // ""],
    ["mauve", .mauve // ""],
    ["pink", .pink // ""],
    ["lavender", .lavender // ""],
    ["border_active", .border_active // ""],
    ["border_inactive", .border_inactive // ""],
    ["shadow", .shadow // ""]
  ] | .[] | "\(.[0])_hex=\"\(.[1])\""
' "$COLORS")"

# theme.json
eval "$(jq -r '
  [
    ["border_size", .hypr.border_size // 3],
    ["gaps_out", .hypr.gaps_out // 20],
    ["rounding", .hypr.rounding // 16],
    ["blur_enabled_bool", .hypr.blur.enabled // true],
    ["blur_size", .hypr.blur.size // 2],
    ["blur_passes", .hypr.blur.passes // 3],
    ["blur_vibrancy", .hypr.blur.vibrancy // 0.8],
    ["default_wallpaper", .default_wallpaper // ""],
    ["font_family", .fonts.family // "JetBrainsMono Nerd Font"],
    ["font_family_bold", .fonts.family_bold // "JetBrainsMono Nerd Font Bold"]
  ] | .[] | "\(.[0])=\"\(.[1])\""
' "$THEME_JSON")"

# ---------------- One-time fallbacks ----------------
# Ensure core colors exist
[[ -z "${bg_hex:-}" ]] && bg_hex="#111111"
[[ -z "${fg_hex:-}" ]] && fg_hex="#c0caf5"
[[ -z "${accent_hex:-}" ]] && accent_hex="#7aa2f7"

# Semantic colors fallbacks
[[ -z "${red_hex:-}" ]] && red_hex="#f7768e"
[[ -z "${green_hex:-}" ]] && green_hex="#9ece6a"
[[ -z "${yellow_hex:-}" ]] && yellow_hex="#e0af68"
[[ -z "${blue_hex:-}" ]] && blue_hex="$accent_hex"
[[ -z "${orange_hex:-}" ]] && orange_hex="#ff9e64"
[[ -z "${teal_hex:-}" ]] && teal_hex="#73daca"
[[ -z "${sky_hex:-}" ]] && sky_hex="#7dcfff"
[[ -z "${mauve_hex:-}" ]] && mauve_hex="#bb9af7"
[[ -z "${pink_hex:-}" ]] && pink_hex="#f7768e"
[[ -z "${lavender_hex:-}" ]] && lavender_hex="#cfc9c2"

# Structural color fallbacks
[[ -z "${bg_alt_hex:-}" ]] && bg_alt_hex="#1a1b26"
[[ -z "${surface_hex:-}" ]] && surface_hex="$bg_alt_hex"
[[ -z "${surface2_hex:-}" ]] && surface2_hex="$surface_hex"
[[ -z "${overlay_hex:-}" ]] && overlay_hex="$surface2_hex"
[[ -z "${shadow_hex:-}" ]] && shadow_hex="#000000"
[[ -z "${fg_dim_hex:-}" ]] && fg_dim_hex="$fg_hex"

# Border fallbacks
[[ -z "${border_active_hex:-}" ]] && border_active_hex="$accent_hex"
[[ -z "${border_inactive_hex:-}" ]] && border_inactive_hex="$surface_hex"

# Mapping for specific template aliases (safe for unset variables)
[[ -z "${peach_hex:-}" ]] && peach_hex="$orange_hex"
[[ -z "${cyan_hex:-}" ]] && cyan_hex="$teal_hex"
[[ -z "${magenta_hex:-}" ]] && magenta_hex="${mauve_hex:-#bb9af7}"

# --------------------------------------------------------------------------------------

# Read HEX (for other apps). Convert for Hypr.
bg="$(hex_to_rgba_ff "$bg_hex")"
accent="$(hex_to_rgba_ff "$accent_hex")"

# --- Theme vars (0.54-safe: no true/false; use 1/0 for enabled) ---
gaps_in="5"
layout="dwindle"

border_active="$accent"
border_active_2="$(hex_to_rgba_ff "$blue_hex")"
border_inactive="$(hex_to_rgba_ff "$surface_hex")"

active_opacity="0.9"
inactive_opacity="0.85"

shadow_enabled="1"
shadow_range="4"
shadow_power="3"
shadow_color="rgba(1a1a1aee)"

if [[ "$blur_enabled_bool" == "true" ]]; then
  blur_enabled="1"
else
  blur_enabled="0"
fi

tmp_out="$(mktemp)"
trap 'rm -f "$tmp_out"' EXIT

sed \
  -e "s/{{gaps_in}}/$gaps_in/g" \
  -e "s/{{gaps_out}}/$gaps_out/g" \
  -e "s/{{border_size}}/$border_size/g" \
  -e "s/{{layout}}/$layout/g" \
  -e "s/{{border_active}}/$border_active/g" \
  -e "s/{{border_active_2}}/$border_active_2/g" \
  -e "s/{{border_inactive}}/$border_inactive/g" \
  -e "s/{{rounding}}/$rounding/g" \
  -e "s/{{active_opacity}}/$active_opacity/g" \
  -e "s/{{inactive_opacity}}/$inactive_opacity/g" \
  -e "s/{{shadow_enabled}}/$shadow_enabled/g" \
  -e "s/{{shadow_range}}/$shadow_range/g" \
  -e "s/{{shadow_power}}/$shadow_power/g" \
  -e "s/{{shadow_color}}/$shadow_color/g" \
  -e "s/{{blur_enabled}}/$blur_enabled/g" \
  -e "s/{{blur_size}}/$blur_size/g" \
  -e "s/{{blur_passes}}/$blur_passes/g" \
  -e "s/{{blur_vibrancy}}/$blur_vibrancy/g" \
  -e "s/{{font_family}}/$font_family/g" \
  -e "s/{{font_family_bold}}/$font_family_bold/g" \
  "$TPL" > "$tmp_out"

mkdir -p "$(dirname "$OUT")"
mv "$tmp_out" "$OUT"

# --------- Wallpaper - SWWW ----------
wp_rel=""

if [[ -f "$THEME_PATH/current-wallpaper.txt" ]]; then
  wp_rel="$(cat "$THEME_PATH/current-wallpaper.txt" 2>/dev/null || true)"
fi

if [[ -z "$wp_rel" ]]; then
  wp_rel="$default_wallpaper"
fi

if [[ -n "$wp_rel" ]]; then
  # If path is absolute (dynamic theme), use it directly; else join with THEME_PATH
  if [[ "$wp_rel" = /* ]]; then
    wp_abs="$wp_rel"
  else
    wp_abs="$THEME_PATH/$wp_rel"
  fi
  if [[ -f "$wp_abs" ]]; then
    ensure_swww || true
    swww img "$wp_abs" --transition-type wipe --transition-angle 29 --transition-duration 0.75 --transition-fps 75 --transition-bezier 0.25,0.1,0.25,1 >/dev/null 2>&1 || true
    # Generate blurred wallpaper for wlogout
    mkdir -p "$HOME/.cache/wlogout"
    magick "$wp_abs" -blur 0x20 "$HOME/.cache/wlogout/blurred_wallpaper.png" >/dev/null 2>&1 || true
  else
    echo "Warning: wallpaper not found: $wp_abs" >&2
  fi
fi

printf '{ "theme": "%s", "wallpaper": "%s" }\n' "$THEME" "${wp_rel:-}" > "$BASE/current-theme.json"

# --- Derived colors for CSS ---
bg_rgba="$(hex_to_rgba_css "$bg_hex" "0.95")"
swaync_bg_rgba="$(hex_to_rgba_css "$bg_hex" "0.98")"
surface_rgba="$(hex_to_rgba_css "$surface_hex" "0.70")"
accent_soft="$(hex_to_rgba_css "$accent_hex" "0.15")"

# eww rgba variants
blue_a28="$(hex_to_rgba_css "$blue_hex" "0.28")"
blue_a35="$(hex_to_rgba_css "$blue_hex" "0.35")"
blue_a55="$(hex_to_rgba_css "$blue_hex" "0.55")"
fg_a55="$(hex_to_rgba_css "$fg_hex" "0.55")"
overlay_a85="$(hex_to_rgba_css "$overlay_hex" "0.85")"


# --------- Waybar (theme-specific layout + colors) ----------
WAYBAR_DIR="$THEME_PATH/templates/waybar"
WAYBAR_OUT_DIR="$HOME/.config/waybar"
WAYBAR_CFG_OUT="$WAYBAR_OUT_DIR/config"
WAYBAR_STYLE_OUT="$WAYBAR_OUT_DIR/style.css"

if [[ -d "$WAYBAR_DIR" ]]; then
  mkdir -p "$WAYBAR_OUT_DIR"

  if [[ -f "$WAYBAR_DIR/config" ]]; then
    cp "$WAYBAR_DIR/config" "$WAYBAR_CFG_OUT"
  fi

  if [[ -f "$WAYBAR_DIR/style.css.tpl" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{bg_alt}}/$bg_alt_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{fg_dim}}/$fg_dim_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{accent_alt}}/$accent_alt_hex/g" \
      -e "s/{{green}}/$green_hex/g" \
      -e "s/{{yellow}}/$yellow_hex/g" \
      -e "s/{{orange}}/$orange_hex/g" \
      -e "s/{{blue}}/$blue_hex/g" \
      -e "s/{{teal}}/$teal_hex/g" \
      -e "s/{{red}}/$red_hex/g" \
      -e "s/{{pink}}/$pink_hex/g" \
      -e "s/{{lavender}}/$lavender_hex/g" \
      -e "s/{{surface}}/$surface_hex/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s/{{shadow}}/$shadow_hex/g" \
      -e "s/{{bg_rgba}}/$bg_rgba/g" \
      -e "s/{{surface_rgba}}/$surface_rgba/g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$WAYBAR_DIR/style.css.tpl" > "$WAYBAR_STYLE_OUT"
  fi

pkill waybar >/dev/null 2>&1 || true
sleep 0.5
nohup waybar >/dev/null 2>&1 &
fi

# --------- Kitty ----------
KITTY_TPL="$BASE/templates/kitty.conf.tpl"
KITTY_OUT="$HOME/.config/kitty/theme.conf"

if [[ -f "$KITTY_TPL" ]]; then
  mkdir -p "$HOME/.config/kitty"

  sed \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{fg_dim}}/$fg_dim_hex/g" \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{surface}}/$surface_hex/g" \
    -e "s/{{surface2}}/$surface2_hex/g" \
    -e "s/{{red}}/$red_hex/g" \
    -e "s/{{green}}/$green_hex/g" \
    -e "s/{{yellow}}/$yellow_hex/g" \
    -e "s/{{blue}}/$blue_hex/g" \
    -e "s/{{magenta}}/$magenta_hex/g" \
    -e "s/{{cyan}}/$cyan_hex/g" \
    -e "s/{{font_family}}/$font_family/g" \
    -e "s/{{font_family_bold}}/$font_family_bold/g" \
    "$KITTY_TPL" > "$KITTY_OUT"

  for s in /tmp/kitty.sock-*; do
    [[ -S "$s" ]] || continue
    kitty @ --to "unix:$s" set-colors -a "$KITTY_OUT" >/dev/null 2>&1 || true
  done
fi

# --------- Hyprlock ----------
HYPRLOCK_TPL="$THEME_PATH/templates/hyprlock.conf.tpl"
HYPRLOCK_OUT="$HOME/.config/hypr/hyprlock.conf"

if [[ -f "$HYPRLOCK_TPL" ]]; then
  mkdir -p "$(dirname "$HYPRLOCK_OUT")"

  hypr_bg="$(hex_to_rgba_css "$bg_hex" "1.0")"
  hypr_fg="$(hex_to_rgb_css "$fg_hex")"

  input_bg_src="${bg_alt_hex:-${surface_hex:-$bg_hex}}"
  border_src="${border_active_hex:-${accent_hex}}"
  accent_src="${accent_hex:-${accent_alt_hex:-$fg_hex}}"

  hypr_input_bg="$(hex_to_rgb_css "$input_bg_src")"
  hypr_border="$(hex_to_rgb_css "$border_src")"
  hypr_accent="$(hex_to_rgb_css "$accent_src")"

  sed \
    -e "s|{{bg}}|$hypr_bg|g" \
    -e "s|{{fg}}|$hypr_fg|g" \
    -e "s|{{input_bg}}|$hypr_input_bg|g" \
    -e "s|{{border}}|$hypr_border|g" \
    -e "s|{{accent}}|$hypr_accent|g" \
    -e "s|{{fg_hex}}|$fg_hex|g" \
    -e "s|{{font_family}}|$font_family|g" \
    -e "s|{{font_family_bold}}|$font_family_bold|g" \
    -e "s|{{wallpaper_path}}||g" \
    "$HYPRLOCK_TPL" > "$HYPRLOCK_OUT"
fi


# --------- eww ----------
EWW_TPL="$BASE/templates/eww.css.tpl"
EWW_OUT="$HOME/.config/eww/eww.css"

if [[ -f "$EWW_TPL" ]]; then
  sed \
    -e "s/{{bg}}/$bg_hex/g" \
    -e "s/{{bg_alt}}/$bg_alt_hex/g" \
    -e "s/{{fg}}/$fg_hex/g" \
    -e "s/{{fg_dim}}/$fg_dim_hex/g" \
    -e "s/{{surface}}/$surface_hex/g" \
    -e "s/{{surface2}}/$surface2_hex/g" \
    -e "s/{{overlay_a85}}/$overlay_a85/g" \
    -e "s/{{blue}}/$blue_hex/g" \
    -e "s/{{blue_a28}}/$blue_a28/g" \
    -e "s/{{blue_a35}}/$blue_a35/g" \
    -e "s/{{blue_a55}}/$blue_a55/g" \
    -e "s/{{fg_a55}}/$fg_a55/g" \
    -e "s/{{green}}/$green_hex/g" \
    -e "s/{{accent}}/$accent_hex/g" \
    -e "s/{{yellow}}/$yellow_hex/g" \
    -e "s/{{orange}}/$orange_hex/g" \
    "$EWW_TPL" > "$EWW_OUT"

  # Restart eww to apply new CSS
  eww kill >/dev/null 2>&1 || true
  sleep 0.5
  eww daemon >/dev/null 2>&1 &
  # Wait for daemon to be ready before opening windows
  for i in $(seq 1 15); do
    eww ping >/dev/null 2>&1 && break
    sleep 0.2
  done
  eww open clock >/dev/null 2>&1 || true
  eww open sidebar >/dev/null 2>&1 || true
fi

# --------- Rofi ----------
ROFI_TPL_DIR="$BASE/templates/rofi"
ROFI_OUT_DIR="$HOME/.config/rofi"

if [[ -d "$ROFI_TPL_DIR" ]]; then
  mkdir -p "$ROFI_OUT_DIR"

  for tpl in "$ROFI_TPL_DIR"/*.tpl; do
    [[ -f "$tpl" ]] || continue
    out="$ROFI_OUT_DIR/$(basename "$tpl" .tpl)"

    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{surface}}/$surface_hex/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      "$tpl" > "$out"
  done

  # Generate theme-picker.rasi
  TPL_PICKER="$BASE/templates/rofi/theme-picker.rasi.tpl"
  if [[ -f "$TPL_PICKER" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{font_family}}/$font_family/g" \
      "$TPL_PICKER" > "$ROFI_OUT_DIR/theme-picker.rasi"
  fi
fi

# --------- Wlogout ----------
WLOGOUT_TPL_DIR="$BASE/templates/wlogout"
WLOGOUT_ICON_TPL_DIR="$WLOGOUT_TPL_DIR/icons"

WLOGOUT_OUT_DIR="$HOME/.config/wlogout"
WLOGOUT_ICON_OUT_DIR="$WLOGOUT_OUT_DIR/icons"

WLOGOUT_LAYOUT_TPL="$WLOGOUT_TPL_DIR/wlogout-layout.tpl"
WLOGOUT_STYLE_TPL="$WLOGOUT_TPL_DIR/wlogout-style.css.tpl"

WLOGOUT_LAYOUT_OUT="$WLOGOUT_OUT_DIR/layout"
WLOGOUT_STYLE_OUT="$WLOGOUT_OUT_DIR/style.css"

if [[ -d "$WLOGOUT_TPL_DIR" ]]; then
  mkdir -p "$WLOGOUT_OUT_DIR" "$WLOGOUT_ICON_OUT_DIR"

  if [[ -f "$WLOGOUT_LAYOUT_TPL" ]]; then
    cp "$WLOGOUT_LAYOUT_TPL" "$WLOGOUT_LAYOUT_OUT"
  fi

  if [[ -d "$WLOGOUT_ICON_TPL_DIR" ]]; then
    for tpl in "$WLOGOUT_ICON_TPL_DIR"/*.svg.tpl; do
      [[ -f "$tpl" ]] || continue
      out="$WLOGOUT_ICON_OUT_DIR/$(basename "$tpl" .svg.tpl).svg"

      sed \
        -e "s/{{fg}}/$fg_hex/g" \
        -e "s/{{accent}}/$accent_hex/g" \
        -e "s/{{font_family}}/$font_family/g" \
        -e "s/{{font_family_bold}}/$font_family_bold/g" \
        "$tpl" > "$out"
    done
  fi

  if [[ -f "$WLOGOUT_STYLE_TPL" ]]; then
    wlogout_bg_rgba="$(hex_to_rgba_css "$bg_hex" "0.80")"
    wlogout_surface_rgba="$(hex_to_rgba_css "$surface_hex" "0.70")"

    [[ -z "${overlay_hex:-}" ]] && overlay_hex="${surface2_hex:-$surface_hex}"

    sed \
      -e "s/{{bg_rgba}}/$wlogout_bg_rgba/g" \
      -e "s/{{surface_rgba}}/$wlogout_surface_rgba/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s|{{icon_dir}}|$WLOGOUT_ICON_OUT_DIR|g" \
      -e "s|{{blurred_wallpaper}}|$HOME/.cache/wlogout/blurred_wallpaper.png|g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s/{{font_family_bold}}/$font_family_bold/g" \
      "$WLOGOUT_STYLE_TPL" > "$WLOGOUT_STYLE_OUT"
  fi
fi


# --------- Swaync ----------
SWAYNC_TPL_DIR="$BASE/templates/swaync"
SWAYNC_OUT_DIR="$HOME/.config/swaync"

if [[ -d "$SWAYNC_TPL_DIR" ]]; then
  mkdir -p "$SWAYNC_OUT_DIR"

  if [[ -f "$SWAYNC_TPL_DIR/config.json.tpl" ]]; then
    cp "$SWAYNC_TPL_DIR/config.json.tpl" "$SWAYNC_OUT_DIR/config.json"
  fi

  if [[ -f "$SWAYNC_TPL_DIR/style.css.tpl" ]]; then
    sed \
      -e "s/{{bg}}/$bg_hex/g" \
      -e "s/{{fg}}/$fg_hex/g" \
      -e "s/{{fg_dim}}/$fg_dim_hex/g" \
      -e "s/{{accent}}/$accent_hex/g" \
      -e "s/{{surface}}/$surface_hex/g" \
      -e "s/{{surface2}}/$surface2_hex/g" \
      -e "s/{{overlay}}/$overlay_hex/g" \
      -e "s/{{red}}/$red_hex/g" \
      -e "s/{{bg_rgba}}/$swaync_bg_rgba/g" \
      -e "s/{{surface_rgba}}/$surface_rgba/g" \
      -e "s/{{font_family}}/$font_family/g" \
      -e "s|{{home}}|$HOME|g" \
      "$SWAYNC_TPL_DIR/style.css.tpl" > "$SWAYNC_OUT_DIR/style.css"
  fi

  pkill swaync >/dev/null 2>&1 || true
  sleep 0.3
  swaync >/dev/null 2>&1 & disown
fi

hyprctl reload >/dev/null 2>&1 || true
