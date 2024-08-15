source /usr/share/cachyos-fish-config/cachyos-config.fish
source ~/.config/fish/aliases.fish

set -Ux EDITOR nvim
zoxide init fish | source

function cd
    z $argv
    ls
end

