
Este repositorio contiene la configuración automatizada de mi entorno de desarrollo basado en **Arch Linux** y **Hyprland**. 

El núcleo de este sistema es el *Dynamic Ricing*: toda la interfaz (terminal, bordes de ventanas, menús, barra de estado y notificaciones) extrae su paleta de colores automáticamente del fondo de pantalla actual en tiempo real gracias a `Pywal`.

## Tecnologías Principales

* **Gestor de Ventanas:** [Hyprland](https://hyprland.org/) (Wayland)
* **Terminal:** Kitty
* **Lanzador de Apps:** Rofi (Configurado con CSS/RASI personalizado)
* **Barra de Estado:** Waybar
* **Motor de Temas Dinámicos:** Pywal + awww
* **Gestor de Archivos:** Thunar (con tema Materia-Dark)
* **Notificaciones:** Mako
* **Menú de Energía:** Wlogout

---

## Instalación Automatizada

Diseñé un script que formatea, descarga dependencias, compila paquetes del AUR y crea todos los enlaces simbólicos (`symlinks`) necesarios para tener el entorno listo en un par de minutos.

### Requisitos Previos
1. Una instalación base de Arch Linux.
2. Tener instalado `git` y el gestor de paquetes de AUR `yay`.

### Pasos
Clona este repositorio y ejecuta el script de instalación:

```bash
git clone [https://github.com/TU_USUARIO/dotfiles.git](https://github.com/TU_USUARIO/dotfiles.git) ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh

Atajos de Teclado Principales (Keybinds)

El flujo de trabajo está diseñado para depender al mínimo del ratón. Aquí están los atajos maestros del sistema:
Atajo,Acción
SUPER + Q,Abrir Terminal (Kitty)
SUPER + C,Cerrar ventana activa
SUPER + E,Abrir Gestor de Archivos (Thunar)
SUPER + R,Abrir Menú de Aplicaciones (Rofi)
SUPER + V,Alternar modo ventana flotante
SUPER + X,Menú de Energía / Apagado (Wlogout)
SUPER + SHIFT + TAB,Selector visual de Fondos de Pantalla
Atajo,Acción
Impr Pant,Captura de pantalla completa (copiada al portapapeles)
SUPER + SHIFT + S,Recorte de área específica (copiada al portapapeles)
Atajo,Acción
SUPER + Flechas,Mover el foco entre ventanas
SUPER + [1-0],Cambiar al espacio de trabajo (Workspace) del 1 al 10
SUPER + SHIFT + [1-0],Mover la ventana activa al espacio de trabajo del 1 al 10
SUPER + Click Izquierdo,Arrastrar y mover ventana flotante
SUPER + Click Derecho,Redimensionar ventana flotante
