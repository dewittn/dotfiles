## Add ~/bash-scripts to $PATH
[[ -d $HOME/bash-scripts/ ]] && export PATH=$HOME/bash-scripts/:$PATH

## Add homebrew to $PATH (cached to avoid eval on every shell)
## Works on macOS only - skipped on Linux
if [[ -f /opt/homebrew/bin/brew ]]; then
  # M1/ARM Mac
  if [[ ! -f "$ZINIT_CACHE/homebrew.zsh" ]]; then
    /opt/homebrew/bin/brew shellenv > "$ZINIT_CACHE/homebrew.zsh"
  fi
  source "$ZINIT_CACHE/homebrew.zsh"
elif [[ -f /usr/local/bin/brew ]]; then
  # Intel Mac
  if [[ ! -f "$ZINIT_CACHE/homebrew.zsh" ]]; then
    /usr/local/bin/brew shellenv > "$ZINIT_CACHE/homebrew.zsh"
  fi
  source "$ZINIT_CACHE/homebrew.zsh"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  # Linuxbrew
  if [[ ! -f "$ZINIT_CACHE/homebrew.zsh" ]]; then
    /home/linuxbrew/.linuxbrew/bin/brew shellenv > "$ZINIT_CACHE/homebrew.zsh"
  fi
  source "$ZINIT_CACHE/homebrew.zsh"
fi

## Add homebrew node@18 to $PATH (only if HOMEBREW_PREFIX is set)
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/node@18/" ]]; then
  export PATH="$PATH:$HOMEBREW_PREFIX/opt/node@18/bin"
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/node@18/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/node@18/include"
fi

## Add go binaries
[[ -d $HOME/go/bin ]] && export PATH="$PATH:$HOME/go/bin"

## LM Studio CLI (macOS only typically)
[[ -d $HOME/.lmstudio/bin ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

## Ollama models path (macOS external drive)
[[ -d /Volumes/Extended/ollama ]] && export OLLAMA_MODELS="/Volumes/Extended/ollama"

## Ruby - check both macOS homebrew and system locations
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]]; then
  export PATH="$PATH:$HOMEBREW_PREFIX/opt/ruby/bin"
fi

## pnpm - check both macOS and Linux locations
if [[ -d $HOME/Library/pnpm ]]; then
  # macOS
  export PNPM_HOME="$HOME/Library/pnpm"
  [[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"
elif [[ -d $HOME/.local/share/pnpm ]]; then
  # Linux (XDG standard)
  export PNPM_HOME="$HOME/.local/share/pnpm"
  [[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"
fi

## Cargo/Rust
[[ -f $HOME/.cargo/env ]] && source "$HOME/.cargo/env"

## Local bin (common on Linux)
[[ -d $HOME/.local/bin ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"
