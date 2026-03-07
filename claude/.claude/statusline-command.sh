input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

cur_in=$(echo "$input"   | jq -r '.context_window.current_usage.input_tokens // empty')
cur_out=$(echo "$input"  | jq -r '.context_window.current_usage.output_tokens // empty')
cur_cache_r=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')
cur_cache_w=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // empty')

total_in=$(echo "$input"  | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

home="$HOME"
short_cwd="${cwd/#$home/\~}"

branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsync=none symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.fsync=none rev-parse --short HEAD 2>/dev/null)
fi

line="$short_cwd"
[ -n "$branch" ] && line="$line  $branch"
[ -n "$model" ]  && line="$line  $model"

if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  line="$line  ctx:${used_int}%"
fi

if [ -n "$cur_in" ]; then
  line="$line  call:in=${cur_in} out=${cur_out} cr=${cur_cache_r} cw=${cur_cache_w}"
fi

if [ -n "$total_in" ]; then
  line="$line  total:in=${total_in} out=${total_out}"
fi

printf '%s\n' "$line"
