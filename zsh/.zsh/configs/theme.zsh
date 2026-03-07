# Apply saved theme to new terminal tabs/windows
if [[ "$TERM_PROGRAM" == "iTerm.app" && -f "$HOME/.theme-mode" ]]; then
  local mode=$(<"$HOME/.theme-mode")
  local profile="Solarized Dark"
  [[ "$mode" == "light" ]] && profile="Solarized Light"
  printf '\e]1337;SetProfile=%s\a' "$profile"
fi
