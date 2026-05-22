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

  # Prefer the local symlink installer when run from a clone of the repo.
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
  if [ -n "$script_dir" ] && [ -f "$script_dir/claude/install.sh" ]; then
    bash "$script_dir/claude/install.sh"
    log_ok "claude code setup complete (symlinked from clone)"
    return 0
  fi

  # Remote bootstrap (curl | bash): copy the portable files.
  # settings.json is a baseline; Claude rewrites it at runtime, so only seed it
  # when missing and never touch a machine-local settings.local.json.
  if [ -e "$HOME/.claude/settings.json" ]; then
    log_skip "settings.json exists — leaving it (Claude manages it at runtime)"
  else
    fetch_config "claude/.claude/settings.json" "$HOME/.claude/settings.json"
  fi
  fetch_config "claude/.claude/hooks/rtk-rewrite.sh" "$HOME/.claude/hooks/rtk-rewrite.sh"
  chmod +x "$HOME/.claude/hooks/rtk-rewrite.sh"
  fetch_config "claude/.claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
  chmod +x "$HOME/.claude/statusline-command.sh"
  fetch_config "claude/.claude/RTK.md" "$HOME/.claude/RTK.md"
  fetch_config "claude/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  log_skip "skills/agents are not fetched remotely — run claude/install.sh from a clone for those"

  log_ok "claude code setup complete"
}

install_git() {
  log_ok "setting up git..."

  # Install git binary if missing
  if command -v git >/dev/null 2>&1; then
    log_skip "git already installed ($(git --version))"
  elif has_sudo; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq git
    log_ok "installed git via apt"
  else
    log_err "git requires sudo to install via apt — skipping"
    return 1
  fi

  # Fetch gitconfig and gitignore_global
  fetch_config "git/.gitconfig" "$HOME/.gitconfig"
  fetch_config "git/.gitignore_global" "$HOME/.gitignore_global"

  # Prompt for user identity
  local current_name current_email name email

  current_name=$(git config --global user.name 2>/dev/null || true)
  current_email=$(git config --global user.email 2>/dev/null || true)

  printf 'Git user name'
  [ -n "$current_name" ] && printf ' [%s]' "$current_name"
  printf ': '
  read -r name
  [ -z "$name" ] && name="$current_name"

  printf 'Git user email'
  [ -n "$current_email" ] && printf ' [%s]' "$current_email"
  printf ': '
  read -r email
  [ -z "$email" ] && email="$current_email"

  if [ -n "$name" ]; then
    git config --global user.name "$name"
    log_ok "set git user.name = $name"
  fi
  if [ -n "$email" ]; then
    git config --global user.email "$email"
    log_ok "set git user.email = $email"
  fi

  log_ok "git setup complete"
}

install_aliases() {
  log_ok "setting up shell aliases..."

  local aliases_file="$HOME/.dotfiles_aliases.sh"

  cat > "$aliases_file" << 'ALIASES'
# Dotfiles shell aliases — managed by install.sh
# Do not edit manually; re-run install.sh to update.

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# ls / tree (use eza if available, fallback to system ls)
if command -v eza >/dev/null 2>&1; then
  alias l='eza -lh'
  alias la='eza -lha'
  alias ls='eza'
  alias tree='eza --tree --long'
else
  alias l='ls -lh'
  alias la='ls -lha'
fi

# Misc
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'
alias please='sudo $(fc -ln -1)'

# vim -> nvim (if available)
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

# Git
alias ga='git add '
alias gap='git add -p'
alias gps='git push'
alias gpl='git pull'
alias gcm='git commit -m '

# Docker (if available)
if command -v docker >/dev/null 2>&1; then
  alias d="docker"
  alias d_a="docker attach"
  alias d_m="docker rm"
  alias d_lc="docker ps"
  alias d_li="docker images"
  alias d_rm_all_containers='docker rm $(docker ps -a -q)'
  alias d_rm_all_images='docker rmi $(docker images -q)'
  alias d_stop_all='docker stop $(docker ps -a -q)'
fi

# Kubectl (if available)
if command -v kubectl >/dev/null 2>&1; then
  alias k="kubectl"
fi
ALIASES

  log_ok "wrote $aliases_file"

  # Idempotently add source line to shell rc files
  local source_line='. "$HOME/.dotfiles_aliases.sh"'

  for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc_file" ]; then
      if ! grep -qF '.dotfiles_aliases.sh' "$rc_file"; then
        printf '\n# Dotfiles aliases\n%s\n' "$source_line" >> "$rc_file"
        log_ok "added source line to $rc_file"
      else
        log_skip "source line already in $rc_file"
      fi
    else
      log_skip "$rc_file does not exist — skipping"
    fi
  done

  log_ok "aliases setup complete (restart shell or run: source $aliases_file)"
}

# --- Argument parsing & main ---

usage() {
  cat <<'EOF'
Usage: install.sh [OPTIONS]

Sets up tmux, neovim, Claude Code, git, and shell aliases on Ubuntu Linux.

Options:
  --help          Show this help message
  --version       Show version
  --only TOOL     Install only one tool (tmux, neovim, claude, git, aliases)
EOF
}

main() {
  local only=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --help) usage; exit 0 ;;
      --version) printf 'dotfiles installer v%s\n' "$VERSION"; exit 0 ;;
      --only)
        [ $# -lt 2 ] && { log_err "--only requires an argument (tmux, neovim, claude, git, aliases)"; exit 1; }
        only="$2"; shift 2 ;;
      *) log_err "unknown option: $1"; usage; exit 1 ;;
    esac
  done

  log_ok "dotfiles installer v${VERSION}"

  check_os
  setup_prefix

  case "$only" in
    "") install_tmux; install_neovim; install_claude_code; install_git; install_aliases ;;
    tmux) install_tmux ;;
    neovim) install_neovim ;;
    claude) install_claude_code ;;
    git) install_git ;;
    aliases) install_aliases ;;
    *) log_err "unknown tool: $only (use tmux, neovim, claude, git, aliases)"; exit 1 ;;
  esac

  log_ok "done!"
}

main "$@"
