# Dotfiles Hyprland

Una configuración moderna, productiva y altamente personalizable para Arch Linux con Hyprland (Wayland).

## Requisitos del sistema

- **Arch Linux** (no se garantiza funcionamiento en derivadas como Manjaro, EndeavourOS, etc.)
- **Drivers de GPU** instalados y configurados previamente
- **Conexión a internet** para instalación de paquetes
- **Usuario con permisos sudo**

---

## Instalación

### Método automático (RECOMENDADO)

Este método instala todos los paquetes necesarios y configura automáticamente los dotfiles.

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Ejecutar el instalador interactivo
./bootstrap.sh
```

El instalador te mostrará un menú:

| Opción | Descripción |
|--------|-------------|
| `[1]` Instalación completa | Instala paquetes + configura dotfiles (recomendado) |
| `[2]` Solo paquetes | Solo instala los paquetes del sistema |
| `[3]` Solo dotfiles | Solo configura los enlaces simbólicos |

### Opciones avanzadas

```bash
./bootstrap.sh --dry-run        # Simula la instalación sin hacer cambios
./bootstrap.sh --pkgs-only      # Solo instala paquetes
./bootstrap.sh --dotfiles       # Solo configura dotfiles
```

### Método manual (avanzado)

Si prefieres instalar los paquetes manualmente:

```bash
# 1. Instalar paquetes (ver sección de dependencias)
# 2. Clonar repositorio
git clone https://github.com/tu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Ejecutar instalador de symlinks
chmod +x install.sh
./install.sh

# 4. Post-instalación manual
chsh -s /usr/bin/fish  # Cambiar shell a fish
```

---

## Dependencias completas

### Paquetes oficiales (pacman)

```bash
# Wayland / Hyprland
hyprland hyprpaper hyprlock hypridle hyprswitch hyprpm

# Barra de estado y notificaciones
waybar wlogout swaync mako

# Terminal y Shell
kitty fish

# Lanzadores
rofi

# Captura de pantalla y edición
grim slurp swappy

# Gestor de wallpapers
swww

# Widgets
eww

# Utilidades CLI
fastfetch jq gum cliphist brightnessctl pamixer playerctl \
wl-clipboard wl-paste polkit-gnome python3 imagemagick xdg-utils figlet eza

# Red y Bluetooth
networkmanager bluez blueberry

# Audio (PipeWire)
pipewire wireplumber

# Temas e iconos
adwaita-icon-theme papirus-icon-theme

# Fuentes
ttf-font-awesome otf-font-awesome

# Desarrollo y base
base-devel git
```

### Paquetes AUR (yay)

```bash
# Instalar yay primero
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm

# Paquetes AUR
yay -S matugen arch-update oh-my-posh jetbrains-mono-nerd-font
```

---

## Estructura del proyecto

```
~/dotfiles/
├── bootstrap.sh           # Instalador automático (RECOMENDADO)
├── install.sh             # Crea symlinks a ~/.config/
├── update-dotfiles.sh     # Actualiza via git pull
├── README.md              # Este archivo
├── AGENTS.md              # Documentación para agentes IA
│
├── hypr/                  # Configuración principal de Hyprland
│   ├── hyprland.conf      # Archivo principal (carga módulos)
│   ├── modules/           # Módulos modulares
│   │   ├── binds.conf     # Atajos de teclado
│   │   ├── appearance.conf # Colores, animaciones, sombras
│   │   ├── autostart.conf # Apps al iniciar sesión
│   │   ├── rules.conf     # Reglas de ventanas
│   │   └── ...
│   └── scripts/           # Scripts utilitarios
│       ├── install-updates.sh # Actualizador del sistema
│       ├── minimize-all.sh    # Minimizar todas las ventanas
│       └── ...
│
├── waybar/                # Barra de estado
│   ├── config.jsonc       # Configuración principal
│   ├── style.css          # Estilos
│   └── scripts/           # Scripts (weather, etc.)
│
├── eww/                   # Widgets (Yuck)
│   ├── eww.yuck           # Definición de widgets
│   ├── eww.css            # Estilos
│   └── scripts/           # Scripts auxiliares
│
├── rofi/                  # Lanzador de aplicaciones
│   ├── config.rasi        # Configuración base
│   ├── launchpad.rasi     # Menú principal
│   ├── spotlight.rasi     # Menú alternativo
│   ├── theme-picker.rasi  # Selector de temas
│   ├── wallpaper-grid.rasi # Selector de wallpapers
│   └── symphony/          # Scripts avanzados
│       ├── scripts/       # (keyhints, wifi, clipboard, etc.)
│       └── custom-rofi/   # Temas personalizados
│
├── theme-switcher/        # Sistema de temas
│   ├── apply-theme.sh    # Script para aplicar temas
│   ├── current-theme.json # Tema activo
│   ├── templates/         # Plantillas de configuración
│   └── themes/            # Temas disponibles
│       ├── dynamic/      # Tema dinámico (colores desde wallpaper)
│       ├── catppuccin/   # Tema Catppuccin
│       ├── tokyonight/  # Tema Tokyo Night
│       └── ...          # Más temas
│
├── kitty/                 # Terminal
│   ├── kitty.conf        # Configuración principal
│   ├── theme.conf        # Colores
│   └── kitty-cursor-trail.conf # Efecto cursor
│
├── fish/                 # Shell Fish
│   ├── config.fish       # Configuración principal
│   ├── conf.d/           # Módulos adicionales
│   │   ├── 00_init.fish  # Inicialización
│   │   ├── 10-aliases.fish # Aliases
│   │   └── ...
│   └── fish_variables    # Variables de Fish
│
├── swaync/               # Centro de notificaciones
├── mako/                # Notificaciones alternativas
├── wlogout/             # Menú de cierre de sesión
├── ohmyposh/            # Temas para la shell
├── matugen/             # Generador de colores
├── fastfetch/           # Información del sistema
├── local_bin/           # Scripts ejecutables
│   ├── theme-picker     # Selector de temas (SUPER+F1)
│   ├── wallpaper-picker # Selector de wallpapers (SUPER+W)
│   └── vsfetch          # Fetch personalizado
│
├── scripts/             # Utilidades del sistema
│   ├── Weather.sh       # Clima (configurable via bootstrap.sh)
│   ├── cpu.sh           # Uso de CPU
│   ├── memory.sh        # Uso de memoria
│   ├── disk.sh          # Uso de disco
│   └── updates.sh       # Contador de actualizaciones
│
├── fondos/              # Wallpapers incluidos
└── applications/         # Entradas de escritorio
```

---

## Personalización

### Cambiar tema (SUPER + F1)

```bash
# Desde el escritorio
SUPER + F1

# O desde terminal
~/.local/bin/theme-picker

# O aplicar tema específico
~/.config/theme-switcher/apply-theme.sh catppuccin
```

**Temas disponibles:**
- `dynamic` - Extrae colores del wallpaper usando matugen
- `catppuccin`, `tokyonight`, `nord`, `dracula`, `everforest`, etc.

### Cambiar wallpaper (SUPER + W)

```bash
# Desde el escritorio
SUPER + W

# O desde terminal
~/.local/bin/wallpaper-picker
```

Los wallpapers se encuentran en: `~/dotfiles/fondos/`

### Configurar clima

El script `scripts/Weather.sh` usa OpenWeatherMap. Durante la instalación con `bootstrap.sh` se te preguntará por tu ciudad.

Para cambiarla manualmente:
```bash
# Editar la ciudad en scripts/Weather.sh
# Ejemplo: "Los Mochis" -> "Los+Mochis"
nano ~/dotfiles/scripts/Weather.sh
```

### Modificar atajos de teclado

Los atajos se definen en: `~/.config/hypr/modules/binds.conf`

---

## Atajos de teclado

### Básicos

| Atajo | Acción |
|-------|--------|
| `SUPER + ENTER` | Abrir terminal (kitty) |
| `SUPER + ESPACIO` | Abrir launcher (rofi) |
| `SUPER + A` | Launcher alternativo (spotlight) |
| `SUPER + S` | Expositor de atajos (keyhints) |
| `SUPER + E` | Explorador de archivos (nautilus) |
| `SUPER + Q` | Cerrar ventana activa |
| `ALT + F4` | Forzar cierre |
| `ALT + TAB` | Switcher de ventanas (hyprswitch) |
| `SUPER + SHIFT + M` | Salir de Hyprland |

### Ventanas y foco

| Atajo | Acción |
|-------|--------|
| `SUPER + H/J/K/L` | Mover foco (estilo vim) |
| `SUPER + FLECHAS` | Mover foco entre ventanas |
| `SUPER + SHIFT + FLECHAS` | Mover ventana activa |
| `SUPER + CTRL + FLECHAS` | Redimensionar ventana |
| `SUPER + F` | Pantalla completa |
| `SUPER + SHIFT + ESPACIO` | Alternar flotante |
| `SUPER + P` | Alternar pseudo-tiling |
| `SUPER + T` | Alternar split |

### Workspaces

| Atajo | Acción |
|-------|--------|
| `SUPER + 1-0` | Cambiar a workspace 1-10 |
| `SUPER + SHIFT + 1-0` | Mover ventana a workspace |
| `SUPER + M` | Minimizar ventana (workspace especial) |
| `SUPER + N` | Restaurar ventana minimizada |
| `SUPER + CTRL + M` | Minimizar todas |
| `SUPER + CTRL + N` | Restaurar todas |
| `SUPER + RUEDA` | Cambiar workspace |
| `SUPER + TAB` | Ver todos los workspaces (Expo) |

### Captura de pantalla

| Atajo | Acción |
|-------|--------|
| `PRINT` | Captura de selección (portapapeles) |
| `SHIFT + PRINT` | Captura completa (~/Imágenes/) |
| `CTRL + PRINT` | Captura completa (portapapeles) |
| `SUPER + SHIFT + PRINT` | Captura con editor (swappy) |

### Sistema

| Atajo | Acción |
|-------|--------|
| `SUPER + V` | Historial del portapapeles (cliphist) |
| `SUPER + L` | Bloquear pantalla (hyprlock) |
| `SUPER + DELETE` | Bloquear pantalla |
| `SUPER + F1` | Selector de temas |
| `SUPER + W` | Selector de wallpapers |
| `SUPER + SHIFT + E` | Menú de cierre (wlogout) |

### Multimedia

| Atajo | Acción |
|-------|--------|
| `XF86AudioRaiseVolume` | Subir volumen (+5%) |
| `XF86AudioLowerVolume` | Bajar volumen (-5%) |
| `XF86AudioMute` | Silenciar/activar audio |
| `XF86AudioPlay` | Play/Pausar |
| `XF86AudioNext` | Siguiente pista |
| `XF86AudioPrev` | Pista anterior |

### Brillo

| Atajo | Acción |
|-------|--------|
| `XF86MonBrightnessUp` | Aumentar brillo (+5%) |
| `XF86MonBrightnessDown` | Disminuir brillo (-5%) |

---

## Mantenimiento

### Actualizar dotfiles

```bash
cd ~/dotfiles
git pull
# Los cambios se aplican automáticamente gracias a los symlinks
```

### Actualizar paquetes del sistema

```bash
# Usando el script incluido
~/dotfiles/hypr/scripts/install-updates.sh

# O manualmente
yay
flatpak update
```

### Verificar instalación

```bash
# Ver información del sistema
fastfetch

# Verificar symlinks
ls -la ~/.config | grep dotfiles
```

---

## Solución de problemas

### La barra (waybar) no aparece

```bash
# Reiniciar waybar
pkill waybar && waybar &
```

### Los atajos de teclado no funcionan

```bash
# Recargar configuración de Hyprland
SUPER + SHIFT + R
```

### Wayland no inicia

```bash
# Ver errores
journalctl -xe | grep -i hypr

# Verificar drivers de GPU
hyprctl devices
```

### Problemas con el protector de pantalla

Verificar: `~/.config/hypr/hypridle.conf`

---

## Créditos

- [Hyprland](https://hyprland.org/) - Gestor de ventanas Wayland
- [Oh My Posh](https://ohmyposh.dev/) - Temas para shells
- [Waybar](https://github.com/Alexays/Waybar) - Barra de estado
- [Eww](https://elkowar.github.io/eww/) - Widgets
- [Rofi](https://github.com/davatorium/rofi) - Lanzador
- [Catppuccin](https://github.com/catppuccin/hyprland) - Temas

## Licencia

MIT License - ver archivo [LICENSE](LICENSE) para más detalles.

---

¡Disfruta de tu nuevo entorno de escritorio Hyprland!