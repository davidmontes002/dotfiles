#!/bin/bash
# =============================================================================
# install.sh - Instalador de dotfiles Hyprland mediante enlaces simbólicos
# =============================================================================
#
# Este script crea enlaces simbólicos desde el repositorio clonado a las
# ubicaciones apropiadas en ~/.config/ para instalar la configuración de
# Hyprland y componentes asociados.
#
# Uso: ./install.sh [opciones]
# Opciones:
#   --dry-run    Muestra qué haría sin realizar cambios
#   --help       Muestra esta ayuda
#   --version    Muestra la versión del script
#
# Requisitos:
#   - Ejecutar como usuario normal (no root)
#   - Sistema basado en Arch Linux
#   - Git instalado para obtener la ruta del repositorio
#
# =============================================================================

# Configuración inicial
set -euo pipefail  # Salir en error, tratar variables no definidas como error, fallar en tuberías

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
SHOW_HELP=false
SHOW_VERSION=false

# Versión del script
VERSION="1.0.0"

# Funciones

show_help() {
    cat << EOF
Uso: $SCRIPT_NAME [opciones]

Instala la configuración de Hyprland creando enlaces simbólicos desde este
repositorio a ~/.config/

Opciones:
  --dry-run    Muestra qué haría sin realizar cambios reales
  --help       Muestra esta ayuda y sale
  --version    Muestra la versión del script y sale

Ejemplos:
  $SCRIPT_NAME          # Instalación normal
  $SCRIPT_NAME --dry-run # Ver qué haría sin cambiar nada
EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

show_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

show_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

show_success() {
    echo -e "${GREEN}[ÉXITO]${NC} $1"
}

# Verificar que no se esté ejecutando como root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        show_error "Este script no debe ejecutarse como root. Por favor, ejéctelo como usuario normal."
        exit 1
    fi
}

# Verificar que estamos en Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        show_warning "Este script está diseñado para Arch Linux. Continuando bajo su propia responsabilidad..."
        # No salimos, solo advertimos
    fi
}

# Obtener lista de directorios de componentes a enlazar
get_components() {
    # Lista de directorios que contienen configuración para ~/.config/
    # Basado en la exploración del repositorio
    local components=(
        "applications"
        "arch-update"
        "eww"
        "fastfetch"
        "fish"
        "fontconfig"
        "gtk-4.0"
        "hypr"
        "hyprswitch"
        "kitty"
        "local_bin"
        "mako"
        "matugen"
        "ohmyposh"
        "qt6ct"
        "rofi"
        "scripts"
        "swaync"
        "theme-switcher"
        "waybar"
        "wlogout"
        "xdg-desktop-portal"
    )
    
    # Filtrar solo los que existen en el repositorio
    local existing_components=()
    for component in "${components[@]}"; do
        if [[ -d "$REPO_DIR/$component" ]]; then
            existing_components+=("$component")
        fi
    done
    
    echo "${existing_components[@]}"
}

# Crear backup de una configuración existente
backup_existing_config() {
    local component="$1"
    local target="$CONFIG_DIR/$component"
    
    if [[ -e "$target" && ! -L "$target" ]]; then
        show_info "Haciendo backup de $component existente..."
        if [[ "$DRY_RUN" = false ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$target" "$BACKUP_DIR/"
        fi
        show_success "Backup de $component creado en $BACKUP_DIR/$component"
    fi
}

# Crear enlace simbólico para un componente
create_symlink() {
    local component="$1"
    local source="$REPO_DIR/$component"
    local target="$CONFIG_DIR/$component"
    
    # Verificar que el source exista
    if [[ ! -e "$source" ]]; then
        show_error "El componente source '$source' no existe."
        return 1
    fi
    
    # Manejar configuración existente
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            # Es un enlace simbólico, verificar a dónde apunta
            local current_target
            current_target="$(readlink "$target")"
            if [[ "$current_target" == "$source" ]]; then
                show_info "El enlace para $component ya apunta a la ubicación correcta. Saltando."
                return 0
            else
                show_warning "El enlace existente para $component apunta a '$current_target', se reemplazará."
                if [[ "$DRY_RUN" = false ]]; then
                    rm "$target"
                fi
            fi
        else
            # Es un archivo o directorio normal
            show_warning "Se encontró $component existente en $target (no es un enlace)."
            backup_existing_config "$component"
            if [[ "$DRY_RUN" = false ]]; then
                rm -rf "$target"
            fi
        fi
    fi
    
    # Crear el enlace simbólico
    if [[ "$DRY_RUN" = true ]]; then
        show_info "[DRY RUN] Creando enlace: ln -sf \"$source\" \"$target\""
    else
        ln -sf "$source" "$target"
        show_success "Enlace creado para $component"
    fi
}

# Funciones de post-procesamiento
post_install() {
    show_info "Ejecutando tareas de post-procesamiento..."
    
    # Actualizar contador de arch-update si está disponible
    if command -v arch-update &> /dev/null; then
        if [[ "$DRY_RUN" = true ]]; then
            show_info "[DRY RUN] Ejecutando: arch-update -c"
        else
            arch-update -c
            show_success "Contador de arch-update actualizado"
        fi
    else
        show_warning "arch-update no encontrado en PATH, omitiendo actualización de contador"
    fi
    
    # Refrescar waybar para aplicar temas inmediatamente
    if pgrep -x "waybar" &> /dev/null; then
        if [[ "$DRY_RUN" = true ]]; then
            show_info "[DRY RUN] Ejecutando: pkill -RTMIN+1 waybar"
        else
            pkill -RTMIN+1 waybar
            show_success "Waybar refrescado"
        fi
    else
        show_info "Waybar no está ejecutándose, omitiendo refresco"
    fi
    
    # Establecer fish como shell predeterminada si no lo es ya
    if [[ "$SHELL" != *"fish"* ]]; then
        if command -v fish &> /dev/null; then
            show_info "Estableciendo fish como shell predeterminada..."
            if [[ "$DRY_RUN" = true ]]; then
                show_info "[DRY RUN] Ejecutando: chsh -s $(which fish)"
            else
                chsh -s "$(which fish)"
                show_success "Shell predeterminada cambiada a fish"
            fi
        else
            show_warning "Fish no está instalado, no se puede cambiar la shell predeterminada"
        fi
    else
        show_info "Fish ya es la shell predeterminada"
    fi
    
    show_success "Tareas de post-procesamiento completadas"
}

# Función principal
main() {
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                SHOW_HELP=true
                shift
                ;;
            --version)
                SHOW_VERSION=true
                shift
                ;;
            *)
                show_error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Manejar opciones especiales
    if [[ "$SHOW_HELP" = true ]]; then
        show_help
        exit 0
    fi
    
    if [[ "$SHOW_VERSION" = true ]]; then
        show_version
        exit 0
    fi
    
    # Mostrar modo de operación
    if [[ "$DRY_RUN" = true ]]; then
        show_info "MODO DE PRUEBA ACTIVADO - No se realizarán cambios reales"
    fi
    
    # Verificaciones iniciales
    check_not_root
    check_arch
    
    show_info "Iniciando instalación de dotfiles Hyprland..."
    show_info "Repositorio: $REPO_DIR"
    show_info "Directorio de configuración: $CONFIG_DIR"
    
    # Obtener componentes a enlazar
    local components
    components=($(get_components))
    
    if [[ ${#components[@]} -eq 0 ]]; then
        show_error "No se encontraron componentes para enlazar en el repositorio."
        exit 1
    fi
    
    show_info "Se crearán enlaces simbólicos para los siguientes componentes:"
    for component in "${components[@]}"; do
        show_info "  - $component"
    done
    echo
    
    # Crear enlaces simbólicos
    local failed=0
    for component in "${components[@]}"; do
        if ! create_symlink "$component"; then
            ((failed++))
        fi
    done
    
    # Reporte de resultados
    echo
    if [[ $failed -eq 0 ]]; then
        show_success "Se crearon enlaces simbólicos para todos los ${#components[@]} componentes correctamente."
        
        # Post-procesamiento solo si no es dry run
        if [[ "$DRY_RUN" = false ]]; then
            post_install
        fi
        
        show_info "Instalación completada."
        if [[ "$DRY_RUN" = false ]]; then
            echo
            echo "Próximos pasos recomendados:"
            echo "  1. Cierre sesión y vuelva a iniciar para aplicar todos los cambios"
            echo "  2. Revise y ajuste la configuración según sus preferencias"
            echo "  3. Para actualizaciones futuras, simplemente ejecute:"
            echo "     cd $REPO_DIR && git pull"
            echo "     # Los cambios estarán activos inmediatamente gracias a los enlaces simbólicos"
        fi
    else
        show_error "Se produjeron $failed errores durante la creación de enlaces."
        if [[ "$DRY_RUN" = false ]]; then
            show_info "Algunos componentes podrían no estar configurados correctamente."
            show_info "Revise los mensajes de error arriba para más detalles."
        fi
        exit 1
    fi
}

# Ejecutar función principal con todos los argumentos
main "$@"