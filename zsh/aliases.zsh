alias rzsh="source ~/.zshrc"
alias front="~/workspace/fzSports/FRONT"
alias lambda="~/workspace/fzSports/LAMBDA"
alias npms="~/workspace/fzSports/NPMS"
alias bots="~/workspace/fzSports/BOTS"
alias services="~/workspace/fzSports/SERVICES"
alias ls="eza -l --icons -a --no-user"
alias v="nvim"
alias tv="tvup=true nvim"

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
