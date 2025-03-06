#!/bin/bash
failure_count=0
max_failures=20
targets=("gnu.org" "debian.org" "gitlab.com" "github.com")

echo "$(date): Monitoring started."

while true; do
  is_down=true

  # Test each target one by one, if one is reachable, break the loop
  for target in "${targets[@]}"; do
    if ping -c 1 $target &> /dev/null; then
      is_down=false
      break
    fi
  done

  # If all targets are unreachable, reset the NIC
  if $is_down; then
    echo "$(date): NIC eno1 down. Attempting to reset."
    nmcli device disconnect eno1 && nmcli device connect eno1
    ((failure_count++))
  else
    failure_count=0
  fi

  # If NIC down for max_failures, reboot the system
  if [[ $failure_count -ge $max_failures ]]; then
    echo "$(date): NIC eno1 down for 20 minutes. Rebooting system."
    reboot
  fi

  # Sleep for a minute before testing again
  sleep 60
done
