```

              88                          ad88  88  88
              88                ,d       d8"    ""  88
              88                88       88         88
      ,adPPYb,88   ,adPPYba,  MM88MMM  MM88MMM  88  88   ,adPPYba,  ,adPPYba,
     a8"    `Y88  a8"     "8a   88       88     88  88  a8P_____88  I8[    ""
     8b       88  8b       d8   88       88     88  88  8PP"""""""   `"Y8ba,
888  "8a,   ,d88  "8a,   ,a8"   88,      88     88  88  "8b,   ,aa  aa    ]8I
888   `"8bbdP"Y8   `"YbbdP"'    "Y888    88     88  88   `"Ybbd8"'  `"YbbdP"'
```


# overview

- Uses `stow` to handle the symlinking.
- Checkout `setup -h` (or the `setup` file) for what you can do.

```
# file tree (excerpt)
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

## What I use

- vim
  - dein (package manager)
- tmux
- tmux-powerline
- stow (to setup the dotfiles)
- gnome3
- fedora
- snaps (to isolate some packages I don't really trust, and to make the installation process easy)
- wmctrl (to switch to already open windows)
- keepassxc (works everywhere, and the firefox plugin is super cool)
- conda (python)
- your ssh config will

## TODO

- add dropbox installer
- add android studio
- add thunderbird (fix google setup)
- add ssh permission fix
- checkout https://github.com/MeesCode/NordVPN-GNOME-Extention

## DONE (not all features)

-[x] find a good script which sets up the symlinks in a non stupid way
-[x] use dconf and dconf-editor to extract the nice gnome settings
-[x] create setup script (should respect hostname or tags)
-[x] find a way to setup up ssh stuff in a good way
-[x] add keyboard shortcut exporter
