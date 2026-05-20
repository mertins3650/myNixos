{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "swayosd-client";

        runtimeInputs = with pkgs; [
          hyprland
          jq
        ];

        text = ''
          set -euo pipefail

          monitor_focused() {
              hyprctl monitors -j | jq -r '.[] | select(.focused == true).name'
          }

          monitor="$(monitor_focused)"

          exec ${pkgs.swayosd}/bin/swayosd-client \
              --monitor "$monitor" \
              "$@"
        '';
      })
    ];
  };
}
