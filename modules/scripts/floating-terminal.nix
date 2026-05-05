{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "floating-terminal";
        runtimeInputs = with pkgs; [
          bash
          util-linux
          uwsm
          xdg-terminal-exec
        ];

        text = ''
          cmd="$*"
          exec setsid uwsm app -- xdg-terminal-exec --app-id=org.nixy.terminal --title=nixy -e bash -c "$cmd"
        '';
      })

      (pkgs.writeShellApplication {
        name = "cmd-terminal-cwd";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          gnugrep
          hyprland
          procps
        ];

        text = ''
          terminal_pid=$(hyprctl activewindow | awk '/pid:/ {print $2}')
          shell_pid=$(pgrep -P "$terminal_pid" | tail -n1)

          if [[ -n "$shell_pid" ]]; then
              cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)
              shell=$(readlink -f "/proc/$shell_pid/exe" 2>/dev/null)

              if grep -qs "$shell" /etc/shells && [[ -d "$cwd" ]]; then
                  echo "$cwd"
              else
                  echo "$HOME"
              fi
          else
              echo "$HOME"
          fi
        '';
      })
    ];
  };
}
