# Make sure oh-my-posh path is loaded
if [ -d $HOME/.local/bin ]; then
  export PATH=$PATH:$HOME/.local/bin
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Cache directory for generated scripts
ZINIT_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/zinit"
mkdir -p "$ZINIT_CACHE"

# ===== Turbo-loaded plugins (deferred) =====
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Atuin sync server - use localhost for rcoto, tailscale for others
if [[ "$USER" == "rcoto" ]]; then
  export ATUIN_SYNC_ADDRESS="http://localhost:8888"
fi

zinit ice wait lucid
zinit load atuinsh/atuin

# ===== Snippets (turbo-loaded) =====
zinit ice wait lucid
zinit snippet OMZP::ansible

zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::gitignore

zinit ice wait lucid
zinit snippet OMZP::command-not-found

zinit ice wait lucid
zinit snippet OMZP::sudo

# ===== Native completions (turbo-loaded, skip if not installed) =====
# gh completion (generated directly from gh cli)
zinit ice lucid wait has"gh" as"completion" id-as"gh-completion" \
  atclone"gh completion -s zsh > _gh" atpull"%atclone"
zinit light zdharma-continuum/null

zinit ice lucid wait has"docker" as"completion"
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

# ===== Cached compinit (rebuild once per day) =====
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C  # skip security check for faster load
fi

zinit cdreplay -q

# ===== Cached eval commands (avoid subprocess on every shell) =====
# oh-my-posh (skip if not installed)
if command -v oh-my-posh &> /dev/null; then
  if [[ ! -f "$ZINIT_CACHE/oh-my-posh.zsh" ]] || [[ "$HOME/.config/ohmyposh/nr.yaml" -nt "$ZINIT_CACHE/oh-my-posh.zsh" ]]; then
    oh-my-posh init zsh --config "$HOME/.config/ohmyposh/nr.yaml" > "$ZINIT_CACHE/oh-my-posh.zsh"
  fi
  source "$ZINIT_CACHE/oh-my-posh.zsh"
fi

# fzf (skip if not installed)
if command -v fzf &> /dev/null; then
  if [[ ! -f "$ZINIT_CACHE/fzf.zsh" ]]; then
    fzf --zsh > "$ZINIT_CACHE/fzf.zsh"
  fi
  source "$ZINIT_CACHE/fzf.zsh"
fi

# zoxide (skip if not installed)
if command -v zoxide &> /dev/null; then
  if [[ ! -f "$ZINIT_CACHE/zoxide.zsh" ]]; then
    zoxide init --cmd cd zsh > "$ZINIT_CACHE/zoxide.zsh"
  fi
  source "$ZINIT_CACHE/zoxide.zsh"
fi

# ===== Source custom configs =====
for file in ~/.oh-my-zsh/custom/*.zinit.zsh; do
  source "$file"
done
