notify "setup ripgrep..."
if command_exists rg; then
  export RIPGREP_CONFIG_PATH="$HOME/dotfiles/ripgreprc"
fi
