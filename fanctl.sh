#!/usr/bin/env bash
# fanctl - simple Linux fan control via /sys/class/hwmon
#
# Usage:
#   sudo ./fanctl.sh list                       # list available fan controls
#   sudo ./fanctl.sh set <hwmon> <pwmN> <pct>   # set fan to percentage (0-100)
#   sudo ./fanctl.sh auto <hwmon> <pwmN>        # restore automatic control
#   sudo ./fanctl.sh max <hwmon> <pwmN>         # set fan to 100%

set -euo pipefail

HWMON_BASE="/sys/class/hwmon"

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: this script must be run as root (use sudo)." >&2
        exit 1
    fi
}

list_fans() {
    echo "Scanning $HWMON_BASE for PWM fan controls..."
    echo
    local found=0
    for hwmon in "$HWMON_BASE"/hwmon*; do
        [[ -d "$hwmon" ]] || continue
        local name="unknown"
        [[ -f "$hwmon/name" ]] && name=$(cat "$hwmon/name")
        local header_printed=0
        for pwm in "$hwmon"/pwm[0-9]*; do
            # only match pwm1, pwm2, ... (skip pwm1_enable, pwm1_mode, etc.)
            [[ "$pwm" =~ /pwm[0-9]+$ ]] || continue
            [[ -f "$pwm" ]] || continue

            if [[ $header_printed -eq 0 ]]; then
                echo "[$(basename "$hwmon")] name=$name"
                header_printed=1
                found=1
            fi

            local pwm_name pwm_val pwm_pct enable_file enable_val fan_num fan_input rpm
            pwm_name=$(basename "$pwm")
            pwm_val=$(cat "$pwm" 2>/dev/null || echo 0)
            pwm_pct=$(( pwm_val * 100 / 255 ))
            enable_file="${pwm}_enable"
            enable_val="?"
            [[ -f "$enable_file" ]] && enable_val=$(cat "$enable_file")

            fan_num=${pwm_name#pwm}
            fan_input="$hwmon/fan${fan_num}_input"
            rpm="N/A"
            [[ -f "$fan_input" ]] && rpm=$(cat "$fan_input")

            printf "  %-6s value=%3d (~%3d%%)  enable=%s  rpm=%s\n" \
                "$pwm_name" "$pwm_val" "$pwm_pct" "$enable_val" "$rpm"
        done
    done
    if [[ $found -eq 0 ]]; then
        echo "No PWM fan controls found."
        echo "Install lm-sensors and run 'sudo sensors-detect' first."
        exit 1
    fi
    echo
    echo "enable values: 0=no control(full), 1=manual, 2=auto(BIOS), 5=auto(some chips)"
}

set_fan() {
    local hwmon="$1" pwm="$2" pct="$3"

    if ! [[ "$pct" =~ ^[0-9]+$ ]] || (( pct < 0 || pct > 100 )); then
        echo "Error: percentage must be an integer 0-100" >&2
        exit 1
    fi

    local pwm_path="$HWMON_BASE/$hwmon/$pwm"
    local enable_path="${pwm_path}_enable"

    if [[ ! -f "$pwm_path" ]]; then
        echo "Error: $pwm_path not found" >&2
        exit 1
    fi

    local value=$(( pct * 255 / 100 ))

    # switch to manual control mode
    if [[ -f "$enable_path" ]]; then
        echo 1 > "$enable_path"
    fi

    echo "$value" > "$pwm_path"
    echo "Set $hwmon/$pwm to ${pct}% (raw ${value}/255)"

    # show resulting RPM after a short pause for the fan to spin up/down
    sleep 2
    local fan_num="${pwm#pwm}"
    local fan_input="$HWMON_BASE/$hwmon/fan${fan_num}_input"
    if [[ -f "$fan_input" ]]; then
        echo "Current RPM: $(cat "$fan_input")"
    fi
}

auto_fan() {
    local hwmon="$1" pwm="$2"
    local enable_path="$HWMON_BASE/$hwmon/${pwm}_enable"

    if [[ ! -f "$enable_path" ]]; then
        echo "Error: $enable_path not found" >&2
        exit 1
    fi

    # try mode 2 first (most common auto mode), fall back to 5
    if ! echo 2 > "$enable_path" 2>/dev/null; then
        echo 5 > "$enable_path"
    fi
    echo "Restored automatic control on $hwmon/$pwm"
}

usage() {
    cat <<EOF
fanctl - simple Linux fan control

Usage:
  sudo $0 list
      List all PWM controls and their current state.

  sudo $0 set <hwmon> <pwm> <percent>
      Set a fan to a fixed percentage (0-100).
      Example: sudo $0 set hwmon3 pwm1 50

  sudo $0 auto <hwmon> <pwm>
      Restore automatic (BIOS) control of a fan.

  sudo $0 max <hwmon> <pwm>
      Set a fan to 100%.

Notes:
  - Settings do NOT persist across reboot. Re-run on boot or wrap in a systemd unit.
  - Requires lm-sensors (run 'sudo sensors-detect' once first).
  - Many laptops have a locked EC and will ignore writes.
  - Setting a fan to 0% can stop it entirely - watch your temps.
EOF
}

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        list)
            require_root; list_fans ;;
        set)
            require_root
            [[ $# -eq 4 ]] || { usage; exit 1; }
            set_fan "$2" "$3" "$4" ;;
        auto)
            require_root
            [[ $# -eq 3 ]] || { usage; exit 1; }
            auto_fan "$2" "$3" ;;
        max)
            require_root
            [[ $# -eq 3 ]] || { usage; exit 1; }
            set_fan "$2" "$3" 100 ;;
        help|-h|--help|*)
            usage ;;
    esac
}

main "$@"
