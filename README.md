# 🍚 Mi Entorno Dinámico: Arch Linux + Hyprland

![Captura de mi escritorio](screenshots/escritorio.png)

Este repositorio contiene la configuración automatizada de mi entorno de desarrollo basado en **Arch Linux** y **Hyprland**.

El núcleo de este sistema es el *Dynamic Ricing*: toda la interfaz extrae su paleta de colores automáticamente del fondo de pantalla actual en tiempo real gracias a **Matugen**.

---

## 🛠️ Tecnologías Principales

| Componente | Herramienta |
| :--- | :--- |
| Gestor de Ventanas | [Hyprland](https://hyprland.org/) (Wayland) |
| Terminal | Kitty (con ZSH y Starship) |
| Lanzador de Apps | Rofi (CSS/RASI personalizado) |
| Barra de Estado | Waybar (horizontal, parte superior) |
| Motor de Temas Dinámicos | Matugen |
| Gestor de Archivos | Thunar (tema Materia-Dark) |
| Widgets y Control Center | EWW |
| Notificaciones | EWW + Daemon Python |
| Menú de Energía | EWW Powermenu |
| Pantalla de Bloqueo | Hyprlock |

---

## ⚙️ Instalación Automatizada

### Paso 1 — Requisitos Previos

Necesitas una instalación base de Arch Linux con acceso a internet. Si no tienes `yay`, instálalo así:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
cd ~ && rm -rf /tmp/yay
```

### Paso 2 — Clonar e instalar

```bash
git clone https://github.com/davidmontes002/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Paso 3 — Post-Instalación ⚠️

1. Reinicia tu computadora: `reboot`
2. Inicia sesión en la consola (TTY)
3. Escribe `Hyprland` y presiona Enter

---

## 🔧 Ajuste Manual Tras la Instalación

### Sensor de temperatura en Waybar

El instalador detecta el sensor automáticamente, pero si la temperatura no aparece encuéntralo manualmente:

```bash
find /sys/class/hwmon/ -name "temp*_input"
```

Edita la línea correspondiente en `waybar/.config/waybar/config.jsonc`:

```jsonc
"temperature": {
    "hwmon-path": "/sys/class/hwmon/hwmonX/temp1_input"
}
```

---

## 🐛 Solución de Problemas

**Waybar no muestra colores al arrancar**
Regenera los colores manualmente:
```bash
matugen image ~/dotfiles/fondos/tu_imagen.jpg -m dark --prefer saturation -c ~/dotfiles/matugen/.config/matugen/config.toml
```

**EWW no arranca**
Reinicia el daemon manualmente:
```bash
~/.config/eww/scripts/eww/start.sh
```

**No aparecen íconos en Waybar**
Verifica que tienes las fuentes instaladas:
```bash
fc-list | grep -i "hack nerd\|symbols nerd"
```

Si no aparecen:
```bash
yay -S ttf-hack-nerd ttf-nerd-fonts-symbols --noconfirm
fc-cache -fv
```

**`chsh` falla al cambiar la shell**
```bash
chsh -s $(which zsh)
```

---

## ⌨️ Atajos de Teclado

> La tecla modificadora principal es `SUPER` (tecla Windows).

### Básicos y Aplicaciones

| Atajo | Acción |
| :--- | :--- |
| `SUPER + Q` | Abrir Terminal (Kitty) |
| `SUPER + C` | Cerrar ventana activa |
| `SUPER + E` | Abrir Gestor de Archivos (Thunar) |
| `SUPER + R` | Abrir Menú de Aplicaciones (Rofi) |
| `SUPER + V` | Alternar modo ventana flotante |
| `SUPER + A` | Abrir/Cerrar Control Center (EWW) |
| `SUPER + X` | Abrir/Cerrar Menú de Energía (EWW) |
| `SUPER + L` | Bloquear pantalla (Hyprlock) |
| `SUPER + SHIFT + TAB` | Selector visual de Fondos de Pantalla |

### Capturas de Pantalla

| Atajo | Acción |
| :--- | :--- |
| `Impr Pant` | Captura de pantalla completa → portapapeles |
| `SUPER + SHIFT + S` | Recorte de área específica → portapapeles |

### Gestión de Ventanas y Workspaces

| Atajo | Acción |
| :--- | :--- |
| `SUPER + Flechas` | Mover el foco entre ventanas |
| `SUPER + [1-0]` | Cambiar al workspace 1–10 |
| `SUPER + SHIFT + [1-0]` | Mover la ventana activa al workspace 1–10 |
| `SUPER + Clic Izquierdo` | Arrastrar y mover ventana flotante |
| `SUPER + Clic Derecho` | Redimensionar ventana flotante |

---

## 📁 Estructura del Repositorio

dotfiles/
├── fondos/              # Wallpapers (.jpg / .png)
├── eww/                 # Widgets EWW (control center, notificaciones, powermenu)
├── gtk/                 # Tema GTK para Thunar (Materia-Dark)
├── hypr/                # Configuración de Hyprland + Hyprlock
├── kitty/               #<LeftMouse> Configuración de la terminal
├── matugen/             # Motor de temas dinámicos + plantillas
├── rofi/                # Lanzador de aplicaciones
├── scripts/
│   ├── bateria.sh       # Monitor de batería con notificaciones
│   ├── cambiar_fondo.sh # Cambia fondo y regenera toda la paleta
│   └── menu_fondos.sh   # Selector visual de fondos con Rofi
├── waybar/              # Barra de estado superior
├── zsh/                 # Configuración de ZSH + Starship
└── install.sh           # Instalador automatizado


---

## 🎨 Cambiar el Fondo en Tiempo Real

O desde la terminal:

```bash
~/dotfiles/scripts/cambiar_fondo.sh ~/dotfiles/fondos/tu_imagen.jpg
```

Esto actualiza simultáneamente Hyprland, Kitty, Rofi, Waybar y EWW con los nuevos colores extraídos de la imagen.
