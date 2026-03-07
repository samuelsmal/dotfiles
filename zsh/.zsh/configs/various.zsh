# Various
setopt extendedglob     # activate complex pattern globbing
setopt correct          # try to correct spelling of commands
setopt glob_dots        # include dotfiles in globbing
setopt print_exit_value # print return value if non-zero
unsetopt beep notify    # no beep

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export HOMEBREW_INCLUDE_PATHS=$HOMEBREW_INCLUDE_PATHS:/usr/local/include/fuse/
