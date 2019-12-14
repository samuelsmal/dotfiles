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
- Checkout `freyr -h` (or the `freyr` file) for what you can do.

```
# file tree (excerpt)
├── README.md                  # this file
├── .version_lock              # used for migrating
├── (_[A-Za-z_-]+)             # folders with this pattern are used by `freyr`
├── _freyr                     # helper scripts and utils for freyr
│   ├── migrations             # folder containing the migration steps (must follow order)
│   ├── migrations.sh          # this is the main migration script, check here to see how it works
│   └── utils.sh               # utils for freyr
├── stow                       # stow settings (ignore file)
└── ([A-Za-z_-]+)              # folders with this pattern are used by `stow`
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

## TODO

- cleanup jupyter
- add min install option (and add installer option)
- add dropbox installer
- add android studio
- add thunderbird (fix google setup)
- checkout https://github.com/MeesCode/NordVPN-GNOME-Extention

## DONE (not all features)

- migrations! if you have multiple systems and want to keep them aligned, this might help
- find a good script which sets up the symlinks in a non stupid way
- use dconf and dconf-editor to extract the nice gnome settings
- create setup script (should respect hostname or tags)
- find a way to setup up ssh stuff in a good way
- add keyboard shortcut exporter
