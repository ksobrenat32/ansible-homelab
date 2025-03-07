#!/bin/bash

# Infinite loop to test disk health

while true; do
  # Get a random block number
  total_blocks=$(blockdev --getsz /dev/sda)
  block=$(shuf -i 0-$total_blocks -n 1)

  # Read the block
  dd if=/dev/sda of=/dev/null bs=512 count=1 skip=$block &> /dev/null

  # If the read fails, reboot the system
  if [[ $? -ne 0 ]]; then
    echo "Block $block read failed. Rebooting system."
    reboot
  fi

  # Sleep for a minute before testing again
  sleep 60
done
