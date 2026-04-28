# Dotfiles Repository - Hyprland Configuration

## System Updates
- Run updates: `hypr/scripts/install-updates.sh`
- Uses `yay` for AUR packages and `flatpak update` for Flatpak apps
- Updates arch-update counter and refreshes waybar after completion

## Configuration Structure
- Hyprland configs: `hypr/*.conf` and `hypr/modules/*.conf`
- Scripts: `hypr/scripts/` (install-updates.sh, gtk.sh, etc.)
- Shell: Fish shell with Oh My Posh theming (`fish/config.fish`)
- Desktop entries: `applications/` (arch-update.desktop)

## Key Utilities
- `arch-update`: Tracks update status (used in install-updates.sh)
- Waybar refresh: `pkill -RTMIN+1 waybar` after updates

## File Organization
- Desktop environment components: eww, fastfetch, fontconfig, gtk-4.0, kitty, mako, matugen, ohmyposh, qt6ct, rofi, swaync, theme-switcher, waybar, wlogout, xdg-desktop-portal
- Each component has its own directory with configuration files

## Notes
- Configuration is modular - features are often split across multiple .conf files in hypr/modules/
- Generated configs exist (hypr/generated-theme.conf) - check if these should be edited directly
- Backup configs exist in hypr/modules.bak/ and hypr/scripts.bak/