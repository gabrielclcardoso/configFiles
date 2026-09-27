#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

INSTALL_PKGS=0
for arg in "$@"; do
  case "$arg" in
    --install-pkgs|-p)
      INSTALL_PKGS=1
      ;;
    --help|-h)
      echo "Usage: ./setup.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -p, --install-pkgs   Install extra user applications (pacman & AUR) and mise runtimes"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
  esac
done

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

# --- Optional: Package Installation ---
if [ "$INSTALL_PKGS" = "1" ]; then
  echo ""
  echo "==> Installing User Applications and Tools..."

  # Official Arch repository packages
  if [ -f "$DOTFILES_DIR/packages.txt" ]; then
    echo "--> Installing official packages from packages.txt via pacman..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages.txt"
  fi

  # AUR packages
  if [ -f "$DOTFILES_DIR/packages-aur.txt" ] && command -v yay &>/dev/null; then
    echo "--> Installing AUR packages from packages-aur.txt via yay..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/packages-aur.txt"
  fi

  # Mise tools
  if command -v mise &>/dev/null; then
    echo "--> Installing mise developer runtimes (node, agy, gh, etc.)..."
    mise install
  fi

  # Syncthing service
  if command -v syncthing &>/dev/null; then
    if ! systemctl is-enabled "syncthing@$USER.service" &>/dev/null; then
      echo "--> Enabling and starting Syncthing service for $USER..."
      sudo systemctl enable --now "syncthing@$USER.service"
    fi
  fi
  echo ""
fi

# --- Neovim ---
echo "--> Configuring Neovim..."
link_file "$DOTFILES_DIR/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
link_file "$DOTFILES_DIR/nvim/lua/config/keymaps.lua" "$HOME/.config/nvim/lua/config/keymaps.lua"
link_file "$DOTFILES_DIR/nvim/lazyvim.json" "$HOME/.config/nvim/lazyvim.json"

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
link_file "$DOTFILES_DIR/omarchy/b3-tracker.json" "$HOME/.config/omarchy/b3-tracker.json"
if [ -d "$DOTFILES_DIR/omarchy/themes" ]; then
  for theme_dir in "$DOTFILES_DIR/omarchy/themes"/*; do
    [ -d "$theme_dir" ] || continue
    theme_name="$(basename "$theme_dir")"
    link_file "$theme_dir" "$HOME/.config/omarchy/themes/$theme_name"
  done
fi

# Ensure third-party Omarchy shell plugins (e.g. OmaStats) are installed
if [ ! -d "$HOME/.config/omarchy/plugins/crmne.omastats" ]; then
  echo "--> Installing Omarchy OmaStats plugin..."
  mkdir -p "$HOME/.config/omarchy/plugins"
  git clone https://github.com/crmne/omastats.git "$HOME/.config/omarchy/plugins/crmne.omastats"
  if command -v omarchy-shell &>/dev/null; then
    omarchy-shell shell rescanPlugins &>/dev/null || true
  fi
fi

# Ensure personal B3 tracker development repo and Omarchy plugin are installed
b3_dev_dir="$HOME/Work/personal/omarchy-b3-tracker"
b3_plugin_dir="$HOME/.config/omarchy/plugins/gcorreia.b3-tracker"

if [ ! -d "$b3_dev_dir" ]; then
  echo "--> Cloning personal omarchy-b3-tracker repository..."
  mkdir -p "$(dirname "$b3_dev_dir")"
  if ! git clone git@github.com:gabrielclcardoso/omarchy-b3-tracker.git "$b3_dev_dir" 2>/dev/null; then
    git clone https://github.com/gabrielclcardoso/omarchy-b3-tracker.git "$b3_dev_dir"
  fi
fi

# Ensure post-commit hook exists in dev repo to sync to the plugin directory
if [ -d "$b3_dev_dir/.git" ]; then
  hook_file="$b3_dev_dir/.git/hooks/post-commit"
  if [ ! -f "$hook_file" ]; then
    echo "--> Installing post-commit hook for omarchy-b3-tracker..."
    cat << 'EOF' > "$hook_file"
#!/usr/bin/env bash
# Automatically sync commits from personal repo to Omarchy plugins directory
PLUGIN_DIR="$HOME/.config/omarchy/plugins/gcorreia.b3-tracker"
if [ -d "$PLUGIN_DIR/.git" ]; then
    git -C "$PLUGIN_DIR" pull --ff-only 2>/dev/null || true
fi
EOF
    chmod +x "$hook_file"
  fi
fi

# Ensure plugin is installed in Omarchy plugins directory
if [ ! -d "$b3_plugin_dir" ]; then
  echo "--> Installing Omarchy B3 Tracker plugin..."
  mkdir -p "$HOME/.config/omarchy/plugins"
  if [ -d "$b3_dev_dir/.git" ]; then
    git clone "$b3_dev_dir" "$b3_plugin_dir"
  else
    git clone https://github.com/gabrielclcardoso/omarchy-b3-tracker.git "$b3_plugin_dir"
  fi
  if command -v omarchy-shell &>/dev/null; then
    omarchy-shell shell rescanPlugins &>/dev/null || true
  fi
fi

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

if command -v omarchy-shell &>/dev/null; then
  echo "--> Reloading Omarchy shell configuration and plugins..."
  omarchy-shell shell rescanPlugins &>/dev/null || true
  omarchy-shell shell reloadConfig &>/dev/null || true
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
if [ "$INSTALL_PKGS" = "0" ]; then
  echo ""
  echo "Tip: Run './setup.sh --install-pkgs' to install user applications (packages.txt), AUR packages, and mise tools."
fi
