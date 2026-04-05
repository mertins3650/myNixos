# Inits
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if command -v try &> /dev/null; then
  eval "$(try init ~/Work/tries)"
fi

source <(fzf --zsh)

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS

# Aliases
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias qwenthink='llama-server \
  -hf unsloth/Qwen3.5-35B-A3B-GGUF:Q4_K_M \
  -a "Qwen" \
  -c 131072 \
  -ngl all \
  -ctk q8_0 \
  -ctv q8_0 \
  -sm none \
  -mg 0 \
  -np 1 \
  -fa on \
  --temp 0.6 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0.0 \
  --jinja \
  --host 127.0.0.1 \
  --port 8033'

alias qwendense='llama-server \
  -hf unsloth/Qwen3.5-27B-GGUF:Q4_K_M \
  -a "Qwen" \
  -c 131072 \
  -ngl all \
  -ctk q8_0 \
  -ctv q8_0 \
  -sm none \
  -mg 0 \
  -np 1 \
  -fa on \
  --temp 0.7 \
  --top-p 0.8 \
  --top-k 20 \
  --min-p 0.0 \
  --jinja \
  --host 127.0.0.1 \
  --port 8033 \
  --chat-template-kwargs "{\"enable_thinking\": false}"'

alias qwen='llama-server \
  -hf unsloth/Qwen3.5-35B-A3B-GGUF:Q4_K_M \
  -a "Qwen" \
  -c 131072 \
  -ngl all \
  -ctk q8_0 \
  -ctv q8_0 \
  -sm none \
  -mg 0 \
  -np 1 \
  -fa on \
  --temp 0.7 \
  --top-p 0.8 \
  --top-k 20 \
  --min-p 0.0 \
  --jinja \
  --host 127.0.0.1 \
  --port 8033 \
  --chat-template-kwargs "{\"enable_thinking\": false}"'

if command -v zoxide &> /dev/null; then
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

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# Envs
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# Functions
# # Write iso file to sd card
iso2sd() {
  if [ $# -ne 2 ]; then
    echo "Usage: iso2sd <input_file> <output_device>"
    echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
    echo -e "\nAvailable SD cards:"
    lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
  else
    sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
    sudo eject $2
  fi
}

# Format an entire drive for a single partition using exFAT
format-drive() {
  if [ $# -ne 2 ]; then
    echo "Usage: format-drive <device> <name>"
    echo "Example: format-drive /dev/sda 'My Stuff'"
    echo -e "\nAvailable drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    read "confirm?Are you sure you want to continue? (y/N): "

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel gpt
      sudo parted -s "$1" mkpart primary 1MiB 100%

      partition="$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      sudo partprobe "$1" || true
      sudo udevadm settle || true

      sudo mkfs.exfat -n "$2" "$partition"

      echo "Drive $1 formatted as exFAT and labeled '$2'."
    else
      echo "Aborted."
    fi
  fi
}


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"
export PATH="$HOME/:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/simonm/.lmstudio/bin"
# End of LM Studio CLI section

