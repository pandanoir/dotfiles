#!/bin/bash
# Thanks, @kaorimatz!

# curl -sL dot.pandanoir.net | sh

set -eu

ARG1="$([ $# -eq 1 ] && echo "$1" || echo "")"
has() { type "$1" > /dev/null 2>&1; }
file_exists() { [ -f $1 ]; }
dir_exists() { [ -d $1 ]; }
is_update_mode() { [ "$ARG1" = "update" ] || [ "$ARG1" = "-u" ]; }
info() { echo -e "\033[0;34m[INFO]\033[0;39m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0;39m $1"; }

DOTDIR="$HOME/dotfiles"
[ "${XDG_CONFIG_HOME:+defined}" ] || XDG_CONFIG_HOME="$HOME/.config"
[ "${XDG_CACHE_HOME:+defined}" ] || XDG_CACHE_HOME="$HOME/.cache"
[ "${XDG_DATA_HOME:+defined}" ] || XDG_DATA_HOME="$HOME/.local/share"
[ "${ZDOTDIR:+defined}" ] || ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if ! has git; then
  warn "you must install git!"
  exit 1
fi
if ! dir_exists "$DOTDIR"; then
  info "download dotfiles"
  git clone https://github.com/pandanoir/dotfiles "$DOTDIR"
fi

source "$DOTDIR/scripts/check_requirements.sh"
source "$DOTDIR/scripts/deploy.sh"
source "$DOTDIR/scripts/init.sh"

check_requirements

if [ $# -eq 0 ]; then
  deploy
  init
elif [ "$1" = "deploy" ] || [ "$1" = "-d" ]; then
  deploy
elif [ "$1" = "init" ] || [ "$1" = "-i" ]; then
  init
fi
