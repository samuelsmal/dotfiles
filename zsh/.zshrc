# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/SamuelvonBaussnern/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

fpath=( "$HOME/.zsh/prompt" $fpath )

autoload -U promptinit; promptinit
prompt pure

fpath+=~/.zsh/completions/_poetry

for cfg in ~/.zsh/configs/*.zsh; do
  source $cfg
done

for function in ~/.zsh/functions/[^\.]*; do
  source $function
done

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/SamuelvonBaussnern/.local/opt/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/SamuelvonBaussnern/.local/opt/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/SamuelvonBaussnern/.local/opt/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/SamuelvonBaussnern/.local/opt/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source $HOME/.local/bin/fdh_tooling_completions.bash

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.2

source $HOME/.local/bin/done_pa_completions.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/SamuelvonBaussnern/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/SamuelvonBaussnern/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/SamuelvonBaussnern/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/SamuelvonBaussnern/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/SamuelvonBaussnern/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. "$HOME/.cargo/env"
