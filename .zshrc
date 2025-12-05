# Make sure oh-my-posh path is loaded
if [ -d $HOME/.local/bin ]
then
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

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit load atuinsh/atuin

# Add in snippets
zinit snippet OMZP::ansible
zinit snippet OMZP::docker-compose
# Only load gh plugin if gh is installed
if command -v gh &> /dev/null; then
  zinit snippet OMZP::gh
fi
zinit snippet OMZP::git
zinit snippet OMZP::gitignore
zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Load oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/nr.yaml)"

# Load fzf
source <(fzf --zsh)

# Load zoxide
eval "$(zoxide init --cmd cd zsh)"

# Source oh-my-zsh custom confs
for file in ~/.oh-my-zsh/custom/*.zinit.zsh; do
    source "$file"
done
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/dewittn/.lmstudio/bin"
# End of LM Studio CLI section

