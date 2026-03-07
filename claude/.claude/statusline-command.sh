input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input"  | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

# Format token count (1234 -> 1.2k, 1234567 -> 1.2M)
fmt_tok() {
  awk '{ if ($1>=1000000) printf "%.1fM",$1/1000000; else if ($1>=1000) printf "%.1fk",$1/1000; else printf "%d",$1 }' <<< "$1"
}

home="$HOME"
short_cwd="${cwd/#$home/\~}"

branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsync=none symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.fsync=none rev-parse --short HEAD 2>/dev/null)
fi

# Claude Code statusline (concise, this invocation only)
line="$short_cwd"
[ -n "$branch" ] && line="$line  $branch"
[ -n "$model" ]  && line="$line │ $model"
if [ -n "$used" ]; then
  line="$line │ ctx:$(printf '%.0f' "$used")%"
fi
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  line="$line │ tok:$(fmt_tok "$total_in")/$(fmt_tok "$total_out")"
fi
printf '%s\n' "$line"

# Write per-agent tmux status file (PID-keyed for multi-agent aggregation)
agent_file="/tmp/claude-code-status-$(whoami)-$PPID"
tmux_status=""
[ -n "$model" ] && tmux_status="$model"
if [ -n "$used" ]; then
  tmux_status="${tmux_status:+$tmux_status │ }ctx:$(printf '%.0f' "$used")%"
fi
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  tmux_status="${tmux_status:+$tmux_status │ }tok:$(fmt_tok "$total_in")/$(fmt_tok "$total_out")"
fi

if [ -n "$tmux_status" ]; then
  printf '%s\n' "$tmux_status" > "$agent_file"
else
  rm -f "$agent_file"
fi
