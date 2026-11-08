. "$HOME/.cargo/env"
export PATH=$HOME/.local/bin:$PATH

source $HOME/.local/bin/done_pa_completions.bash

command -v agentkit >/dev/null && eval "$(agentkit completion)"
