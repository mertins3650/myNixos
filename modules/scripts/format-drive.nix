{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "format-drive";
        runtimeInputs = with pkgs; [
          coreutils
          util-linux
          parted
          exfatprogs
          gawk
          gnugrep
        ];

        text = ''
          set -euo pipefail

          if [ "$#" -ne 2 ]; then
              echo "Usage: format-drive <device> <name>"
              echo "Example: format-drive /dev/sda 'My Stuff'"
              echo
              echo "Available drives:"
              lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
              exit 1
          fi

          device="$1"
          label="$2"

          echo "WARNING: This will completely erase all data on $device and label it '$label'."
          printf "Are you sure you want to continue? (y/N): "
          read confirm

          case "$confirm" in
              [Yy]*)
                  sudo wipefs -a "$device"
                  sudo dd if=/dev/zero of="$device" bs=1M count=100 status=progress
                  sudo parted -s "$device" mklabel gpt
                  sudo parted -s "$device" mkpart primary 1MiB 100%

                  if echo "$device" | grep -q "nvme"; then
                      partition="''${device}p1"
                  else
                      partition="''${device}1"
                  fi

                  sudo partprobe "$device" || true
                  sudo udevadm settle || true

                  sudo mkfs.exfat -n "$label" "$partition"

                  echo "Drive $device formatted as exFAT and labeled '$label'."
                  ;;
              *)
                  echo "Aborted."
                  exit 1
                  ;;
          esac
        '';
      })
    ];
  };
}
