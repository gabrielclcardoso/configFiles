#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Checking dotfiles link status against: $DOTFILES_DIR"

check_or_import() {
  local repo_path="$1"
  local sys_path="$2"

  if [ ! -e "$sys_path" ] && [ ! -L "$sys_path" ]; then
    echo "  [-] Missing on system: $sys_path"
    return 0
  fi

  if [ -L "$sys_path" ]; then
    local target
    target="$(readlink -f "$sys_path")"
    if [ "$target" = "$(readlink -f "$repo_path")" ]; then
      echo "  [OK] Symlinked: $sys_path -> $repo_path"
    else
      echo "  [!] Different symlink: $sys_path -> $target (expected: $repo_path)"
    fi
  else
    echo "  [*] Regular file on system (not symlinked): $sys_path"
    if [ "$1" = "--sync" ] || [ "$2" = "--sync" ] || [ "$IMPORT_ALL" = "1" ]; then
      echo "      Importing $sys_path -> $repo_path..."
      mkdir -p "$(dirname "$repo_path")"
      cp -rf "$sys_path" "$repo_path"
    fi
  fi
}

if [ "$1" = "--sync" ] || [ "$1" = "-s" ]; then
  IMPORT_ALL=1
  echo "==> Syncing all system configs into repo..."
fi

check_or_import "$DOTFILES_DIR/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
check_or_import "$DOTFILES_DIR/nvim/lua/config/keymaps.lua" "$HOME/.config/nvim/lua/config/keymaps.lua"
check_or_import "$DOTFILES_DIR/nvim/lazyvim.json" "$HOME/.config/nvim/lazyvim.json"
check_or_import "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
check_or_import "$DOTFILES_DIR/.XCompose" "$HOME/.XCompose"
check_or_import "$DOTFILES_DIR/hypr/input.lua" "$HOME/.config/hypr/input.lua"
check_or_import "$DOTFILES_DIR/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
check_or_import "$DOTFILES_DIR/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
check_or_import "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
check_or_import "$DOTFILES_DIR/git/config" "$HOME/.config/git/config"
check_or_import "$DOTFILES_DIR/omarchy/shell.json" "$HOME/.config/omarchy/shell.json"
check_or_import "$DOTFILES_DIR/omarchy/shell.toml" "$HOME/.config/omarchy/shell.toml"
check_or_import "$DOTFILES_DIR/omarchy/defaults/agent" "$HOME/.config/omarchy/defaults/agent"
if [ -d "$DOTFILES_DIR/omarchy/themes" ]; then
  for theme_dir in "$DOTFILES_DIR/omarchy/themes"/*; do
    [ -d "$theme_dir" ] || continue
    theme_name="$(basename "$theme_dir")"
    check_or_import "$theme_dir" "$HOME/.config/omarchy/themes/$theme_name"
  done
fi
check_or_import "$DOTFILES_DIR/electron-flags.conf" "$HOME/.config/electron-flags.conf"
check_or_import "$DOTFILES_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"
check_or_import "$DOTFILES_DIR/tensaku/config.toml" "$HOME/.config/tensaku/config.toml"
check_or_import "$DOTFILES_DIR/bin/gemini" "$HOME/.local/bin/gemini"

echo ""
echo "Tip: Run './setup.sh' to establish or restore any missing symlinks."
