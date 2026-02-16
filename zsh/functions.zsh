# yazi
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

# OpenVPN3
function vpnup() {
  local config="$1"
  local vpn_dir="$HOME/workspace"

  if [[ -z "$config" ]]; then
    local configs=($vpn_dir/*.ovpn(N))

    if [[ ${#configs[@]} -eq 0 ]]; then
      echo "No .ovpn files found in $vpn_dir"
      return 1
    fi

    echo "Select VPN config:"
    select config in "${configs[@]}"; do
      [[ -n "$config" ]] && break
    done
  fi

  openvpn3 session-start --config "$config"
}

function vpndown() {
  local sessions_json
  sessions_json=$(openvpn3 sessions-list --json 2>/dev/null)

  if [[ -z "$sessions_json" ]] || [[ "$sessions_json" == "[]" ]]; then
    echo "No active VPN sessions"
    return 1
  fi

  local session_paths=($(echo "$sessions_json" | jq -r '.[].path'))
  local session_configs=($(echo "$sessions_json" | jq -r '.[].config_name'))

  echo "Select session to disconnect:"
  local options=()
  for i in {1..${#session_paths[@]}}; do
    options+=("${session_configs[$i]} (${session_paths[$i]})")
  done

  local selected
  select selected in "${options[@]}"; do
    [[ -n "$selected" ]] && break
  done

  local idx=$REPLY
  openvpn3 session-manage --session-path "${session_paths[$idx]}" --disconnect
}

function vpnlogs() {
  local sessions_json
  sessions_json=$(openvpn3 sessions-list --json 2>/dev/null)

  if [[ -z "$sessions_json" ]] || [[ "$sessions_json" == "[]" ]]; then
    echo "No active VPN sessions"
    return 1
  fi

  local session_paths=($(echo "$sessions_json" | jq -r '.[].path'))
  local session_configs=($(echo "$sessions_json" | jq -r '.[].config_name'))

  echo "Select session to view logs:"
  local options=()
  for i in {1..${#session_paths[@]}}; do
    options+=("${session_configs[$i]}")
  done

  local selected
  select selected in "${options[@]}"; do
    [[ -n "$selected" ]] && break
  done

  local idx=$REPLY
  openvpn3 log --session-path "${session_paths[$idx]}"
}
