#!/bin/bash
# curl -sL dot.pandanoir.net | sh
set -eu
info() { echo -e "\033[0;34m[INFO]\033[0;39m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0;39m $1"; }
DOTDIR="$HOME/dotfiles"

if ! type git >/dev/null 2>&1; then
  warn "you must install git!"; exit 1
fi
if ! [ -d "$DOTDIR" ]; then
  info "download dotfiles"
  git clone https://github.com/pandanoir/dotfiles "$DOTDIR"
fi

source "$DOTDIR/_scripts/check_requirements.sh"
source "$DOTDIR/_scripts/install_tools.sh"
source "$DOTDIR/_scripts/deploy_files.sh"
source "$DOTDIR/_scripts/init_config.sh"

install_tools
check_requirements

if [ $# -eq 0 ] || [ "$1" = "deploy" ] || [ "$1" = "-d" ]; then
  deploy
fi
if [ $# -eq 0 ] || [ "$1" = "init" ] || [ "$1" = "-i" ]; then
  init_config
fi
