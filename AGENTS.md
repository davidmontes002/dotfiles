# AGENTS.md

Dotfiles Arch Linux + Hyprland con theming dinámico vía Matugen.

## Comandos Esenciales

```bash
# Cambiar wallpaper y regenerar paleta completa
~/dotfiles/scripts/cambiar_fondo.sh ~/dotfiles/fondos/<imagen.jpg>

# Selector visual de wallpapers
~/dotfiles/scripts/menu_fondos.sh

# Regenerar colores manualmente (si Waybar pierde theming)
matugen image ~/dotfiles/fondos/<imagen.jpg> -m dark --prefer saturation \
  -c ~/dotfiles/matugen/.config/matugen/config.toml

# Reiniciar daemon EWW
~/.config/eww/scripts/eww/start.sh

# Bloquear pantalla
hyprlock
```

## Flujo de Colores Dinámicos

```
Wallpaper → matugen → ~/.cache/colors/
                        ├── waybar.css    → @import en waybar/style.css
                        ├── rofi.rasi     → @import en rofi/config.rasi
                        ├── kitty.conf    → include en kitty.conf
                        └── colors-hyprland.conf → source en hyprland.conf
```

## Autostart (hyprland.conf)

Ejecutados automáticamente al iniciar Hyprland:
- `waybar`
- `awww-daemon`
- `~/dotfiles/scripts/bateria.sh &` (monitoreo batería)
- `~/.config/eww/scripts/daemon_notify/notifications.py &` (daemon D-Bus)
- `eww daemon --force-wayland` + ventanas EWW

## Keybindings Principales

| Atajo | Acción |
|-------|--------|
| `SUPER + Q` | Terminal (Kitty) |
| `SUPER + R` | Lanzador (Rofi) |
| `SUPER + A` | Control Center (EWW) |
| `SUPER + X` | Powermenu (EWW) |
| `SUPER + L` | Bloquear pantalla |
| `SUPER + SHIFT + TAB` | Selector wallpapers |
| `SUPER + C` | Cerrar ventana |
| `SUPER + V` | Toggle flotante |
| `Print` | Captura → portapapeles |
| `SUPER + SHIFT + S` | Captura área → portapapeles |

## Estructura del Repositorio

| Carpeta | Contenido |
|---------|-----------|
| `hypr/` | hyprland.conf + hyprlock.conf |
| `kitty/` | Terminal config |
| `waybar/` | Barra superior |
| `rofi/` | Lanzador de apps |
| `eww/` | Widgets (backup) - Yuck + SCSS |
| `ags/` | Widgets (nuevo) - JavaScript/QML |
| `matugen/` | Motor de themes + templates |
| `zsh/` | Shell config + Starship |
| `gtk/` | Tema Materia-dark |
| `scripts/` | cambiar_fondo.sh, menu_fondos.sh, bateria.sh |
| `fondos/` | Wallpapers |

## Notas Importantes

- **Symlinks**: `install.sh` crea enlaces en `~/.config/`. Editar archivos en dotfiles modifica la fuente
- **hwmon-path**: sensor de temperatura detectado por install.sh, editar en `waybar/.config/waybar/config.jsonc`
- **Fuentes requeridas**: `ttf-hack-nerd`, `ttf-nerd-fonts-symbols`, `ttf-jetbrains-mono-nerd`

## AGS (Nueva Configuración)

Ver `ags/MIGRATION.md` para detalles de la migración de EWW a AGS.

```bash
# Instalar AGS
yay -S aylurs-gtk-shell

# Activar en hyprland.conf
exec-once = ags -r
```