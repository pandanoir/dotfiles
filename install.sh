#!/bin/bash
# curl -sL dot.pandanoir.net | sh
set -eu

command_exists() { type "$1" >/dev/null 2>&1; }
dir_exists() { [ -d $1 ]; }
info() { echo -e "\033[0;34m[INFO]\033[0;39m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0;39m $1"; }

DOTDIR="$HOME/dotfiles"

if ! command_exists git; then
  warn "you must install git!"
  exit 1
fi
if ! dir_exists "$DOTDIR"; then
  info "download dotfiles"
  git clone https://github.com/pandanoir/dotfiles "$DOTDIR"
fi

source "$DOTDIR/scripts/check_requirements.sh"
source "$DOTDIR/scripts/deploy.sh"
source "$DOTDIR/scripts/init_config.sh"

check_requirements

if [ $# -eq 0 ]; then
  deploy
  init_config
elif [ "$1" = "deploy" ] || [ "$1" = "-d" ]; then
  deploy
elif [ "$1" = "init" ] || [ "$1" = "-i" ]; then
  init_config
fi
