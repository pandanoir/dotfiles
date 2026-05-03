source "$ZDOTDIR/utils.zsh"
for f in "$ZDOTDIR/profile.d"/*.zsh; do
  source "$f"
done
notify "loaded zprofile"; echo
