# Set atuin as history search (if available)
(( $+functions[atuin-search] )) && bindkey '^r' atuin-search
bindkey '^[[3;9~' vi-beginning-of-line
bindkey '^[[5;9~' vi-end-of-line

# zsh autocomplete
bindkey '^[[1;2C' forward-word
bindkey '^[[1;2D' backward-kill-word

# Vi mode settings
bindkey -v '^?' backward-delete-char  # Backspace deletes any character
bindkey -v '^H' backward-delete-char  # Ctrl+H also deletes

# Vi mode cursor shape
# Block cursor for normal mode, beam cursor for insert mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[2 q'  # Block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[6 q'  # Beam cursor
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[6 q'  # Start with beam cursor
}
zle -N zle-line-init