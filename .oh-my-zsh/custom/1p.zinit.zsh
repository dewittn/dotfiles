# Source 1Password shell plugins (linode-cli, etc.)
if [ -f ~/.config/op/plugins.sh ]; then
  source ~/.config/op/plugins.sh
fi

# Override the gh plugin alias with a lazy-loading function.
# Fetches the token from 1Password on first use (one biometric prompt),
# then caches it in GH_TOKEN for the rest of the session.
unalias gh 2>/dev/null
gh() {
  if [[ -z "$GH_TOKEN" ]]; then
    export GH_TOKEN="$(op read 'op://Coto.Studio/Github/PAT')"
  fi
  command gh "$@"
}
