{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "open";
      runtimeInputs = with pkgs; [
        xdg-utils
      ];

      text = ''
        set -euo pipefail

        if [ "$#" -eq 0 ]; then
            echo "Usage: open <file-or-url> [...]"
            exit 1
        fi

        xdg-open "$@" >/dev/null 2>&1 &
      '';
    })
  ];
}
