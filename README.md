# 🍚 Mi Entorno Dinámico: Arch Linux + Hyprland

![Captura de mi escritorio](screenshots/escritorio.png)

Este repositorio contiene la configuración automatizada de mi entorno de desarrollo basado en **Arch Linux** y **Hyprland**.

El núcleo de este sistema es el *Dynamic Ricing*: toda la interfaz (terminal, bordes de ventanas, menús, barra de estado y notificaciones) extrae su paleta de colores automáticamente del fondo de pantalla actual en tiempo real gracias a `Pywal`.

---

## 🛠️ Tecnologías Principales

| Componente | Herramienta |
| :--- | :--- |
| Gestor de Ventanas | [Hyprland](https://hyprland.org/) (Wayland) |
| Terminal | Kitty (con ZSH y Starship) |
| Lanzador de Apps | Rofi (CSS/RASI personalizado) |
| Barra de Estado | Waybar (vertical, lado izquierdo) |
| Motor de Temas Dinámicos | Pywal + awww |
| Gestor de Archivos | Thunar (tema Materia-Dark) |
| Notificaciones | SwayNC |
| Menú de Energía | Wlogout |

---

## ⚙️ Instalación Automatizada

Diseñé un script que descarga dependencias, compila paquetes del AUR y crea todos los enlaces simbólicos (`symlinks`) necesarios para tener el entorno listo en minutos.

### Paso 1 — Requisitos Previos

Necesitas una instalación base de Arch Linux con acceso a internet. Si no tienes `yay`, instálalo así:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
cd ~ && rm -rf /tmp/yay
```

### Paso 2 — Clonar e instalar

Clona el repositorio **directamente en tu directorio home** y ejecuta el instalador:

```bash
git clone https://github.com/davidmontes002/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Paso 3 — Post-Instalación ⚠️

El script cambiará tu shell por defecto a `zsh` y configurará el entorno Wayland. Para que todo surta efecto:

1. Reinicia tu computadora: `reboot`
2. Inicia sesión en la consola (TTY) con tu usuario y contraseña
3. Escribe `Hyprland` y presiona Enter

---

## 🔧 Ajustes Manuales Tras la Instalación

Estos dos ajustes son necesarios porque dependen del hardware específico de tu equipo o de tu nombre de usuario. El script no puede hacerlos automáticamente.

### Sensor de temperatura en Waybar

El path del sensor está configurado para un hardware específico. Encuéntra el tuyo y actualiza `waybar/.config/waybar/config.jsonc`:

```bash
# Listar todos los sensores de temperatura disponibles en tu equipo
find /sys/class/hwmon/ -name "temp*_input"
```

Luego edita la línea correspondiente en la config:

```jsonc
"temperature": {
    "hwmon-path": "/sys/class/hwmon/hwmonX/temp1_input", // <- reemplaza X
    ...
}
```

---

## 🐛 Solución de Problemas

**Waybar no muestra colores al arrancar**
Pywal necesita haber generado la paleta al menos una vez. Fórzalo manualmente apuntando a cualquier imagen de `~/dotfiles/fondos/`:
```bash
wal -i ~/dotfiles/fondos/nombre_de_imagen.jpg
```

**No aparece el ícono de Arch en Waybar**
Requiere una Nerd Font con el glifo ` `. El paquete `ttf-hack-nerd` incluido en la instalación debería ser suficiente. Si no aparece, instala adicionalmente:
```bash
yay -S ttf-nerd-fonts-symbols-mono
```

**`chsh` falla al cambiar la shell**
Ejecuta el cambio manualmente una vez que ZSH esté instalado:
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
| `SUPER + X` | Menú de Energía / Apagado (Wlogout) |
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

```
dotfiles/
├── fondos/              # Wallpapers (.jpg / .png)
├── gtk/                 # Tema GTK para Thunar (Materia-Dark)
├── hypr/                # Configuración de Hyprland
├── kitty/               # Configuración de la terminal
├── rofi/                # Lanzador de aplicaciones
├── scripts/
│   ├── bateria.sh       # Monitor de batería con notificaciones
│   ├── cambiar_fondo.sh # Cambia fondo y regenera toda la paleta
│   └── menu_fondos.sh   # Selector visual de fondos con Rofi
├── swaync/              # Centro de notificaciones
├── wal/                 # Plantillas de Pywal para cada app
├── waybar/              # Barra de estado lateral
├── wlogout/             # Menú de apagado/reinicio
├── zsh/                 # Configuración de ZSH + Starship
└── install.sh           # Instalador automatizado
```

---

## 🎨 Cambiar el Fondo en Tiempo Real

Para cambiar el fondo y regenerar toda la paleta de colores al instante, usa el selector visual:

```
SUPER + SHIFT + TAB
```

O directamente desde la terminal:

```bash
~/dotfiles/scripts/cambiar_fondo.sh ~/dotfiles/fondos/tu_imagen.jpg
```

Esto actualiza simultáneamente Hyprland, Kitty, Rofi, Waybar y SwayNC con los nuevos colores extraídos de la imagen.
