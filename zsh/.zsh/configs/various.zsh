# Various
setopt extendedglob     # activate complex pattern globbing
setopt correct          # try to correct spelling of commands
setopt glob_dots        # include dotfiles in globbing
setopt print_exit_value # print return value if non-zero
unsetopt beep notify    # no beep

print -Pn "\e]0; %n@%M: %~\a" # terminal title
