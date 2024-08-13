#!/bin/bash

# Check that the folder containing the script is named after your VM. 
VM_NAME=$(basename "$(dirname "$0")")


virsh --connect qemu:///system destroy "$VM_NAME"
notify-send "Connection closed." "VM $VM_NAME was turned off."
pkill -f "remmina"
