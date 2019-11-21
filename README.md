# My dotfiles

Uses `stow` to handle the symlinking.

Checkout `setup -h` (or the `setup` file) for what you can do.

`stow` will symlink every folder one directoy up.

```
├── _hosts                     # host specific stuff
├── README.md                  # this file
├── .version_lock              # used for migrating
├── _setup                     # general setup stuff, aka misc, but with symlinks to anywhere
├── setup                      # system setup stuff, a bit misc, but with symlink with stow
├── _ssh                       # only some setup stuff
├── stow                       # stow settings (ignore file)
├── _system-settings           # system settings, keyboard shortcuts, ...
├── _thunderbird               # thunderbird settings, firefox are in _setup (a bit)
├── (_[A-Za-z_-]+)             # used by setup 
└── ([A-Za-z_-]+)              # used by stow
```

## TODO

-[ ] add dropbox installer
-[ ] add android studio
-[ ] add thunderbird (fix google setup)
-[ ] add ssh permission fix
-[ ] checkout https://github.com/MeesCode/NordVPN-GNOME-Extention

## What I use (and why)?

- vim (not neovim, vim is also parallel now)
  - dein (package manager)
- tmux
- tmux-powerline (why?)
- stow (to setup the dotfiles)
- gnome3
- fedora
- snaps (to isolate some packages I don't really trust, and to make the installation process easy)
- wmctrl (to switch to already open windows)
- keepassx (works everywhere)
- conda (python)
- your ssh config will 

## DONE (not all features)

-[x] find a good script which sets up the symlinks in a non stupid way
-[x] use dconf and dconf-editor to extract the nice gnome settings
-[x] create setup script (should respect hostname or tags)
-[x] find a way to setup up ssh stuff in a good way
-[x] add keyboard shortcut exporter
