source /usr/share/cachyos-fish-config/cachyos-config.fish

set -Ux EDITOR nvim
zoxide init fish | source

alias drun='docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/pwd'
alias comfyui='fish ~/.config/scripts/comfyui.sh'

function cd
    z $argv
    ls
end

