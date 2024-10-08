#alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles='bunch Dotfiles'
alias aliased='vim $HOME/.oh-my-zsh/custom/aliases.zsh'
alias l='eza --icons --git'
alias la='eza -lah --icons --git'
alias lt='eza --tree --level=2 --icons --git'
alias z='zellia a'
alias gt='gittower ./'
alias reload='source ~/.zshrc'

function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}

_gitignoreio_get_command_list() {
  curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi