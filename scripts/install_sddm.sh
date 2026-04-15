#!/bin/bash

echo "======================================================="
echo "   CONFIGURANDO PANTALLA DE INICIO (SDDM - CORNERS)    "
echo "======================================================="

# 1. Instalar SDDM y el tema desde AUR
yay -S --needed --noconfirm sddm sddm-theme-corners-git

# 2. Le decimos al sistema que use el tema "corners"
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=corners" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

# 3. Aseguramos que el archivo theme.conf apunte a "background.jpg"
sudo sed -i 's/^BgSource=.*/BgSource="background.jpg"/' /usr/share/sddm/themes/corners/theme.conf

# 4. Copiamos el fondo inicial de Wukong
FONDO_INICIAL="$HOME/dotfiles/fondos/black-myth-wukong-3840x2160-18180.jpg"
sudo cp "$FONDO_INICIAL" /usr/share/sddm/themes/corners/background.jpg

# 5. EL TRUCO DE MAGIA: Darle permisos a esa imagen para que cualquier usuario pueda sobreescribirla sin sudo
sudo chmod 666 /usr/share/sddm/themes/corners/background.jpg

# 6. Activar SDDM para que inicie con el sistema
sudo systemctl enable sddm

echo "-> Pantalla de inicio instalada y sincronizada."
