## Add ~/bash-scripts to $PATH
if [ -d $HOME/bash-scripts/ ]
then
  export PATH=$HOME/bash-scripts/:$PATH
fi

## Add homebrew to $PATH (M1)
if [ -f /opt/homebrew/bin/brew ]
then
  eval "$(/opt/homebrew/bin/brew shellenv)"
## Add homebrew to $PATH (intel)
elif [ -f /usr/local/bin/brew ]
then
  eval "$(/usr/local/bin/brew shellenv)"
fi

## Add homebrew node@18 to $PATH
if [ -d $HOMEBREW_PREFIX/opt/node@18/ ]
then
  export PATH="$PATH:$HOMEBREW_PREFIX/opt/node@18/bin"
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/node@18/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/node@18/include"
fi

## Add go binaries for tailscale
if [ -d $HOME/go/bin ]
then
  export PATH="$PATH:$HOME/go/bin"
fi

if [ -d $HOME/.lmstudio/bin ]
then
  # Added by LM Studio CLI (lms)
  export PATH="$PATH:$HOME/.lmstudio/bin"
fi

if [ -d /Volumes/Extended/ollama ]
then
  export OLLAMA_MODELS="/Volumes/Extended/ollama"
fi

if [ -d  /opt/homebrew/opt/ruby/bin ]
then
  export OLLAMA_MODELS="/opt/homebrew/opt/ruby/bin"
fi

if [ -d $HOME/Library/pnpm ]
then
  # pnpm
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
  # pnpm end
fi
