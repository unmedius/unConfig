#!/bin/bash

# Check that the folder containing the script is named after your VM. 
VM_NAME=$(basename "$(dirname "$0")")

virsh --connect qemu:///system start $VM_NAME

VM_STATUS=$(virsh --connect qemu:///system dominfo $VM_NAME | grep "State" | awk '{print $2}')

if [ "$VM_STATUS" == "running" ]; then
    notify-send "VM $VM_NAME started." "Cheching RDP..." --urgency=normal
    
    while true; do   
        if nc -z 192.168.122.202 3389; then
            notify-send "RDP avalible. Windows 11 started." "Connecting with Remmina..." --urgency=normal
            sleep 1
            remmina -c ~/.local/share/remmina/group_rdp_unwinvm_192-168-122-202.remmina
            break
        else
            notify-send "RDP or Win11 not started." "Waiting..." --urgency=low
        fi
    done
else
    notify-send "VM $VM_NAME not started." "Something went wrong." --urgency=critical
fi

