#!/usr/bin/env bash
set -euo pipefail

VERSION="1.1.1"

REPO_RAW_URL="https://raw.githubusercontent.com/samuelsmal/dotfiles/master"
INSTALL_PREFIX=""

# --- Logging ---

log_ok()   { printf '[ok]   %s\n' "$*"; }
log_skip() { printf '[skip] %s\n' "$*"; }
log_err()  { printf '[err]  %s\n' "$*" >&2; }

# --- Helpers ---

has_sudo() {
  command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null
}

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    cp "$file" "${file}.bak"
    log_ok "backed up $file -> ${file}.bak"
  fi
}

fetch_config() {
  local repo_path="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  backup_file "$dest"
  if curl -fsSL "${REPO_RAW_URL}/${repo_path}" -o "$dest"; then
    log_ok "fetched $dest"
  else
    log_err "failed to fetch $repo_path"
    return 1
  fi
}

# --- OS Checks ---

check_os() {
  if [ "$(uname -s)" != "Linux" ]; then
    log_err "this script only supports Linux"
    exit 1
  fi
  if ! grep -qi ubuntu /etc/os-release 2>/dev/null; then
    log_err "this script only supports Ubuntu"
    exit 1
  fi
  log_ok "detected Ubuntu Linux"
}

# --- Install prefix ---

setup_prefix() {
  if has_sudo; then
    INSTALL_PREFIX="/usr/local"
    log_ok "sudo available, installing to $INSTALL_PREFIX"
  else
    INSTALL_PREFIX="$HOME/.local"
    mkdir -p "$INSTALL_PREFIX/bin"
    log_ok "no sudo, installing to $INSTALL_PREFIX"
    case ":$PATH:" in
      *":$INSTALL_PREFIX/bin:"*) ;;
      *) export PATH="$INSTALL_PREFIX/bin:$PATH"
         log_ok "added $INSTALL_PREFIX/bin to PATH (add to your .profile to persist)" ;;
    esac
  fi
}

# --- Tool installers ---

install_tmux() {
  log_ok "installing tmux..."

  # Install binary
  if command -v tmux >/dev/null 2>&1; then
    log_skip "tmux already installed ($(tmux -V))"
  elif has_sudo; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq tmux
    log_ok "installed tmux via apt"
  else
    log_err "tmux requires sudo to install via apt — skipping binary install"
  fi

  # Fetch configs
  fetch_config "tmux/.tmux.conf" "$HOME/.tmux.conf"
  fetch_config "tmux/.tmux/themes/dark.conf" "$HOME/.tmux/themes/dark.conf"
  fetch_config "tmux/.tmux/themes/light.conf" "$HOME/.tmux/themes/light.conf"
  fetch_config "tmux/.tmux/claude-status.sh" "$HOME/.tmux/claude-status.sh"
  chmod +x "$HOME/.tmux/claude-status.sh"

  log_ok "tmux setup complete"
}

install_neovim() {
  log_ok "installing neovim..."

  # Install binary
  if command -v nvim >/dev/null 2>&1; then
    log_skip "neovim already installed ($(nvim --version | head -1))"
  else
    local nvim_version
    nvim_version=$(curl -fsSL -o /dev/null -w '%{redirect_url}' "https://github.com/neovim/neovim/releases/latest" | grep -oP 'v[\d.]+')
    local nvim_tarball="nvim-linux-x86_64.tar.gz"
    local nvim_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/${nvim_tarball}"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    log_ok "downloading neovim ${nvim_version}..."
    curl -fsSL "$nvim_url" -o "${tmp_dir}/${nvim_tarball}"
    tar xzf "${tmp_dir}/${nvim_tarball}" -C "$tmp_dir"

    local extracted_dir="${tmp_dir}/nvim-linux-x86_64"
    if has_sudo; then
      sudo cp -r "${extracted_dir}"/bin/* "${INSTALL_PREFIX}/bin/"
      sudo cp -r "${extracted_dir}"/lib/* "${INSTALL_PREFIX}/lib/"
      sudo cp -r "${extracted_dir}"/share/* "${INSTALL_PREFIX}/share/"
    else
      cp -r "${extracted_dir}"/bin/* "${INSTALL_PREFIX}/bin/"
      mkdir -p "${INSTALL_PREFIX}/lib" "${INSTALL_PREFIX}/share"
      cp -r "${extracted_dir}"/lib/* "${INSTALL_PREFIX}/lib/"
      cp -r "${extracted_dir}"/share/* "${INSTALL_PREFIX}/share/"
    fi

    rm -rf "$tmp_dir"
    log_ok "installed neovim ${nvim_version} to ${INSTALL_PREFIX}"
  fi

  # Fetch configs
  local nvim_configs=(
    "nvim/.config/nvim/init.lua"
    "nvim/.config/nvim/lazy-lock.json"
    "nvim/.config/nvim/lua/config/options.lua"
    "nvim/.config/nvim/lua/config/keymaps.lua"
    "nvim/.config/nvim/lua/config/autocmds.lua"
    "nvim/.config/nvim/lua/config/lazy.lua"
    "nvim/.config/nvim/lua/plugins/colorscheme.lua"
    "nvim/.config/nvim/lua/plugins/telescope.lua"
    "nvim/.config/nvim/lua/plugins/editor.lua"
    "nvim/.config/nvim/lua/plugins/neo-tree.lua"
    "nvim/.config/nvim/lua/plugins/lualine.lua"
    "nvim/.config/nvim/spell/en.utf-8.add"
  )

  for cfg in "${nvim_configs[@]}"; do
    local dest="$HOME/.config/nvim/${cfg#nvim/.config/nvim/}"
    fetch_config "$cfg" "$dest"
  done

  log_ok "neovim setup complete"
}

install_claude_code() {
  log_ok "installing claude code..."

  if command -v claude >/dev/null 2>&1; then
    log_skip "claude code already installed"
  else
    curl -fsSL https://claude.ai/install.sh | bash
    log_ok "installed claude code"
  fi

  # Fetch configs
  fetch_config "claude/.claude/settings.json" "$HOME/.claude/settings.json"
  fetch_config "claude/.claude/hooks/rtk-rewrite.sh" "$HOME/.claude/hooks/rtk-rewrite.sh"
  chmod +x "$HOME/.claude/hooks/rtk-rewrite.sh"
  fetch_config "claude/.claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
  chmod +x "$HOME/.claude/statusline-command.sh"

  log_ok "claude code setup complete"
}

# --- Argument parsing & main ---

usage() {
  cat <<'EOF'
Usage: install.sh [OPTIONS]

Sets up tmux, neovim, and Claude Code on Ubuntu Linux.

Options:
  --help          Show this help message
  --only TOOL     Install only one tool (tmux, neovim, claude)
EOF
}

main() {
  local only=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --help) usage; exit 0 ;;
      --version) printf 'dotfiles installer v%s\n' "$VERSION"; exit 0 ;;
      --only)
        [ $# -lt 2 ] && { log_err "--only requires an argument (tmux, neovim, claude)"; exit 1; }
        only="$2"; shift 2 ;;
      *) log_err "unknown option: $1"; usage; exit 1 ;;
    esac
  done

  log_ok "dotfiles installer v${VERSION}"

  check_os
  setup_prefix

  case "$only" in
    "") install_tmux; install_neovim; install_claude_code ;;
    tmux) install_tmux ;;
    neovim) install_neovim ;;
    claude) install_claude_code ;;
    *) log_err "unknown tool: $only (use tmux, neovim, or claude)"; exit 1 ;;
  esac

  log_ok "done!"
}

main "$@"
