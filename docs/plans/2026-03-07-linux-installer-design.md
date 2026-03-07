# Linux Installer Script Design

## Goal

A single `install.sh` at the repo root that can be run via `curl ... | bash` to set up tmux, neovim, and Claude Code on Ubuntu Linux VMs. Minimal, idempotent, no dependencies on stow or git clone.

## Structure

```
install.sh (single file, modular functions)
├── Checks & setup
│   ├── Verify Linux (uname)
│   ├── Verify Ubuntu (/etc/os-release)
│   ├── Detect sudo availability
│   └── Set install prefix (~/.local/bin or /usr/local/bin)
├── install_tmux()
│   ├── apt install tmux (requires sudo, skip with warning if unavailable)
│   └── Fetch configs: ~/.tmux.conf, ~/.tmux/themes/, ~/.tmux/claude-status.sh
├── install_neovim()
│   ├── Download latest stable neovim tarball from GitHub releases
│   ├── Extract to install prefix
│   └── Fetch configs: ~/.config/nvim/ (init.lua, lua/**/*, lazy-lock.json)
├── install_claude_code()
│   └── Run: curl -fsSL https://claude.ai/install.sh | bash
└── main()
    ├── Parse args: --only <tool>, --help
    └── Run all or selected install functions
```

## Config files fetched via curl

Base URL: `https://raw.githubusercontent.com/samuelsmal/dotfiles/master/`

**tmux (4 files):**
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `tmux/.tmux/themes/dark.conf` -> `~/.tmux/themes/dark.conf`
- `tmux/.tmux/themes/light.conf` -> `~/.tmux/themes/light.conf`
- `tmux/.tmux/claude-status.sh` -> `~/.tmux/claude-status.sh`

**neovim (10 files, excludes .spl binary):**
- `nvim/.config/nvim/init.lua` -> `~/.config/nvim/init.lua`
- `nvim/.config/nvim/lazy-lock.json` -> `~/.config/nvim/lazy-lock.json`
- `nvim/.config/nvim/lua/config/options.lua` -> `~/.config/nvim/lua/config/options.lua`
- `nvim/.config/nvim/lua/config/keymaps.lua` -> `~/.config/nvim/lua/config/keymaps.lua`
- `nvim/.config/nvim/lua/config/autocmds.lua` -> `~/.config/nvim/lua/config/autocmds.lua`
- `nvim/.config/nvim/lua/config/lazy.lua` -> `~/.config/nvim/lua/config/lazy.lua`
- `nvim/.config/nvim/lua/plugins/colorscheme.lua` -> `~/.config/nvim/lua/plugins/colorscheme.lua`
- `nvim/.config/nvim/lua/plugins/telescope.lua` -> `~/.config/nvim/lua/plugins/telescope.lua`
- `nvim/.config/nvim/lua/plugins/editor.lua` -> `~/.config/nvim/lua/plugins/editor.lua`
- `nvim/.config/nvim/lua/plugins/neo-tree.lua` -> `~/.config/nvim/lua/plugins/neo-tree.lua`
- `nvim/.config/nvim/lua/plugins/lualine.lua` -> `~/.config/nvim/lua/plugins/lualine.lua`
- `nvim/.config/nvim/spell/en.utf-8.add` -> `~/.config/nvim/spell/en.utf-8.add`

## Behavior

- Idempotent: safe to run multiple times
- Backs up existing config files with `.bak` suffix
- `--only tmux|neovim|claude` for selective install
- `--help` for usage
- Plain output with `[ok]`, `[skip]`, `[err]` prefixes (no color dependencies)
- Non-interactive (works with curl|bash)
- sudo detection: uses sudo for apt if available, installs to ~/.local/bin otherwise
- No tmuxinator configs (project-specific)

## Non-goals

- No stow, no git clone
- No package manager abstraction (Ubuntu apt only)
- No interactive prompts
- No macOS support
