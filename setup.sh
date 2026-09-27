#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "==> Setting up dotfiles from: $DOTFILES_DIR"

link_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  # If destination already correctly points to the source, nothing to do
  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    echo "  [OK] Already linked: $dest"
    return 0
  fi

  # Backup existing file/dir if it exists and is not already our symlink
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "  [BACKUP] Moving existing $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  echo "  [LINK] $dest -> $src"
}

# --- Neovim ---
echo "--> Configuring Neovim..."
link_file "$DOTFILES_DIR/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
link_file "$DOTFILES_DIR/nvim/lua/config/keymaps.lua" "$HOME/.config/nvim/lua/config/keymaps.lua"

# --- Bash ---
echo "--> Configuring Bash..."
link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
[ -f "$DOTFILES_DIR/.bash_secrets" ] && cp "$DOTFILES_DIR/.bash_secrets" "$HOME/.bash_secrets"

HOOK='[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases'
if [ -f "$HOME/.bashrc" ]; then
  if ! grep -qxF "$HOOK" "$HOME/.bashrc"; then
    echo -e "\n# User aliases hook\n$HOOK" >> "$HOME/.bashrc"
    echo "  [HOOK] Added ~/.bash_aliases hook to ~/.bashrc"
  else
    echo "  [OK] ~/.bash_aliases hook already present in ~/.bashrc"
  fi
fi

# --- XCompose ---
echo "--> Configuring XCompose..."
link_file "$DOTFILES_DIR/.XCompose" "$HOME/.XCompose"

# --- Hyprland ---
echo "--> Configuring Hyprland..."
link_file "$DOTFILES_DIR/hypr/input.lua" "$HOME/.config/hypr/input.lua"
link_file "$DOTFILES_DIR/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
link_file "$DOTFILES_DIR/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"

# --- Kitty ---
echo "--> Configuring Kitty..."
link_file "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# --- Git ---
echo "--> Configuring Git..."
link_file "$DOTFILES_DIR/git/config" "$HOME/.config/git/config"

# --- Omarchy Shell & Themes ---
echo "--> Configuring Omarchy..."
link_file "$DOTFILES_DIR/omarchy/shell.json" "$HOME/.config/omarchy/shell.json"
link_file "$DOTFILES_DIR/omarchy/shell.toml" "$HOME/.config/omarchy/shell.toml"
link_file "$DOTFILES_DIR/omarchy/defaults/agent" "$HOME/.config/omarchy/defaults/agent"
link_file "$DOTFILES_DIR/omarchy/themes/brat" "$HOME/.config/omarchy/themes/brat"
link_file "$DOTFILES_DIR/omarchy/themes/kid-a" "$HOME/.config/omarchy/themes/kid-a"

# --- Electron Keyring Flags (Element / Discord / etc) ---
echo "--> Configuring Electron Flags..."
link_file "$DOTFILES_DIR/electron-flags.conf" "$HOME/.config/electron-flags.conf"
# Ensure electron43 link exists
if [ ! -L "$HOME/.config/electron43-flags.conf" ]; then
  ln -sf "$HOME/.config/electron-flags.conf" "$HOME/.config/electron43-flags.conf"
  echo "  [LINK] ~/.config/electron43-flags.conf -> ~/.config/electron-flags.conf"
fi

# --- Mise & Tensaku ---
echo "--> Configuring Mise & Tensaku..."
link_file "$DOTFILES_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"
link_file "$DOTFILES_DIR/tensaku/config.toml" "$HOME/.config/tensaku/config.toml"

# --- User CLI Shims ---
echo "--> Configuring CLI Shims..."
link_file "$DOTFILES_DIR/bin/gemini" "$HOME/.local/bin/gemini"
chmod +x "$DOTFILES_DIR/bin/gemini"

# --- Live Reloading (if in active Omarchy session) ---
if command -v hyprctl &>/dev/null && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  echo "--> Reloading Hyprland configuration..."
  hyprctl reload &>/dev/null || true
fi

if command -v omarchy-restart-xcompose &>/dev/null; then
  omarchy-restart-xcompose &>/dev/null || true
fi

echo ""
echo "==> Setup completed successfully!"
if [ -d "$BACKUP_DIR" ]; then
  echo "    Previous non-symlinked configs were backed up to: $BACKUP_DIR"
fi
echo "    Any config you edit is now directly tracked in this git repo."
echo "    To sync changes across machines:"
echo "      On source machine: git commit -am \"update\" && git push"
echo "      On target machine: git pull"
