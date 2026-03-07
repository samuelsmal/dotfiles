# Configuration of completions in zsh

autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit
# Auto-correction of typed commands
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
setopt correctall
