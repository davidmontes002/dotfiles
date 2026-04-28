#!/bin/bash
# =============================================================================
# update-dotfiles.sh - Actualizador de dotfiles Hyprland
# =============================================================================
#
# Este script actualiza el repositorio de dotfiles desde su origen y
# ejecuta tareas de post-procesamiento necesarias.
# Gracias al uso de enlaces simbólicos, los cambios están activos
# inmediatamente después de git pull.
#
# Uso: ./update-dotfiles.sh [opciones]
# Opciones:
#   --help       Muestra esta ayuda
#   --version    Muestra la versión del script
#   --no-post    Omite las tareas de post-procesamiento
#
# Requisitos:
#   - Ejecutar desde dentro del repositorio clonado
#   - Git configurado con acceso al repositorio remoto
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
SKIP_POST=false
SHOW_HELP=false
SHOW_VERSION=false

# Versión del script
VERSION="1.0.0"

# Funciones

show_help() {
    cat << EOF
Uso: $SCRIPT_NAME [opciones]

Actualiza el repositorio de dotfiles desde su origen y aplica los cambios.

Opciones:
  --help       Muestra esta ayuda y sale
  --version    Muestra la versión del script y sale
  --no-post    Omite las tareas de post-procesamiento (actualización de
               contador, refresco de waybar, etc.)

Ejemplos:
  $SCRIPT_NAME          # Actualización normal con post-procesamiento
  $SCRIPT_NAME --no-post # Solo actualizar el repositorio
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

# Verificar que estamos dentro de un repositorio git
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        show_error "No se detectó un repositorio git en el directorio actual."
        show_error "Por favor, ejécte este script desde dentro del repositorio de dotfiles clonado."
        exit 1
    fi
    
    # Verificar que estamos en el directorio correcto
    if [[ "$REPO_DIR" != "$(git rev-parse --show-toplevel)" ]]; then
        show_warning "El script no está en el directorio raíz del repositorio."
        show_warning "Continuando de todas formas..."
    fi
}

# Funciones de post-procesamiento (igual que en install.sh)
post_update() {
    show_info "Ejecutando tareas de post-procesamiento después de la actualización..."
    
    # Actualizar contador de arch-update si está disponible
    if command -v arch-update &> /dev/null; then
        arch-update -c
        show_success "Contador de arch-update actualizado"
    else
        show_warning "arch-update no encontrado en PATH, omitiendo actualización de contador"
    fi
    
    # Refrescar waybar para aplicar temas inmediatamente
    if pgrep -x "waybar" &> /dev/null; then
        pkill -RTMIN+1 waybar
        show_success "Waybar refrescado"
    else
        show_info "Waybar no está ejecutándose, omitiendo refresco"
    fi
    
    show_success "Tareas de post-procesamiento completadas"
}

# Función principal
main() {
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                SHOW_HELP=true
                shift
                ;;
            --version)
                SHOW_VERSION=true
                shift
                ;;
            --no-post)
                SKIP_POST=true
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
    
    # Verificaciones iniciales
    check_git_repo
    
    show_info "Iniciando actualización de dotfiles Hyprland خليفة من الأصل..."
    show_info "Repositorio: $REPO_DIR"
    
    # Mostrar estado actual del repositorio
    show_info "Estado actual del repositorio:"
    git status --porcelain
    echo
    
    # Realizar el pull
    show_info "Obteniendo cambios del repositorio remoto..."
    if ! git pull; then
        show_error "Falló la actualización del repositorio."
        show_error "Posibles causas:"
        show_error "  - Conflictos de fusión que necesitan resolución manual"
        show_error "  - Problemas de conectividad con el repositorio remoto"
        show_error "  - Falta de permisos para acceder al repositorio"
        exit 1
    fi
    
    show_success "Repositorio actualizado correctamente."
    
    # Mostrar qué cambió
    show_info "Resumen de cambios:"
    git diff --stat HEAD@{1} HEAD
    echo
    
    # Post-procesamiento si no se omitió
    if [[ "$SKIP_POST" = false ]]; then
        post_update
    else
        show_info "Tareas de post-procesamiento omitidas según solicitud."
    fi
    
    show_success "Actualización completada."
    echo
    echo "Gracias al uso de enlaces simbólicos, todos los cambios están activos inmediatamente."
    echo "Si experimenta algún problema, puede revertir la última actualización con:"
    echo "  git reset --hard HEAD@{1}"
    echo
    echo "Para verificar qué versión está ejecutando actualmente:"
    echo "  git log --oneline -1"
}

# Ejecutar función principal con todos los argumentos
main "$@"