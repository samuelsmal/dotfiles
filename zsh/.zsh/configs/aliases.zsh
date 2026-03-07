# Unix
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias l='ls -lh'
alias la='ls -lha'
alias mkdir="mkdir -p"
alias ls='eza'
alias tree='eza --tree --long'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# git
alias ga='git add '
alias gap='git add -p'
alias gps='git push'
alias gpl='git pull'
alias gcm='git commit -m '

# cool shit
alias please='sudo $(fc -ln -1)'

# docker
alias d="docker"
alias d_a="docker attach"
alias d_m="docker rm"
alias d_lc="docker ps"
alias d_li="docker images"
alias d_rm_all_containers='docker rm $(docker ps -a -q)'
alias d_rm_all_images='docker rmi $(docker images -q)'
alias d_rm_all_images_ALL='docker rmi $(docker images -q -a)'
alias d_rm_untagged_images='docker rmi $(docker images -a | grep "^<none>" | awk '"'"'{print $3}'"'"')'
alias d_stop_all='docker stop $(docker ps -a -q)'

alias k="kubectl"

# Work stuff
alias push_code='rsync -zaP --exclude="__pycache__/" --exclude=".idea/" --exclude=".pytest_cache/" --exclude=".DS_STORE"'
alias stopvpn="launchctl unload /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*"
alias startvpn="launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*"
