{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "swayosd-client-wrapper";

        runtimeInputs = with pkgs; [
          hyprland
          jq
          swayosd
        ];

        text = ''
          set -euo pipefail

          monitor() {
              hyprctl monitors -j | jq -r '.[] | select(.focused == true).name'
          }

          exec swayosd-client \
              --monitor "$(monitor)" \
              "$@"
        '';
      })
    ];
  };
}
