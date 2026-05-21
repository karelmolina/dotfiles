alias rzsh="source ~/.zshrc"
alias lg="lazygit"
alias v="nvim"
alias pv="theme=rose-pine project=power nvim"
alias fz="project=fz nvim"
alias onion="project=onion_ nvim"
alias nv="nvim -u ~/dotfiles-mini/nvim/init.lua"
alias cd="z"
alias vpnls="openvpn3 sessions-list"
alias vpnstatus="openvpn3 session-manage --status"
alias vpnstop="openvpn3 session-manage --disconnect"

# fill with ssh keys names
export SSH_POWER=""
export SSH_TVUP=""

# ───────────────────────────────────────────────
# Git aliases (inspired by oh-my-bash git plugin)
# ───────────────────────────────────────────────

# Helper functions
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2>/dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return
  fi
  echo "${ref#refs/heads/}"
}

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return
    fi
  done
  echo master
}

function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/"$branch"; then
      echo "$branch"
      return
    fi
  done
  echo develop
}

# Base
alias g='git'

# Add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# Branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbnm='git branch --no-merged'
alias ggsup='git branch --set-upstream-to="origin/$(git_current_branch)"'

# Checkout / Switch
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcd='git checkout "$(git_develop_branch)"'
alias gcm='git checkout "$(git_main_branch)"'
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch "$(git_develop_branch)"'
alias gswm='git switch "$(git_main_branch)"'

# Commit
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcam='git commit --all --message'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcmsg='git commit --message'
alias gcsm='git commit --signoff --message'

# Diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# Fetch
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

# Log
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'

# Merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge "origin/$(git_main_branch)"'

# Pull
alias gl='git pull'
alias gpr='git pull --rebase'
alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'
alias gupom='git pull --rebase origin "$(git_main_branch)"'

# Push
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpsup='git push --set-upstream origin "$(git_current_branch)"'
alias gpv='git push --verbose'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase "$(git_develop_branch)"'
alias grbi='git rebase --interactive'
alias grbm='git rebase "$(git_main_branch)"'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grv='git remote --verbose'

# Reset
alias grh='git reset'
alias grhh='git reset --hard'
alias grhs='git reset --soft'
alias groh='git reset "origin/$(git_current_branch)" --hard'

# Restore
alias grs='git restore'
alias grst='git restore --staged'

# Rm
alias grm='git rm'
alias grmc='git rm --cached'

# Show
alias gsh='git show'

# Stash
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show'
alias gstu='git stash --include-untracked'

# Status
alias gst='git status'
alias gsb='git status --short --branch'
alias gss='git status --short'

# Submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# Clone
alias gcl='git clone --recursive'

# Tag
alias gta='git tag --annotate'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'

# Misc
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gfg='git ls-files | grep'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

