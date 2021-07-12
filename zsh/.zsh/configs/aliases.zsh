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

# merantix
alias k='kubectl'
alias gcl='gcloud'
alias mx_prj_setup='gcl config set project merantix-autosec && gcloud container clusters get-credentials merantix-autosec-gke --zone=europe-west1'

# tmuxinator
alias tm='tmuxinator'
alias tmc='tmuxinator start master_thesis_code'
alias tmr='tmuxinator start master_thesis_report'

# docker
alias d="docker"
alias d_a="docker attach"
alias d_m="docker rm"
alias d_lc="docker ps"
alias d_li="docker images"
alias d_rm_all_containers='docker rm $(docker ps -a -q)'
alias d_rm_all_images='docker rmi $(docker images -q)'
alias d_rm_all_images_ALL='docker rmi $(docker images -q -a)'
alias d_rm_untagged_images='docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')'
alias d_stop_all='docker stop $(docker ps -a -q)'
