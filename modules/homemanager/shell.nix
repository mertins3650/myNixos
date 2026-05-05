{...}: {
  flake.homeModules.shell = {pkgs, ...}: {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
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
        '';
      };
    };

    home.packages = with pkgs; [
      eza
      bat
      fzf
      btop
      yazi
      ripgrep
      curl
      wget
      fd
      jq
      opencode
    ];
  };
}
