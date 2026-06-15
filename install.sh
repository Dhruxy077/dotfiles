#!/usr/bin/env bash
# =============================================================================
#  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
#  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
#  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
#  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
#  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
#  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
#
#  Hyprland Dotfiles Install Script
#  github: dhruxy-_- | noctalia theme
# =============================================================================

set -euo pipefail

# ─── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ─── Helpers ──────────────────────────────────────────────────────────────────
info() { echo -e "${BLUE}${BOLD}  ::${RESET}  $*"; }
success() { echo -e "${GREEN}${BOLD}  ✓ ${RESET}  $*"; }
warn() { echo -e "${YELLOW}${BOLD}  ⚠ ${RESET}  $*"; }
error() { echo -e "${RED}${BOLD}  ✗ ${RESET}  $*" >&2; }
step() { echo -e "\n${MAGENTA}${BOLD}━━━ $* ━━━${RESET}"; }
dim() { echo -e "${DIM}      $*${RESET}"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Banner ───────────────────────────────────────────────────────────────────
print_banner() {
  echo -e "${CYAN}${BOLD}"
  cat <<'EOF'
  ╔══════════════════════════════════════════════════════╗
  ║       Hyprland · Noctalia Dotfiles Installer         ║
  ║                                                      ║
  ║   Configs → ~/.config     Scripts → ~/.local/bin     ║
  ╚══════════════════════════════════════════════════════╝
EOF
  echo -e "${RESET}"
  echo -e "${DIM}  Dotfiles source: ${DOTFILES_DIR}${RESET}\n"
}

# ─── Distro Detection ─────────────────────────────────────────────────────────
detect_distro() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
  else
    DISTRO_ID="unknown"
    DISTRO_LIKE=""
  fi

  if command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
  elif command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt"
  elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
  else
    PKG_MANAGER="unknown"
  fi

  info "Detected distro: ${BOLD}${DISTRO_ID}${RESET}  (pkg manager: ${PKG_MANAGER})"
}

# ─── GPU / Display Driver Detection ──────────────────────────────────────────
detect_and_install_gpu() {
  info "Detecting GPU hardware…"

  local lspci_output
  lspci_output="$(lspci 2>/dev/null || true)"

  HAS_NVIDIA=false
  HAS_AMD=false
  HAS_INTEL=false

  if echo "$lspci_output" | grep -qi "VGA.*NVIDIA\|3D.*NVIDIA\|Display.*NVIDIA"; then
    HAS_NVIDIA=true
    info "NVIDIA GPU detected"
  fi
  if echo "$lspci_output" | grep -qi "VGA.*AMD\|VGA.*ATI\|Display.*AMD\|3D.*AMD"; then
    HAS_AMD=true
    info "AMD GPU detected"
  fi
  if echo "$lspci_output" | grep -qi "VGA.*Intel\|Display.*Intel\|3D.*Intel"; then
    HAS_INTEL=true
    info "Intel GPU detected"
  fi

  # NVIDIA packages
  if $HAS_NVIDIA; then
    GPU_PKGS+=(
      nvidia-dkms          # NVIDIA kernel module (DKMS)
      nvidia-utils         # NVIDIA userspace utils
      lib32-nvidia-utils   # 32-bit NVIDIA libs (wine/steam)
      nvidia-settings      # NVIDIA control panel
      vulkan-icd-loader    # Vulkan ICD loader
      lib32-vulkan-icd-loader
    )
    # Also install mesa for NVIDIA GBM backend
    GPU_PKGS+=(mesa lib32-mesa)
  fi

  # AMD packages
  if $HAS_AMD; then
    GPU_PKGS+=(
      mesa                 # Open-source GPU drivers
      lib32-mesa           # 32-bit mesa
      vulkan-radeon        # AMD Vulkan driver
      lib32-vulkan-radeon  # 32-bit AMD Vulkan
      libva-mesa-driver    # VA-API hardware video decode
      lib32-libva-mesa-driver
      mesa-vdpau           # VDPAU video acceleration
      lib32-mesa-vdpau
    )
  fi

  # Intel packages
  if $HAS_INTEL; then
    GPU_PKGS+=(
      mesa                 # Open-source GPU drivers
      lib32-mesa           # 32-bit mesa
      vulkan-intel         # Intel Vulkan driver
      lib32-vulkan-intel   # 32-bit Intel Vulkan
      intel-media-driver   # VA-API for newer Intel GPUs (iHD)
      libva-intel-driver   # VA-API for older Intel GPUs (i965)
      intel-gpu-tools      # Intel GPU debugging tools
    )
  fi

  # If no GPU detected, install mesa as fallback
  if ! $HAS_NVIDIA && ! $HAS_AMD && ! $HAS_INTEL; then
    warn "No GPU detected via lspci — installing generic mesa drivers"
    GPU_PKGS+=(mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader)
  fi

  info "GPU packages to install: ${GPU_PKGS[*]}"
}

# ─── Package Installation ─────────────────────────────────────────────────────
install_packages() {
  if [[ "$PKG_MANAGER" == "pacman" ]]; then
    install_arch_packages
  elif [[ "$PKG_MANAGER" == "apt" ]]; then
    install_debian_packages
  else
    warn "Unsupported package manager '${PKG_MANAGER}'. Skipping automatic package install."
    warn "Please manually install the packages listed in README.md"
  fi
}

install_arch_packages() {
  step "Installing packages (Arch / AUR)"

  # Detect AUR helper
  local aur_helper=""
  for helper in yay paru pikaur; do
    if command -v "$helper" &>/dev/null; then
      aur_helper="$helper"
      break
    fi
  done

  if [[ -z "$aur_helper" ]]; then
    warn "No AUR helper found (yay/paru/pikaur). Installing yay…"
    _install_yay
    aur_helper="yay"
  fi

  info "Using AUR helper: ${BOLD}${aur_helper}${RESET}"

  # ── Core Hyprland stack ────────────────────────────────────────────────────
  local CORE_PKGS=(
    hyprland   # The compositor itself
    hyprlock   # Lock screen (hyprland-native)
    hypridle   # Idle daemon
    hyprpicker # AUR: color picker
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
  )

  # ── Display drivers (auto-detected) ───────────────────────────────────────
  local GPU_PKGS=()
  detect_and_install_gpu

  # ── Shell / Noctalia Shell ─────────────────────────────────────────────────
  local SHELL_PKGS=(
    quickshell # QML shell used by noctalia-shell (qs)
    swww       # Wayland wallpaper daemon
  )

  # ── Terminals ─────────────────────────────────────────────────────────────
  local TERMINAL_PKGS=(
    ghostty
    kitty
    alacritty
  )

  # ── Fonts & Cursors ────────────────────────────────────────────────────────
  local FONT_PKGS=(
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    noto-fonts
    noto-fonts-emoji
    bibata-cursor-theme # AUR: Bibata-Modern-Ice cursor
  )

  # ── Wayland utilities ─────────────────────────────────────────────────────
  local WAYLAND_PKGS=(
    wl-clipboard
    cliphist        # Clipboard history manager
    wl-clip-persist # AUR: keeps clipboard alive after app close
    brightnessctl   # Screen / keyboard backlight
    playerctl       # MPRIS media control
    pamixer         # PulseAudio/Pipewire volume CLI
    pipewire
    pipewire-alsa
    pipewire-pulse
    wireplumber
    grim     # Screenshot backend (Wayland)
    slurp    # Region selector (used by hyprshot)
    hyprshot # AUR: Hyprland screenshot wrapper (SUPER+Print)
  )

  # ── Authentication / Polkit ────────────────────────────────────────────────
  local AUTH_PKGS=(
    xfce-polkit # Polkit authentication agent
    gnome-keyring
    seahorse # GUI keyring manager (org.gnome.seahorse.Application)
  )

  # ── File manager & GUI tools ───────────────────────────────────────────────
  local GUI_PKGS=(
    thunar
    thunar-archive-plugin
    tumbler     # Thumbnail generation
    gvfs        # Virtual filesystem
    file-roller # Archive manager (engrampa alternative)
    nwg-look    # GTK theme switcher
    kvantum     # Qt theme engine
    qt6ct       # Qt6 color / theme config
    blueman     # Bluetooth manager
    network-manager-applet
    nm-connection-editor
    pavucontrol  # PulseAudio/Pipewire volume GUI
    nwg-displays # graphical output management utility for Wayland compositors
  )

  # ── Dev & CLI tools ────────────────────────────────────────────────────────
  local CLI_PKGS=(
    neovim
    fish      # Fish shell
    starship  # Cross-shell prompt
    fastfetch # System info
    btop      # Resource monitor
    git
    curl
    wget
    ripgrep
    fd
    fzf
    jq
    eza       # Modern 'ls' replacement (used in fish config)
    bat       # Modern 'cat' replacement (used in fish config)
    zoxide    # Smart 'cd' replacement (used in fish config)
    ananicy-cpp                # Process priority daemon (referenced in environ.conf)
    python-terminaltexteffects # AUR: 'tte' — required by the screensaver
  )

  # ── Media ─────────────────────────────────────────────────────────────────
  local MEDIA_PKGS=(
    spotify-launcher
    vlc
    mpv
    cava         # Audio visualizer (used by noctalia templates)
  )

  # ── Optional / gaming ─────────────────────────────────────────────────────
  local OPTIONAL_PKGS=(
    lutris
    qbittorrent
    bleachbit
  )

  local ALL_PKGS=(
    "${CORE_PKGS[@]}"
    "${GPU_PKGS[@]}"
    "${SHELL_PKGS[@]}"
    "${TERMINAL_PKGS[@]}"
    "${FONT_PKGS[@]}"
    "${WAYLAND_PKGS[@]}"
    "${AUTH_PKGS[@]}"
    "${GUI_PKGS[@]}"
    "${CLI_PKGS[@]}"
    "${MEDIA_PKGS[@]}"
  )

  info "Installing ${#ALL_PKGS[@]} packages (core + dependencies)…"

  # pacman first for anything in official repos, then AUR helper for the rest
  if ! "$aur_helper" -S --needed --noconfirm "${ALL_PKGS[@]}"; then
    warn "Some packages may have failed; continuing anyway."
  fi

  # ── Optional packages (prompt) ─────────────────────────────────────────────
  echo
  read -rp "$(echo -e "${YELLOW}${BOLD}  ?${RESET}  Install optional packages (lutris, qbittorrent, bleachbit)? [y/N] ")" _opt
  if [[ "$_opt" =~ ^[Yy]$ ]]; then
    "$aur_helper" -S --needed --noconfirm "${OPTIONAL_PKGS[@]}" || true
  fi
}

install_debian_packages() {
  step "Installing packages (Debian / Ubuntu)"
  warn "Debian/Ubuntu support is best-effort. Some packages may differ or be unavailable."

  sudo apt-get update -qq

  local APT_PKGS=(
    hyprland
    kitty
    alacritty
    fish
    neovim
    brightnessctl
    playerctl
    pamixer
    pipewire
    wireplumber
    thunar
    blueman
    network-manager-gnome
    pavucontrol
    btop
    git
    curl
    wget
    ripgrep
    fd-find
    fzf
    jq
    fastfetch
    gvfs
  )

  sudo apt-get install -y "${APT_PKGS[@]}" || warn "Some packages failed; continuing."

  # Packages not in apt repos – hint to user
  warn "The following are NOT available in apt and must be installed manually:"
  warn "  • quickshell (qs) – build from source: https://github.com/outfoxxed/quickshell"
  warn "  • swww            – https://github.com/LGFae/swww"
  warn "  • hypridle        – https://github.com/hyprwm/hypridle"
  warn "  • hyprshot        – https://github.com/Gustash/Hyprshot"
  warn "  • cliphist        – https://github.com/sentriz/cliphist"
  warn "  • wl-clip-persist – https://github.com/Linus789/wl-clip-persist"
  warn "  • Bibata cursor   – https://github.com/ful1e5/Bibata_Cursor"
  warn "  • starship        – curl -sS https://starship.rs/install.sh | sh"
  warn "  • tte (screensaver) – pip install terminal-text-effects"
}

_install_yay() {
  info "Cloning and building yay…"
  local tmp
  tmp="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  success "yay installed"
}

# ─── Backup helper ────────────────────────────────────────────────────────────
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
_backup() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    local rel="${target#"$HOME/"}"
    local dest="$BACKUP_DIR/$rel"
    mkdir -p "$(dirname "$dest")"
    cp -a "$target" "$dest"
    dim "  backed up: ~/${rel}"
  fi
}

# ─── Copy config files ────────────────────────────────────────────────────────
copy_configs() {
  step "Copying config files  →  ~/.config"

  local CONFIG_SRC="$DOTFILES_DIR/.config"
  local CONFIG_DST="$HOME/.config"

  # Directories to copy (relative to .config/)
  local CONFIG_DIRS=(
    hypr
    noctalia
    fish
    ghostty
    kitty
    alacritty
    fastfetch
    nvim
  )

  # Individual files to copy (relative to .config/)
  local CONFIG_FILES=(
    starship.toml
  )

  for dir in "${CONFIG_DIRS[@]}"; do
    local src="$CONFIG_SRC/$dir"
    local dst="$CONFIG_DST/$dir"
    if [[ -d "$src" ]]; then
      _backup "$dst"
      mkdir -p "$dst"
      cp -r "$src/." "$dst/"
      success "~/.config/${dir}"
    else
      warn "Source not found, skipping: .config/${dir}"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    local src="$CONFIG_SRC/$file"
    local dst="$CONFIG_DST/$file"
    if [[ -f "$src" ]]; then
      _backup "$dst"
      cp "$src" "$dst"
      success "~/.config/${file}"
    else
      warn "Source not found, skipping: .config/${file}"
    fi
  done
}

# ─── Copy local/bin scripts ───────────────────────────────────────────────────
copy_local_scripts() {
  step "Copying local scripts  →  ~/.local/bin"

  local LOCAL_SRC="$DOTFILES_DIR/.local"
  local LOCAL_DST="$HOME/.local"

  if [[ ! -d "$LOCAL_SRC" ]]; then
    warn ".local directory not found in dotfiles, skipping."
    return
  fi

  # Copy entire .local tree (bin, share, etc.)
  cp -r "$LOCAL_SRC/." "$LOCAL_DST/"

  # Make everything under .local/bin executable
  if [[ -d "$HOME/.local/bin" ]]; then
    find "$HOME/.local/bin" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.bash" \) \
      -exec chmod +x {} \;
    # Also chmod files without extension that look like scripts (shebang check)
    find "$HOME/.local/bin" -type f ! -name "*.*" -exec bash -c \
      '[[ "$(head -c 2 "$1")" == "#!" ]] && chmod +x "$1"' _ {} \;
    success "~/.local/bin  (scripts marked executable)"
  fi
}

# ─── Copy wallpapers ──────────────────────────────────────────────────────────
copy_wallpapers() {
  step "Installing wallpapers  →  ~/media/pictures/wallpapers"

  local WALL_SRC="$DOTFILES_DIR/wallpapers"
  local WALL_DST="$HOME/media/pictures/wallpapers"

  if [[ ! -d "$WALL_SRC" ]]; then
    warn "No 'wallpapers/' folder found in dotfiles — skipping."
    return
  fi

  local total
  total=$(find "$WALL_SRC" -maxdepth 1 -type f | wc -l)
  info "Found ${BOLD}${total}${RESET} wallpapers to install…"

  mkdir -p "$WALL_DST"

  # Rsync if available (fast, skips unchanged files); fall back to cp
  if command -v rsync &>/dev/null; then
    rsync -a --info=progress2 "$WALL_SRC/" "$WALL_DST/"
  else
    cp -r "$WALL_SRC/." "$WALL_DST/"
  fi

  success "Wallpapers installed  →  ${WALL_DST}"
  dim "  ${total} images copied"

  # ── Set a random wallpaper right now if swww-daemon is running ─────────────
  _set_initial_wallpaper "$WALL_DST"
}

_set_initial_wallpaper() {
  local wall_dir="$1"

  if ! command -v swww &>/dev/null; then
    dim "  swww not found — wallpaper will be set on next Hyprland launch"
    return
  fi

  # Collect all supported image files (excluding .gif for static default)
  local -a images
  mapfile -t images < <(
    find "$wall_dir" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
      -o -iname '*.webp' -o -iname '*.gif' \) |
      shuf
  )

  if [[ ${#images[@]} -eq 0 ]]; then
    warn "No images found in ${wall_dir}"
    return
  fi

  # Prefer a non-gif for the first-boot wallpaper
  local chosen=""
  for img in "${images[@]}"; do
    if [[ "${img,,}" != *.gif ]]; then
      chosen="$img"
      break
    fi
  done
  [[ -z "$chosen" ]] && chosen="${images[0]}"

  # Start the daemon if it's not already running
  if ! swww query &>/dev/null; then
    info "Starting swww-daemon for initial wallpaper…"
    swww-daemon --no-cache &
    sleep 1
  fi

  if swww query &>/dev/null; then
    swww img "$chosen" \
      --transition-type grow \
      --transition-pos center \
      --transition-duration 1 \
      2>/dev/null && success "Wallpaper set: $(basename "$chosen")" ||
      warn "swww img failed — wallpaper will be set on next login"
  else
    dim "  swww-daemon not running — wallpaper will be set on next Hyprland launch"
  fi
}

# ─── Post-install configuration ───────────────────────────────────────────────
post_install() {
  step "Post-install configuration"

  # ── Fish as default shell ──────────────────────────────────────────────────
  if command -v fish &>/dev/null; then
    local fish_path
    fish_path="$(command -v fish)"
    if ! grep -qxF "$fish_path" /etc/shells 2>/dev/null; then
      echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "$SHELL" != "$fish_path" ]]; then
      read -rp "$(echo -e "${YELLOW}${BOLD}  ?${RESET}  Set fish as your default shell? [y/N] ")" _fish
      if [[ "$_fish" =~ ^[Yy]$ ]]; then
        chsh -s "$fish_path"
        success "Default shell set to fish"
      fi
    else
      success "Fish is already your default shell"
    fi
  fi

  # ── Enable user services ───────────────────────────────────────────────────
  if command -v systemctl &>/dev/null; then
    info "Enabling systemd user services…"
    local USER_SERVICES=(pipewire pipewire-pulse wireplumber)
    for svc in "${USER_SERVICES[@]}"; do
      if systemctl --user list-unit-files "$svc.service" &>/dev/null; then
        systemctl --user enable --now "$svc.service" 2>/dev/null &&
          success "systemd user: $svc" || dim "  $svc not found, skipping"
      else
        dim "  $svc.service not found, skipping"
      fi
    done

    # ananicy-cpp for process priority (referenced in environ.conf)
    if systemctl list-unit-files ananicy-cpp.service &>/dev/null; then
      sudo systemctl enable --now ananicy-cpp.service 2>/dev/null &&
        success "ananicy-cpp enabled" || dim "  ananicy-cpp not found"
    fi
  fi

  # ── Ensure PATH includes ~/.local/bin ─────────────────────────────────────
  mkdir -p "$HOME/.local/bin"

  local fish_conf="$HOME/.config/fish/config.fish"
  if command -v fish &>/dev/null && [[ -f "$fish_conf" ]]; then
    if ! grep -q "\.local/bin" "$fish_conf" 2>/dev/null; then
      echo 'fish_add_path $HOME/.local/bin' >>"$fish_conf"
      success "Added ~/.local/bin to fish PATH"
    fi
  fi

  # For bash/zsh fallback
  for rc in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc"; do
    if [[ -f "$rc" ]] && ! grep -q "\.local/bin" "$rc" 2>/dev/null; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$rc"
      success "Added ~/.local/bin to PATH in ${rc##*/}"
    fi
  done

  # ── XDG directory creation (matching environ.conf) ────────────────────────
  info "Creating XDG user directories…"
  local XDG_DIRS=(
    "$HOME/workspace"
    "$HOME/downloads"
    "$HOME/docs"
    "$HOME/media/music"
    "$HOME/media/pictures"
    "$HOME/media/videos"
    "$HOME/media/games"
    "$HOME/.local/share/templates"
    "$HOME/.cache/nv"
    "$HOME/.cache/cuda"
    "$HOME/.local/share/gnupg"
  )
  for d in "${XDG_DIRS[@]}"; do
    mkdir -p "$d"
  done
  success "XDG directories created"

  # ── Cursor theme ──────────────────────────────────────────────────────────
  if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true
    success "Cursor theme set (Bibata-Modern-Ice @ 24)"
  fi

  # Fix permissions for gnupg
  chmod 700 "$HOME/.local/share/gnupg" 2>/dev/null || true
}

# ─── Verify core binaries ─────────────────────────────────────────────────────
verify_installation() {
  step "Verifying core components"

  local REQUIRED_BINS=(
    hyprland
    hypridle
    swww
    qs # quickshell (noctalia-shell)
    ghostty
    brightnessctl
    cliphist
    wl-paste # wl-clipboard
    playerctl
    fish
    starship
    fastfetch
    nvim
    thunar
    tte # terminal-text-effects — required by screensaver
  )

  local OPTIONAL_BINS=(
    hyprshot
    hyprpicker
    wl-clip-persist
    pamixer
    btop
    eza
    bat
    zoxide
    cava
    spotify-launcher
    zen-browser
  )

  local missing_required=()
  local missing_optional=()

  for bin in "${REQUIRED_BINS[@]}"; do
    if command -v "$bin" &>/dev/null; then
      success "$bin"
    else
      error "$bin  ← NOT FOUND"
      missing_required+=("$bin")
    fi
  done

  echo
  info "Optional binaries:"
  for bin in "${OPTIONAL_BINS[@]}"; do
    if command -v "$bin" &>/dev/null; then
      success "$bin"
    else
      warn "$bin  (not found — optional)"
      missing_optional+=("$bin")
    fi
  done

  if [[ ${#missing_required[@]} -gt 0 ]]; then
    echo
    error "Missing required components: ${missing_required[*]}"
    warn "Some features won't work until these are installed."
    return 1
  fi
}

# ─── Launch Noctalia ──────────────────────────────────────────────────────────
launch_noctalia() {
  step "Launching Noctalia Shell"

  if ! command -v qs &>/dev/null; then
    warn "quickshell (qs) not found — cannot launch noctalia"
    warn "Install quickshell and run: qs -c noctalia-shell"
    return 1
  fi

  # Kill any existing noctalia instance
  pkill -f "qs -c noctalia-shell" 2>/dev/null || true
  sleep 0.5

  # Start noctalia in the background
  nohup qs -c noctalia-shell &>/dev/null &
  sleep 1

  if pgrep -f "qs -c noctalia-shell" &>/dev/null; then
    success "Noctalia shell launched"
  else
    warn "Noctalia may have failed to start — try running manually: qs -c noctalia-shell"
  fi
}

# ─── Print summary ────────────────────────────────────────────────────────────
print_summary() {
  echo
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${GREEN}${BOLD}  Installation complete!${RESET}"
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo
  echo -e "${BOLD}  What was installed:${RESET}"
  echo -e "  ${DIM}• Hyprland config   →  ~/.config/hypr/${RESET}"
  echo -e "  ${DIM}• Noctalia shell     →  ~/.config/noctalia/${RESET}"
  echo -e "  ${DIM}• Terminal configs   →  ~/.config/{ghostty,kitty,alacritty}/${RESET}"
  echo -e "  ${DIM}• Fish shell config  →  ~/.config/fish/${RESET}"
  echo -e "  ${DIM}• Neovim config      →  ~/.config/nvim/${RESET}"
  echo -e "  ${DIM}• Fastfetch config   →  ~/.config/fastfetch/${RESET}"
  echo -e "  ${DIM}• Starship prompt    →  ~/.config/starship.toml${RESET}"
  echo -e "  ${DIM}• Local scripts      →  ~/.local/bin/${RESET}"
  echo

  if [[ -d "$BACKUP_DIR" ]]; then
    echo -e "  ${YELLOW}Backups saved to: ${BACKUP_DIR}${RESET}"
    echo
  fi

  echo -e "  ${BOLD}Next steps:${RESET}"
  echo -e "  ${DIM}1. Log out and select Hyprland from your display manager${RESET}"
  echo -e "  ${DIM}2. Or run: ${CYAN}Hyprland${RESET}"
  echo -e "  ${DIM}3. Monitor layout is in ~/.config/hypr/hyprland.conf — adjust if needed${RESET}"
  echo -e "  ${DIM}4. Wallpapers installed to: ${CYAN}~/media/pictures/wallpapers/${RESET}"
  echo -e "  ${DIM}   Use ${CYAN}SUPER+Y${RESET}${DIM} to cycle wallpapers, ${CYAN}SUPER+SHIFT+Y${RESET}${DIM} to toggle auto-rotation${RESET}"
  echo
  echo -e "  ${DIM}Keybind cheatsheet: ${CYAN}SUPER+/${RESET}"
  echo
}

# ─── Argument parsing ─────────────────────────────────────────────────────────
usage() {
  echo -e "Usage: ${0} [OPTIONS]"
  echo
  echo -e "Options:"
  echo -e "  ${BOLD}--all${RESET}              Full install (packages + configs + scripts + wallpapers) [default]"
  echo -e "  ${BOLD}--configs-only${RESET}     Only copy config files (skip package install)"
  echo -e "  ${BOLD}--pkgs-only${RESET}        Only install packages (skip file copy)"
  echo -e "  ${BOLD}--wallpapers-only${RESET}  Only install wallpapers to ~/media/pictures/wallpapers/"
  echo -e "  ${BOLD}--launch-noctalia${RESET}  Launch noctalia shell after install"
  echo -e "  ${BOLD}--verify${RESET}           Check that all required binaries are present"
  echo -e "  ${BOLD}-h, --help${RESET}         Show this help"
  echo
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner

  local MODE="all"
  local LAUNCH_NOCTALIA=false

  # Parse all arguments (supports combining flags)
  for arg in "$@"; do
    case "$arg" in
      --all) MODE="all" ;;
      --configs-only) MODE="configs" ;;
      --pkgs-only) MODE="pkgs" ;;
      --wallpapers-only) MODE="wallpapers" ;;
      --launch-noctalia) LAUNCH_NOCTALIA=true ;;
      --verify) MODE="verify" ;;
      -h | --help) usage; exit 0 ;;
      *)
        error "Unknown option: $arg"
        usage
        exit 1
        ;;
    esac
  done

  detect_distro

  case "$MODE" in
  all)
    install_packages
    copy_configs
    copy_local_scripts
    copy_wallpapers
    post_install
    verify_installation || true
    if $LAUNCH_NOCTALIA; then
      launch_noctalia
    fi
    print_summary
    ;;
  configs)
    copy_configs
    copy_local_scripts
    copy_wallpapers
    post_install
    if $LAUNCH_NOCTALIA; then
      launch_noctalia
    fi
    print_summary
    ;;
  pkgs)
    install_packages
    ;;
  wallpapers)
    copy_wallpapers
    ;;
  verify)
    verify_installation
    ;;
  esac
}

main "$@"
