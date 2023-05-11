# Otherwise no system integration... (no copy-paste)
alias vim="gvim -v"

# Unix
alias l='ls -lh'
alias la='ls -lha'
alias mkdir="mkdir -p"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# git
alias ga='git add '
alias gap='git add -p'
alias gps='git push'
alias gpl='git pull'
alias gcm='git commit -m '

# vim
alias vimenc="vim -u ~/.encrypted_vim_rc -x"
alias vimclean="find . -name '*.(swp|un~)' -exec rm -i '{}' \;"

# system integration
alias o='xdg-open'
alias yc='pwd | xclip -selection clipboard'
alias y='xclip -selection clipboard'

alias ssh_alarm='ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no  pi@192.168.178.87'
alias ssh_media='ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no  pi@192.168.1.2'

# cool shit
alias please='sudo $(fc -ln -1)'

# tmuxinator
alias tm='tmuxinator'
alias tmc='tmuxinator start master_thesis_code'
alias tmr='tmuxinator start master_thesis_report'

# containers & cloud
alias d="podman"
alias d_a="podman attach"
alias d_m="podman rm"
alias d_lc="podman ps"
alias d_li="podman images"
alias d_rm_all_containers='podman rm $(podman ps -a -q)'
alias d_rm_all_images='podman rmi $(podman images -q)'
alias d_rm_all_images_ALL='podman rmi $(podman images -q -a)'
alias d_rm_untagged_images='podman rmi $(podman images -a | grep "^<none>" | awk '{print $3}')'
alias d_stop_all='podman stop $(podman ps -a -q)'

alias k='kubectl'

alias m="minikube"
