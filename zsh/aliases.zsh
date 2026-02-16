alias rzsh="source ~/.zshrc"
alias ls="eza -l --icons -a --no-user"
alias v="nvim"
alias pv="theme=rose-pine project=power nvim"
alias fz="project=fz nvim"
alias nv="nvim -u ~/dotfiles-mini/nvim/init.lua"
alias cd="z"

# fill with ssh keys names
export SSH_POWER=""
export SSH_TVUP=""

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

function power() {
  export GIT_SSH_COMMAND='ssh -i ~/.ssh/$SSH_POWER  -o IdentitiesOnly=yes'
  echo "Using SSH key ~/.ssh/$SSH_POWER"
}

function tvup() {
  export GIT_SSH_COMMAND='ssh -T -i ~/.ssh/$SSH_TVUP -F ~/.ssh/tvup-config/config -o IdentitiesOnly=yes'
  echo "Using SSH key ~/.ssh/$SSH_TVUP"
}
