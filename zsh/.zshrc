setopt autocd extendedglob nomatch

# see https://github.com/sindresorhus/pure for more information
fpath=(~/.zsh/zsh_pure_prompt $fpath)

for cfg in ~/.zsh/configs/*.zsh; do
  source $cfg
done

for function in ~/.zsh/functions/[^\.]*; do
  source $function
done

export SSH_AUTH_SOCK="/tmp/ssh-agent.socket"

[[ -f ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                    # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -d ~/.local/android/sdk ]]; then
  # android & react native
  export ANDROID_SDK=$HOME/.local/android/sdk/
  export ANDROID_HOME=$HOME/.local/android/sdk/
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/sam/.local/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/sam/.local/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#        source "/home/sam/.local/opt/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/sam/.local/opt/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<
source "/home/sam/.local/opt/miniconda3/etc/profile.d/conda.sh"

#
# merantix
#

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/sam/.local/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/home/sam/.local/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/sam/.local/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/sam/.local/opt/google-cloud-sdk/completion.zsh.inc'; fi

if [ -f '/home/sam/.mx-complete.sh' ]; then
  . /home/sam/.mx-complete.sh
else
  echo "could not find mx-complete"
fi

# merantix core setup
if [ -f $HOME/proj/merantix/core/developer_env/setup.sh ]; then
  . $HOME/proj/merantix/core/developer_env/setup.sh AUTOSEC
else
  echo "could not find merantix core setup"
fi
