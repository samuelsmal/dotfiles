#!/bin/sh
# Aggregate Claude Code status across all running agents for tmux
user=$(whoami)
files=$(ls /tmp/claude-code-status-${user}-* 2>/dev/null)
[ -z "$files" ] && exit 0

# Clean up stale files (older than 2 minutes) and collect active ones
active=""
now=$(date +%s)
for f in $files; do
  mtime=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null)
  if [ -n "$mtime" ] && [ $((now - mtime)) -gt 120 ]; then
    rm -f "$f"
  else
    active="${active:+$active
}$(cat "$f")"
  fi
done

[ -z "$active" ] && exit 0

count=$(echo "$active" | wc -l | tr -d ' ')
if [ "$count" -eq 1 ]; then
  printf '%s' "$active"
else
  # Sum tokens across agents, show agent count
  total_tok_in=0
  total_tok_out=0
  while IFS= read -r line; do
    tok=$(echo "$line" | grep -o 'tok:[^ ]*' | sed 's/tok://')
    if [ -n "$tok" ]; then
      raw_in=$(echo "$tok" | cut -d/ -f1 | awk '{ if (index($1,"M")) { gsub("M","",$1); printf "%.0f",$1*1000000 } else if (index($1,"k")) { gsub("k","",$1); printf "%.0f",$1*1000 } else print $1 }')
      raw_out=$(echo "$tok" | cut -d/ -f2 | awk '{ if (index($1,"M")) { gsub("M","",$1); printf "%.0f",$1*1000000 } else if (index($1,"k")) { gsub("k","",$1); printf "%.0f",$1*1000 } else print $1 }')
      total_tok_in=$((total_tok_in + raw_in))
      total_tok_out=$((total_tok_out + raw_out))
    fi
  done <<EOF
$active
EOF
  fmt_in=$(awk "BEGIN { v=$total_tok_in; if (v>=1000000) printf \"%.1fM\",v/1000000; else if (v>=1000) printf \"%.1fk\",v/1000; else printf \"%d\",v }")
  fmt_out=$(awk "BEGIN { v=$total_tok_out; if (v>=1000000) printf \"%.1fM\",v/1000000; else if (v>=1000) printf \"%.1fk\",v/1000; else printf \"%d\",v }")
  printf '%s agents │ tok:%s/%s' "$count" "$fmt_in" "$fmt_out"
fi
