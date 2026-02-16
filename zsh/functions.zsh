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
  local sessions_output
  sessions_output=$(openvpn3 sessions-list 2>/dev/null)

  if [[ -z "$sessions_output" ]] || [[ "$sessions_output" == *"No sessions"* ]]; then
    echo "No active VPN sessions"
    return 1
  fi

  # Parse session paths and config names from text output
  local session_paths=($(echo "$sessions_output" | grep "^\s*Path:" | awk '{print $2}'))
  local session_configs=($(echo "$sessions_output" | grep "Config name:" | awk '{print $3}'))

  if [[ ${#session_paths[@]} -eq 0 ]]; then
    echo "No active VPN sessions found"
    return 1
  fi

  echo "Select session to disconnect:"
  local options=()
  for i in {1..${#session_paths[@]}}; do
    local idx=$((i))
    options+=("${session_configs[$idx]:-unknown} (${session_paths[$idx]})")
  done

  local selected
  select selected in "${options[@]}"; do
    [[ -n "$selected" ]] && break
  done

  local idx=$REPLY
  openvpn3 session-manage --session-path "${session_paths[$idx]}" --disconnect
}

function vpnlogs() {
  local sessions_output
  sessions_output=$(openvpn3 sessions-list 2>/dev/null)

  if [[ -z "$sessions_output" ]] || [[ "$sessions_output" == *"No sessions"* ]]; then
    echo "No active VPN sessions"
    return 1
  fi

  # Parse session paths and config names from text output
  local session_paths=($(echo "$sessions_output" | grep "^\s*Path:" | awk '{print $2}'))
  local session_configs=($(echo "$sessions_output" | grep "Config name:" | awk '{print $3}'))

  if [[ ${#session_paths[@]} -eq 0 ]]; then
    echo "No active VPN sessions found"
    return 1
  fi

  echo "Select session to view logs:"
  local options=()
  for i in {1..${#session_paths[@]}}; do
    local idx=$((i))
    options+=("${session_configs[$idx]:-unknown}")
  done

  local selected
  select selected in "${options[@]}"; do
    [[ -n "$selected" ]] && break
  done

  local idx=$REPLY
  openvpn3 log --session-path "${session_paths[$idx]}"
}
