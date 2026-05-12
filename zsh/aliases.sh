#!/bin/bash

# git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
alias gap='git add --patch'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbl='git blame -b -w'

alias gcb='git checkout -b'
alias gco='git checkout'
alias gcd='git checkout develop'
alias gcm='git checkout main'

alias gcl='git clone --recursive'
alias gclean='git clean -fd'

alias gc='git commit'
alias gca='git commit --all'
alias gcam='git commit --all --message'
alias gc!='git commit --verbose --amend'
alias gca!='git commit --verbose --all --amend'

alias gcf='git config --list'

alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream'

alias gm='git merge'
alias gr='git rebase'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'

alias gr='git remote'
alias gra='git remote add'
alias grv='git remote --verbose'

alias grh='git reset'
alias grhh='git reset --hard'
alias gru='git reset --'

alias grev='git revert'
alias grm='git rm'
alias grmc='git rm --cached'

alias gsh='git show'
alias gst='git stash'
alias gsta='git stash save'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstl='git stash list'

alias gs='git status'
alias gsb='git status --short --branch'
alias gss='git status --short'

alias gsw='git switch'
alias gswc='git switch --create'

alias gta='git tag'
alias gtv='git tag | sort -V'

alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%h - %s %ad"'
alias glg='git log --stat'
alias glgg='git log --graph'

alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gfg='git ls-files | grep'