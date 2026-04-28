# Dotfiles Hyprland - Configuración completa de escritorio para Arch Linux

Este repositorio contiene una configuración personalizada para el entorno de escritorio Hyprland en Arch Linux, diseñada para proporcionar una experiencia moderna, productiva y estéticamente agradable.

## 📋 Requisitos del sistema

- Arch Linux o derivada (Manjaro, ArcoLinux, EndeavourOS, etc.)
- Hardware compatible con aceleración gráfica (Intel/AMD/NVIDIA con drivers apropiados)
- Conexión a internet para instalación de paquetes
- Espacio en disco suficiente (mínimo 10 GB recomendados)

## 📦 Dependencias necesarias

### Hyprland y componentes esenciales
```bash
hyprland hyprpaper hyprlock hypridle
```

### Barra de estado y widgets
```bash
waybar wlogout
```

### Aplicaciones
```bash
kitty rofi fastfetch jq
```

### Shell y temas
```bash
fish oh-my-posh-git
```

### Utilidades
```bash
eww matugen swole grim slurp gum
```

### Temas y iconos
```bash
adwaita-icon-theme papirus-icon-theme
```

### Fuentes
```bash
jetbrains-mono-nerd ttf-font-awesome otf-font-awesome
```

## ⬇️ Instalación

### Método recomendado (enlaces simbólicos)
Este método mantiene su configuración sincronizada con el repositorio:

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Dar permisos de ejecución al instalador
chmod +x install.sh

# Ejecutar el instalador
./install.sh
```

### Opciones del instalador
- `./install.sh` - Instalación normal con enlaces simbólicos
- `./install.sh --dry-run` - Muestra qué haría sin realizar cambios
- `./install.sh --backup-only` - Solo crea backup de configuraciones existentes

## 📂 Estructura de la configuración

Después de la instalación, encontrará los siguientes enlaces en `~/.config/`:
- `hypr/` → Configuración de Hyprland (ventanas, teclado, monitores)
- `waybar/` → Barra de estado con información del sistema
- `fish/` → Shell interactiva con Oh My Posh
- `kitty/` → Terminal emulator configurada
- `rofi/` → Lanzador de aplicaciones y menús
- `eww/` → Widgets personalizados en escritorio
- Y muchos más componentes especializados

## 🎨 Personalización

### Cambiar temas y colores
Edite los archivos de tema en:
- `~/.config/hypr/` para colores de Hyprland
- `~/.config/waybar/` para estilo de la barra
- `~/.config/oh-my-posh/` para temas de shell

### Modificar atajos de teclado
Los atajos se definen en `~/.config/hypr/hyprland.conf` en la sección `bind`

### Ajustar comportamiento
Cada componente tiene sus propios archivos de configuración bien documentados dentro de sus respectivos directorios.

## 🔧 Solución de problemas comunes

### Waybar no se muestra correctamente
```bash
# Reiniciar waybar
pkill waybar && waybar &
```

### Atajos de teclado no funcionan
```bash
# Recargar configuración de Hyprland
Super + Shift + r
```

### Problemas con el blanqueo de pantalla
Verifique la configuración de energía en `~/.config/hypr/hypridle.conf`

## 🔄 Mantenimiento y actualizaciones

Con el método de enlaces simbólicos, actualizar es tan simple como:

```bash
cd ~/dotfiles
git pull
# Los cambios están activos inmediatamente
```

Para actualizar el sistema de paquetes:
```bash
./hypr/scripts/install-updates.sh
```

## 🙏 Créditos y licencia

### Créditos
- [Hyprland](https://hyprland.org/) - Gestor de ventanas Wayland
- [Oh My Posh](https://ohmyposh.dev/) - Motor de temas para shells
- [Waybar](https://github.com/Alexays/Waybar) - Barra de estado altamente personalizable
- Y todos los proyectos de código abierto utilizados en esta configuración

### Licencia
Este proyecto está licenciado bajo la licencia MIT - vea el archivo [LICENSE](LICENSE) para más detalles.

¡Disfrute de su nuevo entorno de escritorio Hyprland!