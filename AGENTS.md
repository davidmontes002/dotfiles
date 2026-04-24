# AGENTS.md

This is a **dotfiles** repository for an Arch Linux + Hyprland Rice with dynamic theming.

## Key Commands

```bash
# Change wallpaper and regenerate all theme colors (primary command)
~/dotfiles/scripts/cambiar_fondo.sh ~/dotfiles/fondos/<image.jpg>

# Manual color regeneration (if waybar loses colors)
matugen image ~/dotfiles/fondos/<image.jpg> -m dark --prefer saturation -c ~/dotfiles/matugen/.config/matugen/config.toml

# Restart EWW daemon
~/.config/eww/scripts/eww/start.sh

# Temperature sensor path (edit waybar config if missing)
# waybar/.config/waybar/config.jsonc -> "hwmon-path"
```

## Repo Structure

| Directory | Purpose |
| :--- | :--- |
| `hypr/` | Hyprland + Hyprlock config |
| `kitty/` | Terminal config |
| `waybar/` | Status bar config |
| `eww/` | Widgets (control center, notifications, powermenu) |
| `matugen/` | Dynamic color engine + templates |
| `rofi/` | App launcher |
| `zsh/` | Shell config |
| `scripts/` | Wallpaper change, battery monitoring scripts |
| `fondos/` | Wallpapers |
| `install.sh` | Installation script |

## Installation

```bash
git clone https://github.com/davidmontes002/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The installer creates symlinks from `~/.config/` to the dotfiles directories. After install, reboot and run `Hyprland`.

## Notes

- Symlinks are managed by the install script — editing `~/.config/*` modifies the source files in dotfiles
- Temperature sensor and network interface are auto-detected during install
- Matugen extracts colors from wallpaper at runtime for Hyprland, Kitty, Rofi, Waybar, and EWW
- Font requirement: `ttf-hack-nerd` and `ttf-nerd-fonts-symbols`