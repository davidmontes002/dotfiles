#!/bin/bash
# =============================================================================
# bootstrap.sh - Instalador automático de dotfiles Hyprland
# =============================================================================
#
# Este script automatiza la instalación completa de dotfiles Hyprland en Arch Linux.
# Incluye instalación de paquetes, configuración y enlaces simbólicos.
#
# Uso: ./bootstrap.sh [opciones]
# Opciones:
#   --dry-run    Simula la instalación sin hacer cambios reales
#   --pkgs-only Solo instala paquetes
#   --dotfiles  Solo ejecuta install.sh
#   --help      Muestra esta ayuda
#
# Requisitos:
#   - Arch Linux
#   - Conexión a internet
#   - Ejecutar como usuario normal (no root)
#
# =============================================================================

set -euo pipefail

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
DRY_RUN=false
PKGS_ONLY=false
DOTFILES_ONLY=false

# Paquetes oficiales (pacman)
OFFICIAL_PKGS=(
    "base-devel"
    "git"
    "hyprland"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "hyprswitch"
    "waybar"
    "wlogout"
    "swaync"
    "mako"
    "kitty"
    "fish"
    "rofi"
    "grim"
    "slurp"
    "swappy"
    "swww"
    "eww"
    "fastfetch"
    "jq"
    "gum"
    "cliphist"
    "brightnessctl"
    "pamixer"
    "playerctl"
    "wl-clipboard"
    "wl-paste"
    "networkmanager"
    "bluez"
    "blueberry"
    "pipewire"
    "wireplumber"
    "python3"
    "imagemagick"
    "xdg-utils"
    "polkit-gnome"
    "adwaita-icon-theme"
    "papirus-icon-theme"
    "ttf-font-awesome"
    "otf-font-awesome"
    "eza"
    "figlet"
)

# Paquetes AUR (yay)
AUR_PKGS=(
    "yay"
    "matugen"
    "arch-update"
    "oh-my-posh"
    "jetbrains-mono-nerd-font"
)

# =============================================================================
# FUNCIONES
# =============================================================================

show_help() {
    cat << EOF
$SCRIPT_NAME - Instalador automático de dotfiles Hyprland

Uso: $SCRIPT_NAME [opciones]

Opciones:
  --dry-run    Simula la instalación sin hacer cambios reales
  --pkgs-only  Solo instala los paquetes, no configura dotfiles
  --dotfiles   Solo ejecuta el instalador de dotfiles (supone paquetes instalados)
  --help       Muestra esta ayuda y sale

Ejemplos:
  $SCRIPT_NAME              # Instalación completa interactiva
  $SCRIPT_NAME --dry-run    # Simular instalación
  $SCRIPT_NAME --pkgs-only  # Solo instalar paquetes
EOF
}

show_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
show_success() { echo -e "${GREEN}[ÉXITO]${NC} $1"; }
show_warning() { echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"; }
show_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Verificar que no sea root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        show_error "Este script no debe ejecutarse como root."
        exit 1
    fi
}

# Verificar que sea Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        show_error "Este script está diseñado para Arch Linux."
        exit 1
    fi
}

# Verificar internet
check_internet() {
    if ! ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        show_error "No hay conexión a internet."
        exit 1
    fi
}

# Instalar yay si no existe
install_yay() {
    if command -v yay &>/dev/null; then
        show_info "yay ya está instalado."
        return 0
    fi

    show_info "Instalando yay..."
    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] git clone https://aur.archlinux.org/yay.git /tmp/yay"
        return 0
    fi

    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /
    rm -rf /tmp/yay
    show_success "yay instalado."
}

# Instalar paquetes oficiales
install_official_pkgs() {
    show_info "Instalando paquetes oficiales..."

    local missing_pkgs=()
    for pkg in "${OFFICIAL_PKGS[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [[ ${#missing_pkgs[@]} -eq 0 ]]; then
        show_info "Todos los paquetes oficiales ya están instalados."
        return 0
    fi

    show_info "Paquetes a instalar: ${missing_pkgs[*]}"

    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] sudo pacman -S --needed ${missing_pkgs[*]}"
        return 0
    fi

    sudo pacman -S --needed "${missing_pkgs[@]}"
    show_success "Paquetes oficiales instalados."
}

# Instalar paquetes AUR
install_aur_pkgs() {
    show_info "Instalando paquetes AUR..."

    local missing_pkgs=()
    for pkg in "${AUR_PKGS[@]}"; do
        if ! yay -Qi "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [[ ${#missing_pkgs[@]} -eq 0 ]]; then
        show_info "Todos los paquetes AUR ya están instalados."
        return 0
    fi

    show_info "Paquetes AUR a instalar: ${missing_pkgs[*]}"

    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] yay -S --needed ${missing_pkgs[*]}"
        return 0
    fi

    yay -S --needed "${missing_pkgs[@]}"
    show_success "Paquetes AUR instalados."
}

# Crear directorios necesarios
create_directories() {
    show_info "Creando directorios necesarios..."

    local dirs=(
        "$HOME/.local/bin"
        "$HOME/Imágenes"
        "$HOME/.cache/wlogout"
    )

    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                show_info "[DRY RUN] mkdir -p $dir"
            else
                mkdir -p "$dir"
                show_success "Creado: $dir"
            fi
        else
            show_info "Ya existe: $dir"
        fi
    done
}

# Configurar ciudad del clima
configure_weather() {
    local weather_script="$REPO_DIR/scripts/Weather.sh"

    if [[ ! -f "$weather_script" ]]; then
        show_warning "No se encontró scripts/Weather.sh, saltando configuración del clima."
        return 0
    fi

    show_info "Configurando ciudad para el clima..."

    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] Solicitar ciudad al usuario y modificar Weather.sh"
        return 0
    fi

    local city
    if command -v gum &>/dev/null; then
        city=$(gum input --placeholder "Ciudad (ej: Los Mochis)" --value "Los Mochis")
    else
        read -p "Ciudad para el clima (ej: Los Mochis): " city
        [[ -z "$city" ]] && city="Los Mochis"
    fi

    if [[ -z "$city" ]]; then
        show_warning "Ciudad no proporcionada, manteniendo predeterminada."
        return 0
    fi

    local city_encoded="${city// /+}"

    sed -i "s|CITY = \".*\"|CITY = \"${city_encoded}\"|" "$weather_script"
    show_success "Ciudad configurada: $city -> $city_encoded"
}

# Ejecutar install.sh
run_install_script() {
    show_info "Ejecutando instalador de dotfiles..."

    if [[ ! -f "$REPO_DIR/install.sh" ]]; then
        show_error "No se encontró install.sh"
        exit 1
    fi

    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] cd $REPO_DIR && ./install.sh"
        return 0
    fi

    cd "$REPO_DIR"
    chmod +x install.sh
    ./install.sh
}

# Post-instalación
post_install() {
    show_info "Ejecutando tareas de post-instalación..."

    if [[ "$DRY_RUN" == true ]]; then
        show_info "[DRY RUN] chsh -s /usr/bin/fish"
        return 0
    fi

    if command -v fish &>/dev/null; then
        if [[ "$SHELL" != *"fish"* ]]; then
            show_info "Cambiando shell predeterminada a fish..."
            chsh -s /usr/bin/fish
            show_success "Shell cambiada a fish."
        else
            show_info "Fish ya es la shell predeterminada."
        fi
    fi

    show_success "Post-instalación completada."
}

# Menú principal
show_menu() {
    echo
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  INSTALADOR DE DOTFILES HYPRLAND${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo
    echo -e "  ${GREEN}[1]${NC} Instalación completa ⭐ (recomendado)"
    echo -e "  ${GREEN}[2]${NC} Solo paquetes"
    echo -e "  ${GREEN}[3]${NC} Solo dotfiles"
    echo -e "  ${GREEN}[4]${NC} Salir"
    echo
}

# Menú interactivo con gum o fallback a read
interactive_menu() {
    if command -v gum &>/dev/null; then
        echo
        echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}  INSTALADOR DE DOTFILES HYPRLAND${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
        echo
        local choice
        choice=$(gum choose "Instalación completa ⭐ (recomendado)" "Solo paquetes" "Solo dotfiles" "Salir")
        case "$choice" in
            "Instalación completa"*) echo "1" ;;
            "Solo paquetes") echo "2" ;;
            "Solo dotfiles") echo "3" ;;
            "Salir") echo "4" ;;
        esac
    else
        show_menu
        read -p "Selecciona una opción [1-4]: " choice
        echo "$choice"
    fi
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --pkgs-only)
                PKGS_ONLY=true
                shift
                ;;
            --dotfiles)
                DOTFILES_ONLY=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                show_error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Verificaciones iniciales
    check_not_root
    check_arch

    if [[ "$DRY_RUN" == true ]]; then
        show_warning "MODO DE PRUEBA ACTIVADO"
    fi

    # Ejecutar según modo
    if [[ "$DOTFILES_ONLY" == true ]]; then
        run_install_script
        post_install
        return 0
    fi

    if [[ "$PKGS_ONLY" == true ]]; then
        check_internet
        install_yay
        install_official_pkgs
        install_aur_pkgs
        return 0
    fi

    # Modo interactivo
    check_internet

    local choice
    choice=$(interactive_menu)

    case "$choice" in
        1)
            show_info "Iniciando instalación completa..."
            install_yay
            install_official_pkgs
            install_aur_pkgs
            create_directories
            configure_weather
            run_install_script
            post_install
            ;;
        2)
            show_info "Solo instalando paquetes..."
            install_yay
            install_official_pkgs
            install_aur_pkgs
            ;;
        3)
            show_info "Solo configurando dotfiles..."
            create_directories
            configure_weather
            run_install_script
            post_install
            ;;
        4)
            show_info "Saliendo..."
            exit 0
            ;;
    esac

    echo
    show_success "═══════════════════════════════════════════════════"
    show_success "  INSTALACIÓN COMPLETADA"
    show_success "═══════════════════════════════════════════════════"
    echo
    echo -e "  ${YELLOW}Próximos pasos:${NC}"
    echo "  1. Cierra sesión y vuelve a iniciar (Hyprland)"
    echo "  2. Ejecuta 'fastfetch' para verificar"
    echo "  3. Presiona SUPER+F1 para elegir un tema"
    echo
}

main "$@"