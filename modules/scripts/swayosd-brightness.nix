{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "swayosd-brightness";

        runtimeInputs = with pkgs; [
          gawk
        ];

        text = ''
          set -euo pipefail

          percent="''${1:-}"

          if [ -z "$percent" ]; then
              echo "Usage: swayosd-brightness <0-100>" >&2
              exit 1
          fi

          progress="$(awk -v p="$percent" 'BEGIN{printf "%.2f", p/100}')"

          if [[ "$progress" == "0.00" ]]; then
              progress="0.01"
          fi

          swayosd-client-wrapper \
            --custom-icon display-brightness-symbolic \
            --custom-progress "$progress" \
            --custom-progress-text "$(printf '%3d%%' "$percent")"
        '';
      })
    ];
  };
}
