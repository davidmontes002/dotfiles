#!/bin/bash

echo "======================================================="
echo "   INICIANDO INSTALACIÓN DEL ENTORNO DE DESARROLLO   "
echo "======================================================="

# 1. Lista de paquetes completa
PAQUETES=(
  # --- NÚCLEO Y VISUALES ---
  "hyprland" "hyprlock" "kitty" "rofi-wayland" "waybar" "matugen" "awww"
  "libnotify" "thunar" "materia-gtk-theme" "papirus-icon-theme"

  # --- AGS (Aylur's GTK Shell) Y DEPENDENCIAS ---
  "aylurs-gtk-shell" "jq" "zenity" "brightnessctl" "dart-sass"

  # --- FUENTES E ICONOS ---
  "ttf-hack-nerd" "ttf-jetbrains-mono-nerd" "ttf-nerd-fonts-symbols"
  "ttf-fredoka" "otf-font-awesome"

  # --- AUDIO (PipeWire) Y MULTIMEDIA ---
  "pipewire" "pipewire-pulse" "wireplumber" "pavucontrol" "playerctl"

  # --- SOPORTE WAYLAND, PORTALES Y QT ---
  "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk" "polkit-kde-agent"
  "qt5-wayland" "qt6-wayland"

  # --- HERRAMIENTAS DEL SISTEMA ---
  "grim" "slurp" "wl-clipboard" "brightnessctl" "psmisc"
  "zsh" "blueman" "network-manager-applet"

  # --- EXTRAS PARA THUNAR ---
  "gvfs" "tumbler"

  # --- SHELL Y PROMPT ---
  "fastfetch"
  "starship"
)

# 2. Paquetes AUR adicionales (temario e iconos)
AUR_PAQUETES=(
  "magna-dark-icons"
  "lavanda-gtk-theme"
  "ttf-fredoka-one"
)

echo "1/7 Instalando todos los paquetes y dependencias..."
yay -S --needed --noconfirm "${PAQUETES[@]}"
yay -S --needed --noconfirm "${AUR_PAQUETES[@]}"

echo "2/7 Preparando la estructura de directorios..."
mkdir -p ~/.config
mkdir -p ~/.cache/colors
mkdir -p ~/.cache/hyprlock
mkdir -p ~/.cache/albumart
mkdir -p ~/.cache/liveWallpaper
mkdir -p ~/.cache/notify_img_data

echo "3/7 Creando los enlaces simbólicos..."
APPS=("hypr" "kitty" "rofi" "waybar" "matugen" "zsh")

for app in "${APPS[@]}"; do
  if [ -d "$HOME/dotfiles/$app/.config/$app" ]; then
    echo " -> Enlazando $app..."
    rm -rf "$HOME/.config/$app"
    ln -s "$HOME/dotfiles/$app/.config/$app" "$HOME/.config/$app"
  fi
done

# GTK para Thunar
if [ -d "$HOME/dotfiles/gtk/.config/gtk-3.0" ]; then
  echo " -> Enlazando GTK (Materia-Dark)..."
  rm -rf "$HOME/.config/gtk-3.0"
  ln -s "$HOME/dotfiles/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
fi

# ZSH
if [ -f "$HOME/dotfiles/zsh/.config/zsh/.zshrc" ]; then
  echo " -> Enlazando .zshrc..."
  rm -f "$HOME/.zshrc"
  ln -s "$HOME/dotfiles/zsh/.config/zsh/.zshrc" "$HOME/.zshrc"
fi

# EWW — symlink (mantener como backup)
if [ -d "$HOME/dotfiles/eww/.config/eww" ]; then
  echo " -> Enlazando eww (backup)..."
  rm -rf "$HOME/.config/eww"
  ln -s "$HOME/dotfiles/eww/.config/eww" "$HOME/.config/eww"
fi

# AGS — symlink principal
if [ -d "$HOME/dotfiles/ags/.config/ags" ]; then
  echo " -> Enlazando ags..."
  rm -rf "$HOME/.config/ags"
  ln -s "$HOME/dotfiles/ags/.config/ags" "$HOME/.config/ags"
fi

# Cava symlink para config generado por Matugen
mkdir -p "$HOME/.config/cava"
rm -f "$HOME/.config/cava/config"
ln -s "$HOME/.cache/colors/cava.ini" "$HOME/.config/cava/config" 2>/dev/null || true

echo "4/7 Dando permisos a los scripts..."
if [ -d "$HOME/dotfiles/scripts" ]; then
  chmod +x "$HOME/dotfiles/scripts/"*.sh
fi

# Scripts EWW (backup)
if [ -d "$HOME/dotfiles/eww/.config/eww/scripts" ]; then
  chmod +x "$HOME/dotfiles/eww/.config/eww/scripts/eww/"*.sh
  chmod +x "$HOME/dotfiles/eww/.config/eww/scripts/charts/"*.sh
  chmod +x "$HOME/dotfiles/eww/.config/eww/scripts/power/"*.sh
  chmod +x "$HOME/dotfiles/eww/.config/eww/scripts/notifications/"*.sh
  chmod +x "$HOME/dotfiles/eww/.config/eww/scripts/daemon_notify/notifications.py"
fi

# Scripts AGS
if [ -d "$HOME/dotfiles/ags/.config/ags/scripts" ]; then
  chmod +x "$HOME/dotfiles/ags/.config/ags/scripts/"*.sh
fi

echo "5/7 Configurando el sistema..."
# Shell por defecto a ZSH
echo " -> Cambiando shell a ZSH..."
chsh -s $(which zsh)

# Detectar sensor de temperatura automáticamente
echo " -> Detectando sensor de temperatura..."
SENSOR=$(find /sys/class/hwmon/ -name "temp*_input" 2>/dev/null | head -n 1)
if [ -n "$SENSOR" ]; then
  sed -i "s|/sys/class/hwmon/hwmon./temp1_input|$SENSOR|g" \
    "$HOME/dotfiles/waybar/.config/waybar/config.jsonc"
  echo " -> Sensor configurado: $SENSOR"
fi

# Detectar interfaz de red
echo " -> Detectando interfaz de red..."
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$INTERFACE" ]; then
  # Actualizar en EWW (backup)
  if [ -f "$HOME/dotfiles/eww/.config/eww/scripts/eww/network.sh" ]; then
    sed -i "s|INTERFACE=\"wlan0\"|INTERFACE=\"$INTERFACE\"|g" \
      "$HOME/dotfiles/eww/.config/eww/scripts/eww/network.sh"
  fi
  echo " -> Interfaz configurada: $INTERFACE"
fi

echo "6/7 Inicializando Matugen para el primer arranque..."
FONDO_INICIAL=$(find "$HOME/dotfiles/fondos" -type f \( -iname "*.jpg" -o -iname "*.png" \) | head -n 1)
if [ -n "$FONDO_INICIAL" ]; then
  matugen image "$FONDO_INICIAL" -m dark --prefer saturation \
    -c "$HOME/dotfiles/matugen/.config/matugen/config.toml"
  # Referencia inicial para hyprlock
  cp "$FONDO_INICIAL" "$HOME/.cache/hyprlock/wallpaper.jpg"
  echo "\$wallpaper = $HOME/.cache/hyprlock/wallpaper.jpg" > \
    "$HOME/.cache/hyprlock/wallpaper.conf"
  echo " -> Colores generados desde: $(basename $FONDO_INICIAL)"
fi

echo "======================================================="
echo " INSTALACIÓN COMPLETADA"
echo ""
echo " Para usar EWW (backup): SUPER + A"
echo " Para usar AGS (nuevo):"
echo "   1. Edita ~/.config/hypr/hyprland.conf"
echo "   2. Descomenta: exec-once = ags -r"
echo "   3. Comenta las líneas de exec-once de eww"
echo ""
echo " Reinicia y escribe 'Hyprland' para entrar al entorno."
echo "======================================================="