# --- CONFIGURACIÓN DE PERSONALIDAD DE TU DOTFILES ---

# 1. Importar los colores dinámicos de Pywal (Vital para la estética)
if [ -f ~/.cache/wal/colors.sh ]; then
    source ~/.cache/wal/colors.sh
fi

# 2. Configuración básica de ZSH (Historial, Completado, etc.)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory

# Completado automático moderno
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Aliases útiles
alias ll='ls -lha --color=auto'
alias gs='git status'
alias update='yay -Syu'

# 3. CONTENIDO DE INICIO (Lo que querías ver al arrancar)
# Limpiamos la pantalla y lanzamos Fastfetch usando los colores de Pywal
clear
# Puedes probar cambiándolo por: fastfetch --logo arch (u otro logo)
fastfetch

# 4. Prompt moderno (Starship)
# Esto hará que tu prompt (el ➜ ~) se vea mucho más profesional
eval "$(starship init zsh)"
