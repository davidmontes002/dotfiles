#!/bin/bash

echo "======================================================="
echo "   INICIANDO INSTALACIÓN DEL ENTORNO DE DESARROLLO  "
echo "======================================================="

# 1. Lista de paquetes a instalar extraída de tu configuración exacta
PAQUETES=(
  "hyprland"                    # Gestor de ventanas principal
  "kitty"                       # Terminal
  "rofi-wayland"                # Buscador de apps (versión optimizada para Wayland)
  "waybar"                      # Barra de estado
  "python-pywal"                # Motor de colores
  "mako" "libnotify"            # Notificaciones
  "wlogout"                     # Menú de apagado
  "thunar"                      # Gestor de archivos
  "materia-gtk-theme"           # Tema oscuro de ventanas
  "papirus-icon-theme"          # Iconos
  "awww"                        # Motor de fondos de pantalla (AUR)
  "grim" "slurp" "wl-clipboard" # Herramientas para tus recortes de pantalla
  "brightnessctl"               # Control de brillo del monitor
  "playerctl"                   # Control de música/multimedia
  "pavucontrol"                 # Interfaz gráfica para controlar el audio
)

echo "1/4 Instalando todos los paquetes y dependencias..."
# Usamos yay para asegurar que instala tanto de repos oficiales como del AUR
yay -S --needed --noconfirm "${PAQUETES[@]}"

echo "2/4 Preparando la estructura de directorios..."
mkdir -p ~/.config
mkdir -p ~/.cache/wal

echo "3/4 Creando los puentes (Enlaces Simbólicos) desde tu Git..."

# Lista de carpetas estándar en tu repositorio
APPS=("hypr" "kitty" "rofi" "waybar" "wal" "wlogout")

for app in "${APPS[@]}"; do
  if [ -d "$HOME/dotfiles/$app/.config/$app" ]; then
    echo " -> Enlazando $app..."
    rm -rf "$HOME/.config/$app"
    ln -s "$HOME/dotfiles/$app/.config/$app" "$HOME/.config/$app"
  fi
done

# Casos especiales de rutas
# 1. Tema GTK de Thunar
if [ -d "$HOME/dotfiles/gtk/.config/gtk-3.0" ]; then
  echo " -> Enlazando reglas GTK (Materia-Dark)..."
  rm -rf "$HOME/.config/gtk-3.0"
  ln -s "$HOME/dotfiles/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
fi

# 2. Configuración de notificaciones Mako (Lee directo de la caché de Pywal)
echo " -> Configurando puente dinámico para Mako..."
mkdir -p ~/.config/mako
rm -f ~/.config/mako/config
ln -s ~/.cache/wal/mako ~/.config/mako/config

echo "4/4 Dando permisos de ejecución a tus scripts maestros..."
if [ -d "$HOME/dotfiles/scripts" ]; then
  chmod +x $HOME/dotfiles/scripts/*.sh
fi

echo "======================================================="
echo "INSTALACIÓN COMPLETADA CON ÉXITO, INGENIERO!"
echo "Solo necesitas reiniciar tu sesión o escribir 'Hyprland' para entrar a tu nuevo hogar."
echo "======================================================="
