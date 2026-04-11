{ pkgs, ... }:
{
    flake.homeModules.shell = { pkgs, ... }: {
        programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            oh-my-zsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [
                    "git"
                ];
            };

            history = {
                size = 10000;
                save = 10000;
                path = "$HOME/.zsh_history";
                ignoreAllDups = true;
            };

            shellAliases = {
                ".." = "cd ..";
                "..." = "cd ../..";
                "...." = "cd ../../..";
            };

            sessionVariables = {
                SUDO_EDITOR = "\${EDITOR}";
                BAT_THEME = "ansi";
            };

            initContent = ''
                if command -v mise >/dev/null 2>&1; then
                    eval "$(mise activate zsh)"
                fi

                if command -v zoxide >/dev/null 2>&1; then
                    eval "$(zoxide init zsh)"
                fi

                if command -v try >/dev/null 2>&1; then
                    eval "$(try init ~/Work/tries)"
                fi

                source <(fzf --zsh)

                if command -v eza >/dev/null 2>&1; then
                    alias ls='eza -lh --group-directories-first --icons=auto'
                    alias lsa='ls -a'
                    alias lt='eza --tree --level=2 --long --icons --git'
                    alias lta='lt -a'
                fi

                alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

                if command -v zoxide >/dev/null 2>&1; then
                    alias cd="zd"
                    zd() {
                        if [ $# -eq 0 ]; then
                            builtin cd ~ && return
                        elif [ -d "$1" ]; then
                            builtin cd "$1"
                        else
                            z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
                        fi
                    }
                fi

                open() {
                    xdg-open "$@" >/dev/null 2>&1 &
                }

                iso2sd() {
                    if [ $# -ne 2 ]; then
                        echo "Usage: iso2sd <input_file> <output_device>"
                        echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
                        echo
                        echo "Available SD cards:"
                        lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
                    else
                        sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
                        sudo eject "$2"
                    fi
                }

                format-drive() {
                    if [ $# -ne 2 ]; then
                        echo "Usage: format-drive <device> <name>"
                        echo "Example: format-drive /dev/sda 'My Stuff'"
                        echo
                        echo "Available drives:"
                        lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
                    else
                        echo "WARNING: This will completely erase all data on $1 and label it '$2'."
                        read "confirm?Are you sure you want to continue? (y/N): "

                        if [[ "$confirm" =~ ^[Yy]$ ]]; then
                            sudo wipefs -a "$1"
                            sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
                            sudo parted -s "$1" mklabel gpt
                            sudo parted -s "$1" mkpart primary 1MiB 100%

                            partition="$([[ $1 == *nvme* ]] && echo "''${1}p1" || echo "''${1}1")"
                            sudo partprobe "$1" || true
                            sudo udevadm settle || true

                            sudo mkfs.exfat -n "$2" "$partition"

                            echo "Drive $1 formatted as exFAT and labeled '$2'."
                        else
                            echo "Aborted."
                        fi
                    fi
                }
            '';
        };

        home.packages = with pkgs; [
            eza
            bat
            fzf
            zoxide
            yazi
            ripgrep
curl
wget
        ];
    };
}
