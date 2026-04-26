# 1. Restaurar la estética sólida original de Jyndev en lib.scss
cat << 'EOF' > ~/.config/eww/scss/lib.scss
// Base mixins and variables
$spacing-xs: 4px; $spacing-sm: 8px; $spacing-md: 12px; $spacing-lg: 16px; $spacing-xl: 24px;
$radius-sm: 8px; $radius-md: 12px; $radius-lg: 16px; $radius-xl: 20px; $radius-full: 9999px;
$transition-fast: 150ms ease; $transition-normal: 300ms ease;

@mixin window {
    background-color: rgba($surface_dim, 0.9);
    border-radius: 1rem;
    padding: 1rem;
    color: $on_surface;
    box-shadow: 0 0 0px 0px $shadow;
    margin: .4rem;
}

@mixin glass {
    background-color: rgba($surface_container, 0.9);
    border-radius: 1rem;
    padding: 1rem;
    border: 1px solid rgba($outline, 0.1);
}

@mixin glass-subtle {
    background-color: rgba($surface_container, 0.85);
    border-radius: $radius-md;
}

@mixin card {
    background-color: rgba($surface_container, 0.85);
    border-radius: $radius-md;
    padding: $spacing-md;
    border: 1px solid rgba($outline, 0.08);
    transition: all $transition-normal;
    &:hover { background-color: rgba($surface_container, 0.95); border-color: rgba($primary, 0.2); }
}

@mixin elevated {
    background: rgba($surface_container, 0.95);
    border-radius: $radius-xl;
    border: 1px solid rgba($outline, 0.15);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
}

@mixin frosted-glass {
    background-color: rgba($surface_dim, 0.9);
    border-radius: $radius-xl;
    border: 1px solid rgba($outline, 0.12);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}
EOF

# 2. Eliminar todas las reglas de cristal (blur) fallidas de Hyprland
sed -i '/layerrule.*eww/d' ~/dotfiles/hypr/.config/hypr/hyprland.conf
sed -i '/layerrule.*eww/d' ~/.config/hypr/hyprland.conf

# 3. Reiniciar EWW y recargar el fondo para que los colores se apliquen
rm -rf ~/.cache/eww
pkill -f eww
~/dotfiles/scripts/cambiar_fondo.sh ~/dotfiles/fondos/black-myth-wukong-3840x2160-18180.jpg
