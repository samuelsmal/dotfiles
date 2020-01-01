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

alias asci='source activate sci'

alias todo='vim ~/Dropbox/Notes/planning/todo.txt'
alias notes='cd ~/Dropbox/Notes/ && vim'

alias ssh_alarm='ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no  pi@192.168.178.87'

alias ssh_media='ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no  pi@192.168.178.72'
