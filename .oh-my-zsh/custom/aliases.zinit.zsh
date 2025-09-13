#alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles='bunch Dotfiles'
alias aliased='vim $HOME/.oh-my-zsh/custom/aliases.zsh'
alias l='eza --icons --git'
alias la='eza -lah --icons --git'
alias lt='eza --tree --level=2 --icons --git'
alias z='zellia a'
alias gt='gittower ./'
alias reload='source ~/.zshrc'
alias asr='atuin scripts run'
alias k='kubectl'

dbmp () {
  atuin scripts run docker-mpb -v tag=$1 -v fileName=$2
}

function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}

_gitignoreio_get_command_list() {
  curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi

export EDITOR="nvim"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
