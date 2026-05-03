if file_exists /opt/homebrew/bin/brew; then
  notify "setup brew..."
  eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew関連の環境変数をセット
fi
