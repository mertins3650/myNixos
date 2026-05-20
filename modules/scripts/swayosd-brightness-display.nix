{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "swayosd-brightness-display";

        runtimeInputs = with pkgs; [
          brightnessctl
          coreutils
          util-linux # flock
          gawk
          hyprland
        ];

        text = ''
          set -euo pipefail

          step="''${1:-+5%}"

          if [[ "$step" == "off" ]]; then
            hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' >/dev/null 2>&1 \
              || hyprctl dispatch dpms off >/dev/null 2>&1
            exit 0
          elif [[ "$step" == "on" ]]; then
            hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' >/dev/null 2>&1 \
              || hyprctl dispatch dpms on >/dev/null 2>&1
            exit 0
          fi

          runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}"

          exec 9>"$runtime_dir/omarchy-brightness-display.lock"
          flock -n 9 || exit 0

          device="$(ls -1 /sys/class/backlight 2>/dev/null | head -n1)"

          for candidate in amdgpu_bl* intel_backlight acpi_video*; do
            if [[ -e "/sys/class/backlight/$candidate" ]]; then
              device="$candidate"
              break
            fi
          done

          # Apple fallback removed unless you also convert those scripts

          current=$(brightnessctl -d "$device" -m | cut -d',' -f4 | tr -d '%')

          if [[ "$step" == "+5%" ]]; then
            if (( current < 5 )); then
              target=$((current + 1))
            else
              target=$((current + 5))
            fi

            (( target > 100 )) && target=100
            step="$target%"
          elif [[ "$step" == "5%-" ]]; then
            if (( current <= 5 )); then
              target=$((current - 1))
            else
              target=$((current - 5 ))
            fi

            (( target < 1 )) && target=1
            step="$target%"
          fi

          brightnessctl -d "$device" set "$step" >/dev/null

          swayosd-brightness "$(
            brightnessctl -d "$device" -m | cut -d',' -f4 | tr -d '%'
          )"
        '';
      })
    ];
  };
}
