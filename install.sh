#!/bin/bash

echo "======================================================="
echo "   INICIANDO INSTALACIÓN DEL ENTORNO DE DESARROLLO  "
echo "======================================================="

# 1. Lista de paquetes completa (Básicos + Fuentes + Audio + Wayland + Extras)
PAQUETES=(
  # --- NÚCLEO Y VISUALES ---
  "hyprland" "kitty" "rofi-wayland" "waybar" "python-pywal" "awww"
  "swaync" "libnotify" "wlogout" "thunar" "materia-gtk-theme" "papirus-icon-theme"

  # --- FUENTES E ICONOS ---
  "ttf-hack-nerd" "ttf-jetbrains-mono-nerd" "ttf-font-awesome"

  # --- AUDIO (PipeWire) Y MULTIMEDIA ---
  "pipewire" "pipewire-pulse" "wireplumber" "pavucontrol" "playerctl"

  # --- SOPORTE WAYLAND, PORTALES Y QT ---
  "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk" "polkit-kde-agent"
  "qt5-wayland" "qt6-wayland"

  # --- HERRAMIENTAS DEL SISTEMA Y APPLETS ---
  "grim" "slurp" "wl-clipboard" "brightnessctl" "psmisc"
  "zsh" "blueman" "network-manager-applet"

  # --- EXTRAS PARA THUNAR ---
  "gvfs" "tumbler"

  # --- PAQUETES DE PERSONALIZACIÓN DE INICIO  ---
  "fastfetch" # Muestra info del sistema con el logo de la distro
  "starship"  # Un prompt de shell moderno y muy rápido
)

echo "1/5 Instalando todos los paquetes y dependencias..."
# yay instalará tanto de repositorios oficiales como del AUR automáticamente
yay -S --needed --noconfirm "${PAQUETES[@]}"

echo "2/5 Preparando la estructura de directorios..."
mkdir -p ~/.config
mkdir -p ~/.cache/wal

echo "3/5 Creando los puentes (Enlaces Simbólicos) desde tu Git..."
APPS=("hypr" "kitty" "rofi" "waybar" "wal" "wlogout" "swaync" "zsh")

for app in "${APPS[@]}"; do
  if [ -d "$HOME/dotfiles/$app/.config/$app" ]; then
    echo " -> Enlazando $app..."
    rm -rf "$HOME/.config/$app"
    ln -s "$HOME/dotfiles/$app/.config/$app" "$HOME/.config/$app"
  fi
done

# Reglas GTK para Thunar
if [ -d "$HOME/dotfiles/gtk/.config/gtk-3.0" ]; then
  echo " -> Enlazando reglas GTK (Materia-Dark)..."
  rm -rf "$HOME/.config/gtk-3.0"
  ln -s "$HOME/dotfiles/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
fi
# Enlace simbólico para la configuración raíz de ZSH
if [ -f "$HOME/dotfiles/zsh/.config/zsh/.zshrc" ]; then
  echo " -> Enlazando .zshrc al home..."
  rm -f "$HOME/.zshrc"
  ln -s "$HOME/dotfiles/zsh/.config/zsh/.zshrc" "$HOME/.zshrc"
fi

echo "4/5 Dando permisos y configurando el sistema por defecto..."
# Permisos a tus scripts
if [ -d "$HOME/dotfiles/scripts" ]; then
  chmod +x "$HOME/dotfiles/scripts/"*.sh
fi

# Cambiar la shell por defecto a ZSH (Kitty la necesita)
echo " -> Cambiando la shell por defecto a ZSH..."
chsh -s $(which zsh)

echo "5/5 Inicializando Pywal para evitar errores en el primer arranque..."
# Tomamos una de tus imágenes para generar los colores base
FONDO_INICIAL="$HOME/dotfiles/fondos/black-myth-wukong-3840x2160-18180.jpg"
if [ -f "$FONDO_INICIAL" ]; then
  wal -q -i "$FONDO_INICIAL"
fi

if [ -f "$HOME/dotfiles/scripts/install_sddm.sh" ]; then
  "$HOME/dotfiles/scripts/install_sddm.sh"
fi

echo "======================================================="
echo "INSTALACIÓN COMPLETADA CON ÉXITO!"
echo "Tus iconos, audio y entorno Wayland están listos."
echo "Solo necesitas reiniciar tu sesión o escribir 'Hyprland'."
echo "======================================================="
