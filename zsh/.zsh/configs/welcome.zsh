# Reminder banner on every interactive shell + `?` for the full cheatsheet.

[[ -o interactive ]] || return

_cheats_fn() {
  local b d c r
  b=$'\e[1m'
  d=$'\e[2m'
  c=$'\e[36m'
  r=$'\e[0m'

  cat <<EOF

${b}Custom scripts${r}    ${d}(in ~/.bin)${r}
  ${c}dev${r}                  open tmux: nvim + claude side-by-side
  ${c}toggle-theme${r}         switch iTerm2/tmux/nvim dark↔light (light|dark)
  ${c}pdf_compress${r}         shrink a PDF via ghostscript (-f file -L|-H)
  ${c}load-ssh-keys${r}        ssh-add every id_rsa under ~/.ssh
  ${c}backup_system${r}        rsync system backup
  ${c}start-or-switch-to${r}   focus app if running, else launch (Linux)

${b}Functions${r}
  ${c}extract${r} <file>       universal archive extractor
  ${c}g${r} [args]             git status (no args) or git <args>
  ${c}version_bump${r} <bump>  poetry version + commit + tag (alias: vb)

${b}Notable aliases${r}
  ${c}please${r}               sudo the previous command
  ${c}path${r}                 \$PATH, one entry per line
  ${c}k${r} / ${c}d${r}                kubectl / docker
  ${c}vim${r}                  → nvim
  ${c}ls${r} / ${c}tree${r}             → eza / eza --tree --long

EOF
}

alias '?'='_cheats_fn'

print $'\e[2m ✦  dev · toggle-theme · extract · g · version_bump\e[0m'
print $'\e[2m    pdf_compress · load-ssh-keys · backup_system · start-or-switch-to    (? for details)\e[0m'
