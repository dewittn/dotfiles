# 1Password shell plugin aliases (manually managed to avoid gh plugin auth on shell start)
alias linode-cli="op plugin run -- linode-cli"

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
